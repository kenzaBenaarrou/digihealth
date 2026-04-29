import 'package:digihealth/core/widgets/global_app_bar.dart';
import 'package:digihealth/features/programs/presentation/screens/consultation_screen.dart';
import 'package:digihealth/features/programs/presentation/screens/depistage_screen.dart';
import 'package:digihealth/features/programs/presentation/screens/teleexpertise_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProgramsScreen extends ConsumerWidget {
  const ProgramsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF051024),
        body: SafeArea(
          child: Column(
            children: [
              const GlobalAppBar(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  children: [
                    ConsultationScreen(),
                    TeleexpertiseScreen(),
                    DepistageScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric( vertical: 12.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A2E),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.2), width: 1),
      ),
      child: TabBar(
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BoxDecoration(
          color: Colors.cyanAccent.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12.r),
        ),
        labelColor: Colors.cyanAccent,
        unselectedLabelColor: Colors.grey[500],
        labelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 13.sp,
          fontWeight: FontWeight.normal,
        ),
        tabs: const [
          Tab(text: 'CONSULTATIONS'),
          Tab(text: 'TÉLÉ-EXPERTISE'),
          Tab(text: 'DÉPISTAGE'),
        ],
      ),
    );
  }

  Widget _buildUpcomingTab() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      children: [
        20.verticalSpace,
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
          title: 'SANTÉ DENTAIRE',
          description: 'Contrôle bucco-dentaire',
          participants: '890',
          progress: 0.15,
          color: const Color(0xFF4ECDC4),
          icon: Icons.medical_services_outlined,
        ),
        30.verticalSpace,
      ],
    );
  }

  Widget _buildCompletedTab() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      children: [
        20.verticalSpace,
        _buildProgramCard(
          title: 'SANTÉ MATERNELLE',
          description: 'Suivi grossesse',
          participants: '4,567',
          progress: 1.0,
          color: const Color(0xFFB794F6),
          icon: Icons.pregnant_woman,
        ),
        16.verticalSpace,
        _buildProgramCard(
          title: 'NUTRITION INFANTILE',
          description: 'Programme alimentaire enfants',
          participants: '3,210',
          progress: 1.0,
          color: const Color(0xFF95E1D3),
          icon: Icons.child_care,
        ),
        30.verticalSpace,
      ],
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
