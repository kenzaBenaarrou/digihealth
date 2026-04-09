import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../generated_assets/assets.gen.dart';
import 'border_painter.dart';

class DigiHealthLineChart extends StatefulWidget {
  final double totalValue;
  final double? totalPercentageChange; // e.g. +5.2 or -3.8
  final bool? isChart;
  final List<FlSpot> spots; // Dynamic data

  const DigiHealthLineChart({
    super.key,
    required this.totalValue,
    this.totalPercentageChange,
    this.isChart = true,
    required this.spots,
  });

  @override
  State<DigiHealthLineChart> createState() => _DigiHealthLineChartState();
}

class _DigiHealthLineChartState extends State<DigiHealthLineChart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        // color: const Color(0xFF0A1F38),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Assets.images.consultationLogo.image(
                      width: 50.w,
                      height: 50.h,
                    ),
                    12.horizontalSpace,
                    Text(
                      widget.totalValue.toStringAsFixed(0).replaceAllMapped(
                          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                          (m) => '${m[1]} '),
                      style:
                          Theme.of(context).textTheme.displayMedium?.copyWith(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                    ),
                    if (widget.totalPercentageChange != null) ...[
                      8.horizontalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 4.h),
                        decoration: BoxDecoration(
                          color: widget.totalPercentageChange! >= 0
                              ? Colors.greenAccent.withOpacity(0.2)
                              : Colors.redAccent.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          "${widget.totalPercentageChange! >= 0 ? '+' : ''}${widget.totalPercentageChange!.toStringAsFixed(1)}%",
                          style: TextStyle(
                            color: widget.totalPercentageChange! >= 0
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                if (widget.isChart == true) ...[
                  20.verticalSpace,
                  // Line Chart
                  SizedBox(
                    height: 190.h,
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          horizontalInterval:
                              500, // Space between Y lines (0, 500, 1000)
                          drawVerticalLine: false,
                          drawHorizontalLine: true,
                          getDrawingHorizontalLine: (value) => FlLine(
                            color: Colors.white.withOpacity(0.08),
                            strokeWidth: 1,
                          ),
                          // checkToShowVerticalLine: (value) => value % 1 == 0,
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 32.h,
                              interval: 1,
                              getTitlesWidget: (value, meta) {
                                const labels = [
                                  "2024",
                                  "Jul '24",
                                  "2025",
                                  "Jul '25",
                                  "2026",
                                  "2027"
                                ];
                                int index = value.toInt();
                                if (index >= 0 && index < labels.length) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 8.h),
                                    child: SideTitleWidget(
                                        axisSide: meta.axisSide,
                                        space: 10,
                                        child: Text(
                                          labels[index],
                                          textAlign: TextAlign.center,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Colors.white60,
                                                fontSize: 10.5.sp,
                                              ),
                                        )),

                                    //  Text(
                                    //   labels[index],
                                    //   textAlign: TextAlign.center,
                                    //   style: Theme.of(context)
                                    //       .textTheme
                                    //       .bodySmall
                                    //       ?.copyWith(
                                    //         color: Colors.white60,
                                    //         fontSize: 10.5.sp,
                                    //       ),
                                    // ),
                                  );
                                }
                                return const Text('');
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30.w,
                              interval:
                                  500, // Important: space between 0, 500, 1000
                              getTitlesWidget: (value, meta) {
                                if (value % 500 == 0) {
                                  return Text(
                                    value.toInt().toString(),
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Colors.white70,
                                          fontSize: 11.sp,
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
                            spots: widget.spots,
                            isCurved: true,
                            color: const Color(0xFF00E5C0),
                            barWidth: 2.8,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: index == widget.spots.length - 1
                                      ? 4.5
                                      : 3.5,
                                  color: const Color(0xFF00E5C0),
                                  strokeWidth: 2,
                                  strokeColor: Colors.black,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              color: const Color(0xFF00E5C0).withOpacity(0.08),
                            ),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          handleBuiltInTouches: true,
                          touchTooltipData: LineTouchTooltipData(
                            tooltipRoundedRadius: 8.r,
                            tooltipPadding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 8.h),
                            getTooltipItems: (touchedSpots) {
                              return touchedSpots.map((spot) {
                                return LineTooltipItem(
                                  "Value: ${spot.y.toInt()}",
                                  GoogleFonts.orbitron(
                                    color: Colors.white,
                                    fontSize: 13.sp,
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
                ]

                // // Bottom Date
                // Padding(
                //   padding: EdgeInsets.only(top: 8.h, left: 4.w),
                //   child: Text(
                //     widget.date,
                //     style: GoogleFonts.orbitron(
                //       color: Colors.white60,
                //       fontSize: 12.sp,
                //     ),
                //   ),
                // ),
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
}
