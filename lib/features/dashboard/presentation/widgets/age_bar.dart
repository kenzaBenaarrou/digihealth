import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import 'border_painter.dart';

class AgeDistributionBarChart extends StatelessWidget {
  const AgeDistributionBarChart({super.key});

  final List<AgeBarData> data = const [
    AgeBarData(ageGroup: "0 à 6 ans", percent: 11, color: Colors.cyanAccent),
    AgeBarData(ageGroup: "7 à 14 ans", percent: 11, color: Colors.cyanAccent),
    AgeBarData(ageGroup: "15 à 24 ans", percent: 9, color: Colors.cyanAccent),
    AgeBarData(ageGroup: "25 à 64 ans", percent: 52, color: Colors.cyanAccent),
    AgeBarData(ageGroup: "+65 ans", percent: 18, color: Colors.cyanAccent),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0A1F38),
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Column(
              children:
                  data.map((item) => _buildBarRow(item, context)).toList(),
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

  Widget _buildBarRow(AgeBarData item, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          // Age Group Label
          SizedBox(
            width: 110.w,
            child: Text(
              item.ageGroup,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
              ),
            ),
          ),

          // Progress Bar
          Expanded(
            child: Stack(
              children: [
                // Background bar
                Container(
                  height: 8.h,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                // Colored progress bar
                FractionallySizedBox(
                  widthFactor: item.percent / 100,
                  child: Container(
                    height: 8.h,
                    decoration: BoxDecoration(
                      color: item.color,
                      borderRadius: BorderRadius.circular(20.r),
                      boxShadow: [
                        BoxShadow(
                          color: item.color.withOpacity(0.6),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Percentage
          SizedBox(
            width: 45.w,
            child: Text(
              "${item.percent}%",
              textAlign: TextAlign.end,
              style: GoogleFonts.orbitron(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Data Model
class AgeBarData {
  final String ageGroup;
  final int percent;
  final Color color;

  const AgeBarData({
    required this.ageGroup,
    required this.percent,
    required this.color,
  });
}
