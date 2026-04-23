import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/chart_export_utils.dart';

/// Generic reusable chart export menu widget
///
/// Usage:
/// ```dart
/// ChartExportMenu<YourDataType>(
///   repaintBoundaryKey: _chartKey,
///   chartTitle: 'My Chart',
///   data: yourDataList,
///   getLabel: (item) => item.name,
///   getValue: (item) => item.value.toDouble(),
///   valueColumnName: 'Value',
/// )
/// ```
class ChartExportMenu<T> extends StatelessWidget {
  /// The GlobalKey of the RepaintBoundary wrapping the chart
  final GlobalKey repaintBoundaryKey;

  /// Title for the exported chart
  final String chartTitle;

  /// Data to export (for CSV/XLSX)
  final List<T>? data;

  /// Function to get label from data item
  final String Function(T item)? getLabel;

  /// Function to get value from data item
  final double Function(T item)? getValue;

  /// Column name for value in CSV/XLSX
  final String? valueColumnName;

  /// Additional info for PDF export
  final String? additionalInfo;

  /// Whether to include total in XLSX
  final bool includeTotal;

  /// Icon color
  final Color iconColor;

  /// Menu background color
  final Color menuBackgroundColor;

  /// Border color for menu
  final Color menuBorderColor;

  /// Icon size
  final double? iconSize;

  /// Enabled export formats
  final List<ExportFormat> enabledFormats;

  /// Custom icon
  final IconData? customIcon;

  const ChartExportMenu({
    super.key,
    required this.repaintBoundaryKey,
    required this.chartTitle,
    this.data,
    this.getLabel,
    this.getValue,
    this.valueColumnName,
    this.additionalInfo,
    this.includeTotal = true,
    this.iconColor = Colors.cyanAccent,
    this.menuBackgroundColor = const Color(0xFF0A1F38),
    this.menuBorderColor = Colors.cyanAccent,
    this.iconSize,
    this.enabledFormats = const [
      ExportFormat.png,
      ExportFormat.jpg,
      ExportFormat.pdf,
      ExportFormat.csv,
      ExportFormat.xlsx,
    ],
    this.customIcon,
  });

  ChartExportUtils get _exporter => ChartExportUtils(
        repaintBoundaryKey: repaintBoundaryKey,
        chartTitle: chartTitle,
      );

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: Icon(
        customIcon ?? Icons.save_alt_rounded,
        color: iconColor,
        size: iconSize ?? 20.sp,
      ),
      color: menuBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: menuBorderColor.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      offset: Offset(0, 40.h),
      onSelected: (format) => _handleExport(context, format),
      itemBuilder: (context) => _buildMenuItems(),
    );
  }

  List<PopupMenuItem<String>> _buildMenuItems() {
    final items = <PopupMenuItem<String>>[];

    if (enabledFormats.contains(ExportFormat.png)) {
      items.add(_buildMenuItem('PNG', Icons.image));
    }
    if (enabledFormats.contains(ExportFormat.jpg)) {
      items.add(_buildMenuItem('JPG', Icons.photo));
    }
    if (enabledFormats.contains(ExportFormat.pdf)) {
      items.add(_buildMenuItem('PDF', Icons.picture_as_pdf));
    }
    if (enabledFormats.contains(ExportFormat.csv) && data != null) {
      items.add(_buildMenuItem('CSV', Icons.table_chart));
    }
    if (enabledFormats.contains(ExportFormat.xlsx) && data != null) {
      items.add(_buildMenuItem('XLSX', Icons.description));
    }

    return items;
  }

  PopupMenuItem<String> _buildMenuItem(String text, IconData icon) {
    return PopupMenuItem<String>(
      value: text,
      child: Row(
        children: [
          Icon(icon, size: 18.sp, color: const Color(0xFF00E5C0)),
          8.horizontalSpace,
          Text(text),
        ],
      ),
    );
  }

  Future<void> _handleExport(BuildContext context, String format) async {
    if (format == 'PNG' || format == 'JPG') {
      await _exporter.exportAsImage(
        context: context,
        format: format,
      );
    } else if (format == 'PDF') {
      await _exporter.exportAsPdf(
        context: context,
        additionalInfo: additionalInfo ?? 'Chart data',
      );
    } else if (format == 'CSV' &&
        data != null &&
        getLabel != null &&
        getValue != null) {
      await _exporter.exportAsCsv<T>(
        context: context,
        data: data!,
        getLabel: getLabel!,
        getValue: getValue!,
        valueColumnName: valueColumnName ?? 'Value',
      );
    } else if (format == 'XLSX' &&
        data != null &&
        getLabel != null &&
        getValue != null) {
      await _exporter.exportAsXlsx<T>(
        context: context,
        data: data!,
        getLabel: getLabel!,
        getValue: getValue!,
        valueColumnName: valueColumnName ?? 'Value',
        includeTotal: includeTotal,
      );
    }
  }
}

/// Export format options
enum ExportFormat {
  png,
  jpg,
  pdf,
  csv,
  xlsx,
}
