import 'package:digihealth/generated_assets/assets.gen.dart';
import 'package:digihealth/models/speciality_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/utils/chart_export_utils.dart';
import 'border_painter.dart';

class AgeDistributionChart extends StatefulWidget {
  final List<Speciality> specialties;

  const AgeDistributionChart({super.key, required this.specialties});

  @override
  State<AgeDistributionChart> createState() => _AgeDistributionChartState();
}

class _AgeDistributionChartState extends State<AgeDistributionChart> {
  // GlobalKey for RepaintBoundary to capture the chart
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  // Chart export utility - lazy getter
  ChartExportUtils get _exporter => ChartExportUtils(
        repaintBoundaryKey: _repaintBoundaryKey,
        chartTitle: 'Specialties Distribution',
      );

  @override
  Widget build(BuildContext context) {
    final total = widget.specialties.fold(0, (sum, item) => sum + item.COUNT);

    return Stack(
      children: [
        RepaintBoundary(
          key: _repaintBoundaryKey,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0A1F38),
              borderRadius: BorderRadius.circular(20.r),
            ),
            child: Stack(
              children: [
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 25.h),
                  child: Column(
                    children: [
                      // Pie Chart
                      SizedBox(
                        height: 210.h,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 3,
                            centerSpaceRadius: 40.r,
                            // startDegreeOffset: -90,
                            sections: widget.specialties.map((item) {
                              final percentage = (item.COUNT / total) * 100;
                              return PieChartSectionData(
                                color: _hexToColor(item.color ?? "#000000"),
                                value: item.COUNT.toDouble(),
                                title: "${percentage.toStringAsFixed(0)}%",
                                titleStyle: TextStyle(
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                radius: 85.r,
                              );
                            }).toList(),
                          ),
                        ),
                      ),

                      24.verticalSpace,

                      // Legend
                      Wrap(
                        spacing: 20.w,
                        runSpacing: 14.h,
                        alignment: WrapAlignment.spaceBetween,
                        children: widget.specialties.map((item) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5.w,
                                height: 5.w,
                                decoration: BoxDecoration(
                                  color: _hexToColor(item.color ?? "#000000"),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              5.horizontalSpace,
                              SvgPicture.asset(
                                "assets/svg/${item.specialite.toLowerCase()}.svg",
                                width: 14.w,
                                height: 14.h,
                              ),
                              10.horizontalSpace,
                              Text(
                                item.specialite[0].toUpperCase() +
                                    item.specialite.substring(1),
                                style: TextStyle(
                                    color: Colors.white, fontSize: 11.sp),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                // Corner border painter overlay
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
        // Export button positioned outside RepaintBoundary
        Positioned(
          top: 15.h,
          right: 20.w,
          child: _buildExportMenu(),
        ),
      ],
    );
  }

  /// Build export dropdown menu
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
      onSelected: _handleExport,
      itemBuilder: (context) => [
        _buildMenuItem('PNG', Icons.image),
        _buildMenuItem('JPG', Icons.photo),
        _buildMenuItem('PDF', Icons.picture_as_pdf),
        _buildMenuItem('CSV', Icons.table_chart),
        _buildMenuItem('XLSX', Icons.description),
      ],
    );
  }

  /// Build a menu item
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

  /// Handle export action
  Future<void> _handleExport(String format) async {
    if (format == 'PNG' || format == 'JPG') {
      await _exporter.exportAsImage(
        context: context,
        format: format,
      );
    } else if (format == 'PDF') {
      await _exporter.exportAsPdf(
        context: context,
        additionalInfo:
            'Distribution of ${widget.specialties.length} specialties',
      );
    } else if (format == 'CSV') {
      await _exporter.exportAsCsv<Speciality>(
        context: context,
        data: widget.specialties,
        getLabel: (item) => item.specialite,
        getValue: (item) => item.COUNT.toDouble(),
        valueColumnName: 'Count',
      );
    } else if (format == 'XLSX') {
      await _exporter.exportAsXlsx<Speciality>(
        context: context,
        data: widget.specialties,
        getLabel: (item) => item.specialite,
        getValue: (item) => item.COUNT.toDouble(),
        valueColumnName: 'Count',
        includeTotal: true,
      );
    }
  }

  // Helper to convert hex string to Color
  Color _hexToColor(String hex) {
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) {
      hex = 'FF$hex';
    }
    return Color(int.parse(hex, radix: 16));
  }
}
