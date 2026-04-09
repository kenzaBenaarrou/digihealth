import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgramsScreen extends ConsumerWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF051024),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                children: [
                  20.verticalSpace,
                  _buildProgramCard(
                    title: 'PROGRAMME VACCINATION',
                    description: 'Campagne nationale de vaccination',
                    participants: '8,234',
                    progress: 0.75,
                    color: const Color(0xFF00FFDD),
                    icon: Icons.vaccines_outlined,
                  ),
                  16.verticalSpace,
                  _buildProgramCard(
                    title: 'DÉPISTAGE HTA',
                    description: 'Hypertension artérielle',
                    participants: '2,543',
                    progress: 0.45,
                    color: const Color(0xFFFF6B6B),
                    icon: Icons.favorite_border,
                  ),
                  16.verticalSpace,
                  _buildProgramCard(
                    title: 'DÉPISTAGE DIABÈTE',
                    description: 'Contrôle glycémie',
                    participants: '3,456',
                    progress: 0.60,
                    color: const Color(0xFF00D2FF),
                    icon: Icons.water_drop_outlined,
                  ),
                  16.verticalSpace,
                  _buildProgramCard(
                    title: 'CANCER DU SEIN',
                    description: 'Mammographie préventive',
                    participants: '1,234',
                    progress: 0.30,
                    color: const Color(0xFFFF9F43),
                    icon: Icons.health_and_safety_outlined,
                  ),
                  16.verticalSpace,
                  _buildProgramCard(
                    title: 'SANTÉ MATERNELLE',
                    description: 'Suivi grossesse',
                    participants: '4,567',
                    progress: 0.85,
                    color: const Color(0xFFB794F6),
                    icon: Icons.pregnant_woman,
                  ),
                  30.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PROGRAMMES',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              4.verticalSpace,
              Text(
                'Campagnes de santé actives',
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(8.sp),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.cyanAccent, width: 2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.add,
              color: Colors.cyanAccent,
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgramCard({
    required String title,
    required String description,
    required String participants,
    required double progress,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A2E),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.sp),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(icon, color: color, size: 28.sp),
              ),
              16.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    4.verticalSpace,
                    Text(
                      description,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          16.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'PARTICIPANTS',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 10.sp,
                      letterSpacing: 1,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    participants,
                    style: TextStyle(
                      color: color,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'PROGRESSION',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 10.sp,
                      letterSpacing: 1,
                    ),
                  ),
                  4.verticalSpace,
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          12.verticalSpace,
          ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8.h,
              backgroundColor: Colors.grey[800],
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}
