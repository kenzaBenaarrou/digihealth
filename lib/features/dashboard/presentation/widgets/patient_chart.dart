import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'border_painter.dart';

class PatientsTrendChart extends StatelessWidget {
  const PatientsTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0A1F38),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with Legend

                // Line Chart
                SizedBox(
                  height: 220.h,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        horizontalInterval: 200,
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
                            interval: 200,
                            getTitlesWidget: (value, meta) {
                              return Text(
                                value.toInt() == 1000
                                    ? '1.0K'
                                    : value.toInt().toString(),
                                style: TextStyle(
                                    color: Colors.white70, fontSize: 11.sp),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 35.h,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              const dates = [
                                "2024-10-18",
                                "2024-11-07",
                                "2024-11-27",
                                "2024-12-15",
                                "2025-01-02",
                                "2025-01-17"
                              ];
                              int index = value.toInt();
                              if (index >= 0 && index < dates.length) {
                                return Padding(
                                  padding: EdgeInsets.only(top: 8.h),
                                  child: Text(
                                    dates[index],
                                    style: TextStyle(
                                      color: Colors.white60,
                                      fontSize: 9.5.sp,
                                    ),
                                  ),
                                );
                              }
                              return const Text('');
                            },
                          ),
                        ),
                        topTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(
                            sideTitles: SideTitles(showTitles: false)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 620),
                            FlSpot(1, 980),
                            FlSpot(2, 550),
                            FlSpot(3, 820),
                            FlSpot(4, 650),
                            FlSpot(5, 880),
                            FlSpot(6, 720),
                            FlSpot(7, 0), // Sharp drop
                            FlSpot(8, 780),
                            FlSpot(9, 810),
                            FlSpot(10, 650),
                          ],
                          isCurved: true,
                          color: const Color(0xFF00E5C0),
                          barWidth: 2.8,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) {
                              return FlDotCirclePainter(
                                radius: spot.y == 0 ? 0 : 3.5,
                                color: const Color(0xFF00E5C0),
                                strokeColor: Colors.black,
                                strokeWidth: 2,
                              );
                            },
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: const Color(0xFF00E5C0).withOpacity(0.08),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                20.verticalSpace,

                // Bottom Info Bar
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  decoration: BoxDecoration(
                    color: const Color(0xFF051024),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Zoom sur les données",
                            style: TextStyle(
                                color: Colors.white70, fontSize: 13.sp),
                          ),
                          Row(
                            children: [
                              _buildStat("Début", "256"),
                              16.horizontalSpace,
                              _buildStat("Fin", "318"),
                              16.horizontalSpace,
                              _buildStat("Total", "633", isBold: true),
                            ],
                          ),
                        ],
                      ),
                      12.verticalSpace,
                      // Navigation Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.arrow_back_ios, size: 16),
                              label: const Text("Précédent"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white70,
                                side: const BorderSide(color: Colors.white24),
                              ),
                            ),
                          ),
                          12.horizontalSpace,
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () {},
                              icon:
                                  const Icon(Icons.arrow_forward_ios, size: 16),
                              label: const Text("Suivant"),
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.white70,
                                side: const BorderSide(color: Colors.white24),
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
          Positioned.fill(
            child: CustomPaint(
              painter: CornerBorderPainter(
                color: Colors.cyanAccent,
                strokeWidth: 2.5,
                cornerLength: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white60, fontSize: 11.sp),
        ),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 15.sp,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
