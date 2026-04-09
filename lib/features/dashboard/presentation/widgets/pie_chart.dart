import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'border_painter.dart';

class AgeDistributionChart extends StatelessWidget {
  const AgeDistributionChart({super.key});

  final List<AgeGroup> ageGroups = const [
    AgeGroup(name: "0 à 6 ans", percent: 17.9, color: Color(0xFF00E5C0)),
    AgeGroup(name: "7 à 14 ans", percent: 10.9, color: Color(0xFF7CFF9B)),
    AgeGroup(name: "15 à 24 ans", percent: 8.49, color: Color(0xFFFFC107)),
    AgeGroup(name: "25 à 64 ans", percent: 52.0, color: Color(0xFFFF6B00)),
    AgeGroup(name: "65 ans et plus", percent: 10.8, color: Color(0xFF2196F3)),
  ];

  final List<SexeGroup> sexeGroups = const [
    SexeGroup(
        name: "Femmes",
        percent: 52.0,
        color: Color.fromARGB(230, 212, 37, 192)),
    SexeGroup(
        name: "Hommes",
        percent: 48.0,
        color: Color.fromARGB(230, 26, 126, 207)),
  ];
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            // color: const Color(0xFF0A1F38),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Row(
                  children: [
                    // Donut Chart
                    SizedBox(
                      width: 180.w,
                      height: 190.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 3,
                              centerSpaceRadius: 60.r,
                              startDegreeOffset: -90,
                              sections: ageGroups.map((group) {
                                return PieChartSectionData(
                                  color: group.color,
                                  value: group.percent,
                                  title: '',
                                  radius: 20.r,
                                  badgeWidget: null,
                                );
                              }).toList(),
                            ),
                          ),
                          // Center Text
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "100%",
                                style: GoogleFonts.orbitron(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "DISTRIBUTION",
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  color: Colors.white60,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    24.horizontalSpace,

                    // Legend
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: ageGroups.map((group) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Row(
                              children: [
                                Container(
                                  width: 14.w,
                                  height: 14.w,
                                  decoration: BoxDecoration(
                                    color: group.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                12.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    group.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.sp,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${group.percent}%",
                                  style: TextStyle(
                                    color: group.color,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
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
        ),
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            // color: const Color(0xFF0A1F38),
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Row(
                  children: [
                    // Donut Chart
                    SizedBox(
                      width: 180.w,
                      height: 100.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          PieChart(
                            PieChartData(
                              sectionsSpace: 2,
                              centerSpaceRadius: 40.r,
                              startDegreeOffset: -90,
                              sections: sexeGroups.map((group) {
                                return PieChartSectionData(
                                  color: group.color,
                                  value: group.percent,
                                  title: '',
                                  radius: 10.r,
                                  badgeWidget: null,
                                );
                              }).toList(),
                            ),
                          ),
                          // Center Text
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "100%",
                                style: GoogleFonts.orbitron(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "DISTRIBUTION",
                                style: TextStyle(
                                  fontSize: 7.5.sp,
                                  color: Colors.white60,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    24.horizontalSpace,

                    // Legend
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: sexeGroups.map((group) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: Row(
                              children: [
                                Container(
                                  width: 14.w,
                                  height: 14.w,
                                  decoration: BoxDecoration(
                                    color: group.color,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                12.horizontalSpace,
                                Expanded(
                                  child: Text(
                                    group.name,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 8.sp,
                                    ),
                                  ),
                                ),
                                Text(
                                  "${group.percent}%",
                                  style: TextStyle(
                                    color: group.color,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
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
        ),
      ],
    );
  }
}

// Model
class AgeGroup {
  final String name;
  final double percent;
  final Color color;

  const AgeGroup({
    required this.name,
    required this.percent,
    required this.color,
  });
}

// Model
class SexeGroup {
  final String name;
  final double percent;
  final Color color;

  const SexeGroup({
    required this.name,
    required this.percent,
    required this.color,
  });
}
