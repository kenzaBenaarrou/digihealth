import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:csv/csv.dart';
import 'package:excel/excel.dart' as excel_pkg;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:gal/gal.dart';
import 'package:image/image.dart' as img;
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';

/// Generic chart export utilities
///
/// Provides reusable export functionality for charts to various formats:
/// - PNG and JPG images
/// - PDF documents
/// - CSV spreadsheets
/// - XLSX (Excel) files
///
/// **Usage Example:**
/// ```dart
/// // Create an instance with your chart's RepaintBoundary key
/// final exporter = ChartExportUtils(
///   repaintBoundaryKey: _chartKey,
///   chartTitle: 'Sales Report',
/// );
///
/// // Export as PNG
/// await exporter.exportAsImage(
///   context: context,
///   format: 'PNG',
///   onSuccess: () => print('Exported!'),
///   onError: (error) => print('Error: $error'),
/// );
///
/// // Export as PDF with data range
/// await exporter.exportAsPdf(
///   context: context,
///   dateRange: 'Jan 2024 - Dec 2024',
///   onSuccess: () => print('Exported!'),
///   onError: (error) => print('Error: $error'),
/// );
///
/// // Export data as CSV
/// await exporter.exportAsCsv<SalesData>(
///   context: context,
///   data: salesList,
///   getLabel: (item) => item.month,
///   getValue: (item) => item.amount,
///   valueColumnName: 'Amount',
///   onSuccess: () => print('Exported!'),
///   onError: (error) => print('Error: $error'),
/// );
/// ```
class ChartExportUtils {
  /// GlobalKey for the RepaintBoundary wrapping the chart
  final GlobalKey repaintBoundaryKey;

  /// Title of the chart (used in filenames and PDF header)
  final String chartTitle;

  ChartExportUtils({
    required this.repaintBoundaryKey,
    required this.chartTitle,
  });

  /// Export chart as image (PNG or JPG)
  ///
  /// [context] - BuildContext for showing snackbar messages
  /// [format] - Either 'PNG' or 'JPG'
  /// [onSuccess] - Optional callback when export succeeds
  /// [onError] - Optional callback when export fails with error message
  Future<void> exportAsImage({
    required BuildContext context,
    required String format,
    VoidCallback? onSuccess,
    Function(String error)? onError,
  }) async {
    try {
      // Request storage permission (Android 13+ uses photos permission)
      if (Platform.isAndroid) {
        PermissionStatus status;
        if (await Permission.photos.isGranted) {
          status = PermissionStatus.granted;
        } else {
          status = await Permission.photos.request();
          if (status.isDenied || status.isPermanentlyDenied) {
            // Fallback to storage permission for older Android versions
            status = await Permission.storage.request();
          }
        }
        if (!status.isGranted) {
          final errorMsg = 'Permission refusée pour accéder au stockage';
          _showSnackbar(context, errorMsg, isSuccess: false);
          onError?.call(errorMsg);
          return;
        }
      } else if (Platform.isIOS) {
        final status = await Permission.photos.request();
        if (!status.isGranted) {
          final errorMsg = 'Permission refusée pour accéder aux photos';
          _showSnackbar(context, errorMsg, isSuccess: false);
          onError?.call(errorMsg);
          return;
        }
      }

      // Capture the widget as an image
      final RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        final errorMsg = 'Erreur lors de la capture de l\'image';
        _showSnackbar(context, errorMsg, isSuccess: false);
        onError?.call(errorMsg);
        return;
      }

      // Get the directory to save the image
      Directory? directory;
      if (Platform.isAndroid) {
        directory = await getExternalStorageDirectory();
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getDownloadsDirectory();
      }

      if (directory == null) {
        final errorMsg = 'Impossible d\'accéder au dossier de téléchargement';
        _showSnackbar(context, errorMsg, isSuccess: false);
        onError?.call(errorMsg);
        return;
      }

      // Create a unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final String fileName =
          'chart_${chartTitle.toLowerCase().replaceAll(' ', '_')}_$timestamp';

      String filePath;

      if (format == 'PNG') {
        // Save as PNG directly
        filePath = '${directory.path}/$fileName.png';
        final File file = File(filePath);
        await file.writeAsBytes(byteData.buffer.asUint8List());
        debugPrint('PNG saved to: $filePath');
      } else {
        // Convert to JPG
        final pngBytes = byteData.buffer.asUint8List();
        final img.Image? originalImage = img.decodeImage(pngBytes);

        if (originalImage == null) {
          final errorMsg = 'Erreur lors de la conversion de l\'image';
          _showSnackbar(context, errorMsg, isSuccess: false);
          onError?.call(errorMsg);
          return;
        }

        // Encode as JPG with white background (since JPG doesn't support transparency)
        final img.Image jpgImage = img.Image(
          width: originalImage.width,
          height: originalImage.height,
        );

        // Fill with white background
        img.fill(jpgImage, color: img.ColorRgb8(255, 255, 255));

        // Composite original image on top
        img.compositeImage(jpgImage, originalImage);

        final jpgBytes = img.encodeJpg(jpgImage, quality: 95);

        filePath = '${directory.path}/$fileName.jpg';
        final File file = File(filePath);
        await file.writeAsBytes(jpgBytes);
        debugPrint('JPG saved to: $filePath');
      }

      // Save to gallery using gal package
      if (Platform.isAndroid || Platform.isIOS) {
        await Gal.putImage(filePath);
        debugPrint('Image saved to gallery: $filePath');
      }

      _showSnackbar(context, 'Image sauvegardée avec succès', isSuccess: true);
      onSuccess?.call();
    } catch (e, stackTrace) {
      debugPrint('Error exporting image: $e');
      debugPrint('Stack trace: $stackTrace');
      final errorMsg = 'Erreur lors de l\'exportation: ${e.toString()}';
      _showSnackbar(context, errorMsg, isSuccess: false);
      onError?.call(errorMsg);
    }
  }

  /// Export chart as PDF
  ///
  /// [context] - BuildContext for showing snackbar messages
  /// [dateRange] - Optional date range to display in PDF (e.g., "Jan 2024 - Dec 2024")
  /// [additionalInfo] - Optional additional information to display in PDF
  /// [onSuccess] - Optional callback when export succeeds
  /// [onError] - Optional callback when export fails with error message
  Future<void> exportAsPdf({
    required BuildContext context,
    String? dateRange,
    String? additionalInfo,
    VoidCallback? onSuccess,
    Function(String error)? onError,
  }) async {
    try {
      // Capture the widget as an image
      final RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        final errorMsg = 'Erreur lors de la capture de l\'image';
        _showSnackbar(context, errorMsg, isSuccess: false);
        onError?.call(errorMsg);
        return;
      }

      // Convert to Uint8List for PDF
      final Uint8List imageBytes = byteData.buffer.asUint8List();

      // Create PDF document
      final pdf = pw.Document();

      // Get current date for the PDF
      final String currentDate =
          DateFormat('dd/MM/yyyy').format(DateTime.now());

      // Add page to PDF
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Title
                pw.Text(
                  chartTitle.toUpperCase(),
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
                pw.SizedBox(height: 10),
                // Date range
                if (dateRange != null && dateRange.isNotEmpty)
                  pw.Text(
                    dateRange,
                    style: const pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.grey700,
                    ),
                  ),
                // Additional info
                if (additionalInfo != null && additionalInfo.isNotEmpty)
                  pw.Text(
                    additionalInfo,
                    style: const pw.TextStyle(
                      fontSize: 11,
                      color: PdfColors.grey700,
                    ),
                  ),
                pw.SizedBox(height: 5),
                // Generation date
                pw.Text(
                  'Généré le: $currentDate',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                  ),
                ),
                pw.SizedBox(height: 30),
                // Chart image
                pw.Expanded(
                  child: pw.Center(
                    child: pw.Image(
                      pw.MemoryImage(imageBytes),
                      fit: pw.BoxFit.contain,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),
                // Footer
                pw.Divider(color: PdfColors.grey400),
                pw.SizedBox(height: 10),
                pw.Text(
                  'DigiHealth - Rapport généré automatiquement',
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey600,
                  ),
                ),
              ],
            );
          },
        ),
      );

      // Get the public Downloads directory (visible in Files app)
      String savePath;
      if (Platform.isAndroid) {
        // Public Downloads folder on Android - always visible in Files app
        savePath = '/storage/emulated/0/Download';
      } else if (Platform.isIOS) {
        // For iOS, use app documents directory
        final directory = await getApplicationDocumentsDirectory();
        savePath = directory.path;
      } else {
        final directory = await getDownloadsDirectory();
        savePath = directory?.path ?? '';
      }

      if (savePath.isEmpty) {
        final errorMsg = 'Impossible d\'accéder au dossier de téléchargement';
        _showSnackbar(context, errorMsg, isSuccess: false);
        onError?.call(errorMsg);
        return;
      }

      // Create Download directory if it doesn't exist
      final downloadDir = Directory(savePath);
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      // Create a unique filename with timestamp
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final String fileName =
          'DigiHealth_${chartTitle.toLowerCase().replaceAll(' ', '_')}_$timestamp.pdf';
      final String filePath = '$savePath/$fileName';

      // Save PDF to file
      final File file = File(filePath);
      await file.writeAsBytes(await pdf.save());

      debugPrint('PDF saved to: $filePath');
      _showSnackbar(context, 'PDF sauvegardé dans Téléchargements',
          isSuccess: true);
      onSuccess?.call();
    } catch (e, stackTrace) {
      debugPrint('Error exporting PDF: $e');
      debugPrint('Stack trace: $stackTrace');
      final errorMsg = 'Erreur lors de l\'exportation PDF: ${e.toString()}';
      _showSnackbar(context, errorMsg, isSuccess: false);
      onError?.call(errorMsg);
    }
  }

  /// Export chart data as CSV
  ///
  /// Generic method that works with any data type T
  ///
  /// [context] - BuildContext for showing snackbar messages
  /// [data] - List of data items to export
  /// [getLabel] - Function to extract label/date from each data item
  /// [getValue] - Function to extract numeric value from each data item
  /// [valueColumnName] - Name for the value column (defaults to chartTitle)
  /// [onSuccess] - Optional callback when export succeeds
  /// [onError] - Optional callback when export fails with error message
  Future<void> exportAsCsv<T>({
    required BuildContext context,
    required List<T> data,
    required String Function(T item) getLabel,
    required double Function(T item) getValue,
    String? valueColumnName,
    VoidCallback? onSuccess,
    Function(String error)? onError,
  }) async {
    try {
      // Check if there's data
      if (data.isEmpty) {
        final errorMsg = 'Aucune donnée à exporter';
        _showSnackbar(context, errorMsg, isSuccess: false);
        onError?.call(errorMsg);
        return;
      }

      // Create CSV data with headers
      List<List<dynamic>> csvData = [
        ['Date', valueColumnName ?? chartTitle], // Headers
      ];

      // Add data rows
      for (var item in data) {
        csvData.add([
          getLabel(item),
          getValue(item).toInt().toString(),
        ]);
      }

      // Convert to CSV string
      String csvString = const ListToCsvConverter().convert(csvData);

      // Get the public Downloads directory
      String savePath;
      if (Platform.isAndroid) {
        savePath = '/storage/emulated/0/Download';
      } else if (Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        savePath = directory.path;
      } else {
        final directory = await getDownloadsDirectory();
        savePath = directory?.path ?? '';
      }

      if (savePath.isEmpty) {
        final errorMsg = 'Impossible d\'accéder au dossier de téléchargement';
        _showSnackbar(context, errorMsg, isSuccess: false);
        onError?.call(errorMsg);
        return;
      }

      // Create Download directory if it doesn't exist
      final downloadDir = Directory(savePath);
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      // Create filename with current date
      final String currentDate =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
      final String fileName =
          '${chartTitle.toLowerCase().replaceAll(' ', '_')}_$currentDate.csv';
      final String filePath = '$savePath/$fileName';

      // Save CSV to file
      final File file = File(filePath);
      await file.writeAsString(csvString);

      debugPrint('CSV saved to: $filePath');
      _showSnackbar(context, 'CSV sauvegardé dans Téléchargements',
          isSuccess: true);
      onSuccess?.call();
    } catch (e, stackTrace) {
      debugPrint('Error exporting CSV: $e');
      debugPrint('Stack trace: $stackTrace');
      final errorMsg = 'Erreur lors de l\'exportation CSV: ${e.toString()}';
      _showSnackbar(context, errorMsg, isSuccess: false);
      onError?.call(errorMsg);
    }
  }

  /// Export chart data as XLSX (Excel)
  ///
  /// Generic method that works with any data type T
  ///
  /// [context] - BuildContext for showing snackbar messages
  /// [data] - List of data items to export
  /// [getLabel] - Function to extract label/date from each data item
  /// [getValue] - Function to extract numeric value from each data item
  /// [valueColumnName] - Name for the value column (defaults to chartTitle)
  /// [includeTotal] - Whether to add a total row at the bottom (default: true)
  /// [onSuccess] - Optional callback when export succeeds
  /// [onError] - Optional callback when export fails with error message
  Future<void> exportAsXlsx<T>({
    required BuildContext context,
    required List<T> data,
    required String Function(T item) getLabel,
    required double Function(T item) getValue,
    String? valueColumnName,
    bool includeTotal = true,
    VoidCallback? onSuccess,
    Function(String error)? onError,
  }) async {
    try {
      // Check if there's data
      if (data.isEmpty) {
        final errorMsg = 'Aucune donnée à exporter';
        _showSnackbar(context, errorMsg, isSuccess: false);
        onError?.call(errorMsg);
        return;
      }

      // Create Excel file
      var excel = excel_pkg.Excel.createExcel();
      var sheet = excel['Données'];

      // Add title row
      sheet.appendRow([
        excel_pkg.TextCellValue('Evolution des $chartTitle'),
      ]);

      // Add empty row for spacing
      sheet.appendRow([]);

      // Add header row
      sheet.appendRow([
        excel_pkg.TextCellValue('Date'),
        excel_pkg.TextCellValue(valueColumnName ?? chartTitle),
      ]);

      // Add data rows
      for (var item in data) {
        sheet.appendRow([
          excel_pkg.TextCellValue(getLabel(item)),
          excel_pkg.IntCellValue(getValue(item).toInt()),
        ]);
      }

      // Add total row if requested
      if (includeTotal) {
        // Add empty row for spacing
        sheet.appendRow([]);

        // Add summary row with total
        final total =
            data.map((e) => getValue(e)).reduce((a, b) => a + b).toInt();
        sheet.appendRow([
          excel_pkg.TextCellValue('Total'),
          excel_pkg.IntCellValue(total),
        ]);
      }

      // Get the public Downloads directory
      String savePath;
      if (Platform.isAndroid) {
        savePath = '/storage/emulated/0/Download';
      } else if (Platform.isIOS) {
        final directory = await getApplicationDocumentsDirectory();
        savePath = directory.path;
      } else {
        final directory = await getDownloadsDirectory();
        savePath = directory?.path ?? '';
      }

      if (savePath.isEmpty) {
        final errorMsg = 'Impossible d\'accéder au dossier de téléchargement';
        _showSnackbar(context, errorMsg, isSuccess: false);
        onError?.call(errorMsg);
        return;
      }

      // Create Download directory if it doesn't exist
      final downloadDir = Directory(savePath);
      if (!await downloadDir.exists()) {
        await downloadDir.create(recursive: true);
      }

      // Create filename with current date
      final String currentDate =
          DateFormat('yyyy-MM-dd').format(DateTime.now());
      final String fileName =
          '${chartTitle.toLowerCase().replaceAll(' ', '_')}_$currentDate.xlsx';
      final String filePath = '$savePath/$fileName';

      // Save XLSX to file
      final List<int>? fileBytes = excel.encode();
      if (fileBytes != null) {
        final File file = File(filePath);
        await file.writeAsBytes(fileBytes);

        debugPrint('XLSX saved to: $filePath');
        _showSnackbar(context, 'Fichier XLSX sauvegardé avec succès',
            isSuccess: true);
        onSuccess?.call();
      } else {
        final errorMsg = 'Erreur lors de la génération du fichier XLSX';
        _showSnackbar(context, errorMsg, isSuccess: false);
        onError?.call(errorMsg);
      }
    } catch (e, stackTrace) {
      debugPrint('Error exporting XLSX: $e');
      debugPrint('Stack trace: $stackTrace');
      final errorMsg = 'Erreur lors de l\'exportation XLSX: ${e.toString()}';
      _showSnackbar(context, errorMsg, isSuccess: false);
      onError?.call(errorMsg);
    }
  }

  /// Show snackbar with message
  void _showSnackbar(BuildContext context, String message,
      {required bool isSuccess}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isSuccess ? const Color(0xFF00E5C0) : Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
