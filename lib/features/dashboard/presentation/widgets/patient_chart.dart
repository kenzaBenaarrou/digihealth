import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/chart_export_utils.dart';
import 'border_painter.dart';

/// A generic StatefulWidget that displays a trend chart with range slider functionality.
/// Allows users to dynamically control which portion of the data is displayed.
/// Works with any data type T by using transformer functions.
///
/// **Features:**
/// - Range slider to zoom into specific data portions
/// - Navigation buttons (Précédent/Suivant) to move the range
/// - Export menu (PNG, JPG, PDF, CSV, XLSX)
/// - Dynamic statistics (Début, Fin, Total)
/// - Responsive design with flutter_screenutil
/// - Dark futuristic theme with customizable colors
///
/// **Usage Example:**
/// ```dart
/// // Example 1: With PatientEvolution
/// PatientsTrendChart<PatientEvolution>(
///   data: patientData,
///   chartTitle: 'Patients',
///   getLabel: (item) => item.date,
///   getValue: (item) => double.tryParse(item.total) ?? 0,
///   lineColor: Color(0xFF00E5C0),
///   accentColor: Colors.cyanAccent,
/// )
///
/// // Example 2: With custom data type
/// PatientsTrendChart<SalesData>(
///   data: salesData,
///   chartTitle: 'Revenue',
///   getLabel: (item) => item.month,
///   getValue: (item) => item.amount,
///   lineColor: Colors.blue,
///   accentColor: Colors.lightBlue,
/// )
/// ```
class PatientsTrendChart<T> extends StatefulWidget {
  final List<T>? data;
  final String chartTitle;
  final String Function(T item) getLabel; // Extract date/label from item
  final double Function(T item) getValue; // Extract numeric value from item
  final Color lineColor;
  final Color accentColor;

  const PatientsTrendChart({
    super.key,
    required this.data,
    this.chartTitle = 'Patients',
    required this.getLabel,
    required this.getValue,
    this.lineColor = const Color(0xFF00E5C0),
    this.accentColor = Colors.cyanAccent,
  });

  @override
  State<PatientsTrendChart<T>> createState() => _PatientsTrendChartState<T>();
}

class _PatientsTrendChartState<T> extends State<PatientsTrendChart<T>> {
  // Range values for the slider (start and end indices)
  RangeValues _currentRange = const RangeValues(0, 10);

  // Step size for "Précédent" and "Suivant" buttons
  static const int _navigationStep = 5;

  // GlobalKey for RepaintBoundary to capture the chart
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  // Chart export utility - lazy getter
  ChartExportUtils get _exporter => ChartExportUtils(
        repaintBoundaryKey: _repaintBoundaryKey,
        chartTitle: widget.chartTitle,
      );

  @override
  void initState() {
    super.initState();
    _initializeRange();
  }

  @override
  void didUpdateWidget(PatientsTrendChart<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Reinitialize range if data changes
    if (widget.data != oldWidget.data) {
      _initializeRange();
    }
  }

  /// Initialize the range based on available data
  void _initializeRange() {
    if (widget.data != null && widget.data!.isNotEmpty) {
      final dataLength = widget.data!.length;
      setState(() {
        _currentRange = RangeValues(
          0,
          dataLength > 10 ? 10.0 : dataLength.toDouble() - 1,
        );
      });
    }
  }

  /// Get the visible portion of data based on current range
  List<T> get _visibleData {
    if (widget.data == null || widget.data!.isEmpty) return [];

    final startIndex = _currentRange.start.toInt();
    final endIndex =
        (_currentRange.end.toInt() + 1).clamp(0, widget.data!.length);

    return widget.data!.sublist(startIndex, endIndex);
  }

  /// Calculate total sum of visible data
  double get _visibleTotal {
    if (_visibleData.isEmpty) return 0;
    return _visibleData.map((e) => widget.getValue(e)).reduce((a, b) => a + b);
  }

  /// Move range backward by navigation step
  void _moveToPrevious() {
    if (widget.data == null || widget.data!.isEmpty) return;

    final rangeSize = _currentRange.end - _currentRange.start;
    final newStart = (_currentRange.start - _navigationStep)
        .clamp(0.0, widget.data!.length - rangeSize - 1);
    final newEnd = newStart + rangeSize;

    setState(() {
      _currentRange = RangeValues(newStart, newEnd);
    });
  }

  /// Move range forward by navigation step
  void _moveToNext() {
    if (widget.data == null || widget.data!.isEmpty) return;

    final rangeSize = _currentRange.end - _currentRange.start;
    final maxEnd = widget.data!.length - 1.0;
    final newEnd =
        (_currentRange.end + _navigationStep).clamp(rangeSize, maxEnd);
    final newStart = newEnd - rangeSize;

    setState(() {
      _currentRange = RangeValues(newStart, newEnd);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Convert visible data to FlSpot points using transformer function
    final List<FlSpot> visibleSpots = _visibleData
        .asMap()
        .entries
        .map((entry) =>
            FlSpot(entry.key.toDouble(), widget.getValue(entry.value)))
        .toList();

    // Get max value for dynamic interval calculation
    final maxY = visibleSpots.isNotEmpty
        ? visibleSpots.map((spot) => spot.y).reduce((a, b) => a > b ? a : b)
        : 1000;
    // Calculate interval for Y-axis (start from 0, divide into ~5 sections)
    final interval =
        maxY > 0 ? (maxY < 1 ? maxY / 5 : (maxY / 5).ceilToDouble()) : 200.0;

// Calculate X-axis interval to show max 4-5 dates with proper spacing
    final xAxisInterval = _visibleData.length <= 4
        ? 1.0
        : (_visibleData.length / 4).ceilToDouble();

    // Check if navigation buttons should be enabled
    final canMovePrevious = widget.data != null && _currentRange.start > 0;
    final canMoveNext =
        widget.data != null && _currentRange.end < widget.data!.length - 1;

    return Stack(
      children: [
        RepaintBoundary(
          key: _repaintBoundaryKey,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0A1F38),
            ),
            child: Stack(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 25.w, vertical: 15.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header with title (without export button)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 8.w,
                                height: 8.h,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00E5C0),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              8.horizontalSpace,
                              Text(
                                widget.chartTitle,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                      20.verticalSpace,
                      // Line Chart
                      SizedBox(
                        height: 220.h,
                        child: visibleSpots.isEmpty
                            ? Center(
                                child: Text(
                                  'No data available',
                                  style: TextStyle(
                                      color: Colors.white60, fontSize: 14.sp),
                                ),
                              )
                            : LineChart(
                                LineChartData(
                                  minY: 0, // Always start Y-axis from 0
                                  minX: 0, // Start X-axis from 0
                                  maxX: visibleSpots.isNotEmpty
                                      ? (visibleSpots.length - 1).toDouble()
                                      : 1, // End X-axis at last data point
                                  gridData: FlGridData(
                                    show: true,
                                    horizontalInterval: interval,
                                    verticalInterval: xAxisInterval,
                                    getDrawingHorizontalLine: (value) => FlLine(
                                      color: Colors.white.withOpacity(0.08),
                                      strokeWidth: 1,
                                    ),
                                  ),
                                  titlesData: FlTitlesData(
                                    show: true,
                                    leftTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 40.w,
                                        interval: interval,
                                        getTitlesWidget: (value, meta) {
                                          if (value >= 1000) {
                                            return Text(
                                              '${(value / 1000).toStringAsFixed(1)}K',
                                              style: TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 11.sp),
                                            );
                                          }
                                          return Text(
                                            value % 1 == 0
                                                ? value.toInt().toString()
                                                : value.toStringAsFixed(1),
                                            style: TextStyle(
                                                color: Colors.white70,
                                                fontSize: 11.sp),
                                          );
                                        },
                                      ),
                                    ),
                                    bottomTitles: AxisTitles(
                                      sideTitles: SideTitles(
                                        showTitles: true,
                                        reservedSize: 50.h,
                                        interval: xAxisInterval,
                                        getTitlesWidget: (value, meta) {
                                          int index = value.toInt();
                                          // Show max 4-5 dates evenly distributed with rotation
                                          if (index >= 0 &&
                                              index < _visibleData.length) {
                                            return Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8.h, right: 4.w),
                                              child: Transform.rotate(
                                                angle:
                                                    -0.8, // ~-30 degrees for better readability
                                                child: Text(
                                                  widget.getLabel(
                                                      _visibleData[index]),
                                                  style: TextStyle(
                                                    color: Colors.white60,
                                                    fontSize: 8.5.sp,
                                                  ),
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            );
                                          }
                                          return const Text('');
                                        },
                                      ),
                                    ),
                                    topTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                    rightTitles: const AxisTitles(
                                        sideTitles:
                                            SideTitles(showTitles: false)),
                                  ),
                                  borderData: FlBorderData(show: false),
                                  lineBarsData: [
                                    LineChartBarData(
                                      spots: visibleSpots,
                                      isCurved: true,
                                      color: widget.accentColor,
                                      barWidth: 2,
                                      dotData: FlDotData(
                                        show: true,
                                        getDotPainter:
                                            (spot, percent, barData, index) {
                                          return FlDotCirclePainter(
                                            radius: spot.y == 0 ? 0 : 1,
                                            color: widget.accentColor,
                                            strokeColor: widget.accentColor,
                                            strokeWidth: 0.5,
                                          );
                                        },
                                      ),
                                      belowBarData: BarAreaData(
                                        show: true,
                                        color: widget.accentColor
                                            .withOpacity(0.08),
                                      ),
                                    ),
                                  ],
                                  lineTouchData: LineTouchData(
                                    handleBuiltInTouches: true,
                                    touchTooltipData: LineTouchTooltipData(
                                      tooltipRoundedRadius: 10.r,
                                      tooltipPadding:
                                          const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 10),
                                      tooltipBorder: BorderSide(
                                          color: widget.accentColor, width: 1),
                                      getTooltipItems: (touchedSpots) {
                                        return touchedSpots.map((spot) {
                                          int index = spot.x.toInt();
                                          String label = (widget.data != null &&
                                                  index < widget.data!.length)
                                              ? widget
                                                  .getLabel(widget.data![index])
                                              : "";

                                          return LineTooltipItem(
                                            "$label\n${widget.chartTitle}: ${spot.y.toInt()}",
                                            TextStyle(
                                              color: Colors.white,
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }).toList();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                      ),

                      20.verticalSpace,

                      // Bottom Info Bar with dynamic values
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.w, vertical: 12.h),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.cyanAccent),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Zoom sur les \n données",
                                  style: TextStyle(
                                      color: Colors.cyanAccent,
                                      fontSize: 10.sp),
                                ),
                                Row(
                                  children: [
                                    _buildStat(
                                        "Début",
                                        _visibleData.isNotEmpty
                                            ? widget
                                                .getValue(_visibleData.first)
                                                .toInt()
                                                .toString()
                                            : "0"),
                                    16.horizontalSpace,
                                    _buildStat(
                                        "Fin",
                                        _visibleData.isNotEmpty
                                            ? widget
                                                .getValue(_visibleData.last)
                                                .toInt()
                                                .toString()
                                            : "0"),
                                    16.horizontalSpace,
                                    _buildStat("Total",
                                        _visibleTotal.toInt().toString(),
                                        isBold: true),
                                  ],
                                ),
                              ],
                            ),
                            12.verticalSpace,
                            // Range Slider
                            if (widget.data != null && widget.data!.isNotEmpty)
                              _buildRangeSlider(),

                            12.verticalSpace,
                            // Navigation Buttons
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: canMovePrevious
                                        ? _moveToPrevious
                                        : null,
                                    icon:
                                        Icon(Icons.arrow_back_ios, size: 16.sp),
                                    label: Text("Précédent",
                                        style: TextStyle(fontSize: 11.sp)),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.h, horizontal: 2.w),
                                      foregroundColor: Colors.cyanAccent,
                                      backgroundColor: canMovePrevious
                                          ? Colors.cyanAccent.withOpacity(0.2)
                                          : Colors.transparent,
                                      side: BorderSide(
                                        color: canMovePrevious
                                            ? Colors.cyanAccent
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                                12.horizontalSpace,
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: canMoveNext ? _moveToNext : null,
                                    iconAlignment: IconAlignment.end,
                                    icon: Icon(Icons.arrow_forward_ios,
                                        size: 16.sp),
                                    label: Text("Suivant",
                                        style: TextStyle(fontSize: 11.sp)),
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5.h, horizontal: 2.w),
                                      foregroundColor: Colors.cyanAccent,
                                      backgroundColor: canMoveNext
                                          ? Colors.cyanAccent.withOpacity(0.2)
                                          : Colors.transparent,
                                      side: BorderSide(
                                        color: canMoveNext
                                            ? Colors.cyanAccent
                                            : Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Corner border painter overlay - ignore pointer to allow slider interaction
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      painter: CornerBorderPainter(
                        color: Colors.cyanAccent,
                        strokeWidth: 2.5,
                        cornerLength: 15,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        // Export button positioned outside RepaintBoundary (won't appear in screenshots)
        Positioned(
          top: 0.h,
          right: 25.w,
          child: _buildExportMenu(),
        ),
      ],
    );
  }

  /// Build the range slider widget
  Widget _buildRangeSlider() {
    final maxValue = widget.data!.length - 1.0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: Column(
        children: [
          // Slider
          SliderTheme(
            data: SliderThemeData(
              activeTrackColor: const Color(0xFF00E5C0),
              inactiveTrackColor: Colors.white.withOpacity(0.15),
              thumbColor: const Color(0xFF00E5C0),
              overlayColor: const Color(0xFF00E5C0).withOpacity(0.2),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 8.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 16.r),
              rangeThumbShape: RoundRangeSliderThumbShape(
                enabledThumbRadius: 8.r,
              ),
              rangeTrackShape: const RoundedRectRangeSliderTrackShape(),
              valueIndicatorColor: const Color(0xFF00E5C0),
              valueIndicatorTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            child: RangeSlider(
              values: _currentRange,
              min: 0,
              max: maxValue,
              divisions: widget.data!.length > 1 ? widget.data!.length - 1 : 1,
              labels: RangeLabels(
                _currentRange.start.toInt().toString(),
                _currentRange.end.toInt().toString(),
              ),
              onChanged: (RangeValues values) {
                setState(() {
                  _currentRange = values;
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Build a stat widget with label and value
  Widget _buildStat(String label, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white60, fontSize: 10.sp),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 10.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  /// Build export menu button with format options
  Widget _buildExportMenu() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.save_alt_rounded,
        color: Colors.cyanAccent,
        size: 20.sp,
      ),
      color: const Color(0xFF0A1F38),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
        side: BorderSide(
          color: Colors.cyanAccent.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      offset: Offset(0, 40.h),
      itemBuilder: (BuildContext context) => [
        _buildExportMenuItem('PNG', Icons.image_outlined),
        _buildExportMenuItem('JPG', Icons.photo_outlined),
        _buildExportMenuItem('PDF', Icons.picture_as_pdf_outlined),
        _buildExportMenuItem('CSV', Icons.table_chart_outlined),
        _buildExportMenuItem('XLSX', Icons.grid_on_outlined),
      ],
      onSelected: _handleExport,
    );
  }

  /// Build individual export menu item
  PopupMenuItem<String> _buildExportMenuItem(String format, IconData icon) {
    return PopupMenuItem<String>(
      value: format,
      height: 45.h,
      child: Row(
        children: [
          Icon(
            icon,
            color: Colors.cyanAccent,
            size: 18.sp,
          ),
          12.horizontalSpace,
          Text(
            '.${format}',
            style: TextStyle(
              color: Colors.white,
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Handle export action
  Future<void> _handleExport(String format) async {
    if (format == 'PNG' || format == 'JPG') {
      await _exporter.exportAsImage(
        context: context,
        format: format,
      );
    } else if (format == 'PDF') {
      // Get date range from visible data
      String dateRange = '';
      if (_visibleData.isNotEmpty) {
        final firstDate = widget.getLabel(_visibleData.first);
        final lastDate = widget.getLabel(_visibleData.last);
        dateRange = 'Période: $firstDate - $lastDate';
      }
      await _exporter.exportAsPdf(
        context: context,
        dateRange: dateRange,
      );
    } else if (format == 'CSV') {
      await _exporter.exportAsCsv<T>(
        context: context,
        data: _visibleData,
        getLabel: widget.getLabel,
        getValue: widget.getValue,
      );
    } else if (format == 'XLSX') {
      await _exporter.exportAsXlsx<T>(
        context: context,
        data: _visibleData,
        getLabel: widget.getLabel,
        getValue: widget.getValue,
        includeTotal: true,
      );
    }
  }
}
