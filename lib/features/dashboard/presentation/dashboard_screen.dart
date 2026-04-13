import 'package:digihealth/features/authentication/provider/auth_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated_assets/assets.gen.dart';
import '../provider/dashboard_provider.dart';
import 'widgets/age_bar.dart';
import 'widgets/border_painter.dart';
import 'widgets/patient_chart.dart';
import 'widgets/line_chart.dart';

// Provider for the filter dropdown
final selectedFilterProvider = StateProvider<String>((ref) => "Somme");

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch dashboard data when widget initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(dashboardProvider.notifier).fetchDashboardData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);
    final authState = ref.watch(authNotifierProvider);
    final user = authState.user;
    final selectedFilter = ref.watch(selectedFilterProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF051024),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              // _buildHeadTitle(context, 'A- PRISES EN CHARGE : 1,302,567'),
              // 13.verticalSpace,
              // _buildMainStatCards(),

              24.verticalSpace,
              _buildSingleValue(
                ref,
                context,
                "TOTAL PRISES EN CHARGE",
                "${dashboardState.data?.total_prise_en_charge?.sum ?? 'N/A'}",
                "2023-11-01 - 2024-10-31",
                Assets.images.consultationLogo.image(
                  width: 50.w,
                  height: 50.h,
                ),
              ),
              24.verticalSpace,
              _buildConsultations(
                ref,
                context,
                "CONSULTATIONS",
                "${dashboardState.data?.consultationGenerale?.sum ?? 'N/A'}",
                36,
                64,
                Assets.images.consultationLogo.image(
                  width: 50.w,
                  height: 50.h,
                ),
              ),
              24.verticalSpace,
              _buildTrancheAge(ref, context),
              24.verticalSpace,
              _buildSingleValue(
                ref,
                context,
                "PATIENTS UNIQUES",
                "702 567",
                "2023-11-01 - 2024-10-31",
                Assets.images.consultationLogo.image(
                  width: 50.w,
                  height: 50.h,
                ),
              ),
              24.verticalSpace,

              _buildCriticalDiagnostics(ref, selectedFilter, context),
              24.verticalSpace,
              // _buildTeleexpertise(ref, selectedFilter, context),
              // 24.verticalSpace,

              // // _buildHeadTitle(context, 'B- PROGRAMMES DE SANTÉ PUBLIQUE'),
              // // 24.verticalSpace,
              // _buildSanteScolaire(context),
              // 24.verticalSpace,
              // _buildPNI(context),
              // 24.verticalSpace,
              // _buildDepistage(context),
              // 30.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Assets.images.digihealthLogo.image(
            height: 25.h,
          ),
          Container(
            padding: EdgeInsets.all(5.sp),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.cyanAccent, width: 2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: Colors.cyanAccent,
              size: 20.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeadTitle(BuildContext context, String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      child: Text(
        title,
        style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontSize: 15.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Gradient gradient,
  }) {
    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(16.sp),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: Colors.white, size: 32.sp),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 1,
                  ),
                ),
                8.verticalSpace,
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriticalDiagnostics(
      WidgetRef ref, String selectedFilter, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h),
                child: Text(
                  'TOTAL PRISES EN CHARGES',
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: Colors.white,
                        fontSize: 11.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                ),
              ),
              // CustomDropdown(
              //   selectedValue: selectedFilter,
              //   onChanged: (value) {
              //     ref.read(selectedFilterProvider.notifier).state = value;
              //     // You can call any function here (filter data, etc.)
              //   },
              // )
            ],
          ),
        ),
        // 16.verticalSpace,
        Assets.images.lifeSignal.image(
          width: double.infinity,
          // height: 150.h,
          fit: BoxFit.cover,
        ),
        PatientsTrendChart(),
        // DigiHealthLineChart(
        //   totalValue: 95636,
        //   spots: const [
        //     FlSpot(0, 120),
        //     FlSpot(0.8, 80),
        //     FlSpot(1.5, 300),
        //     FlSpot(2.2, 250),
        //     FlSpot(3, 450),
        //     FlSpot(3.8, 380),
        //     FlSpot(4.5, 620),
        //     FlSpot(5.2, 580),
        //     FlSpot(6, 850),
        //     FlSpot(6.8, 720),
        //     FlSpot(7.5, 503),
        //   ],
        // ),
        // 16.verticalSpace,
        // // Padding(
        // //   padding: EdgeInsets.symmetric(horizontal: 20.w),
        // //   child: Column(
        // //     children: [
        // //       _buildSmallStatCard(
        // //         title: 'HTA',
        // //         value: '2,543',
        // //         color: const Color(0xFFFF6B6B),
        // //       ),
        // //       12.verticalSpace,
        // //       _buildSmallStatCard(
        // //         title: 'CANCER DU SEIN',
        // //         value: '1,234',
        // //         color: const Color(0xFFFF9F43),
        // //       ),
        // //       12.verticalSpace,
        // //       _buildSmallStatCard(
        // //         title: 'DIABÈTE',
        // //         value: '3,456',
        // //         color: const Color(0xFF00D2FF),
        // //       ),
        // //     ],
        // //   ),
        // // ),
      ],
    );
  }

  Widget _buildTeleexpertise(
      WidgetRef ref, String selectedFilter, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'A-2 TÉLÉEXPERTISES',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
          ),
        ),
        // 16.verticalSpace,
        Assets.images.lifeSignal.image(
          width: double.infinity,
          // height: 150.h,
          fit: BoxFit.cover,
        ),
        DigiHealthLineChart(
          totalValue: 25963,
          totalPercentageChange: 23.5, // Example percentage change

          spots: const [
            FlSpot(0, 120),
            FlSpot(0.8, 80),
            FlSpot(1.5, 300),
            FlSpot(2.2, 250),
            FlSpot(3, 450),
            FlSpot(3.8, 380),
            FlSpot(4.5, 620),
            FlSpot(5.2, 580),
            FlSpot(6, 850),
            FlSpot(6.8, 720),
            FlSpot(7.5, 503),
          ],
        ),
      ],
    );
  }

  Widget _buildSingleValue(WidgetRef ref, BuildContext context, String title,
      String value, String soustext, Widget icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
          ),
        ),
        // 16.verticalSpace,
        Assets.images.lifeSignal.image(
          width: double.infinity,
          // height: 150.h,
          fit: BoxFit.cover,
        ),
        Container(
          color: const Color(0xFF0A1F38),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Row(
                  children: [
                    icon,
                    12.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          soustext,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 7.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
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

        // DigiHealthLineChart(
        //   totalValue: 258147,
        //   isChart: false,
        //   spots: const [],
        // ),
      ],
    );
  }

  Widget _buildConsultations(WidgetRef ref, BuildContext context, String title,
      String value, int female, int male, Widget icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
          ),
        ),
        // 16.verticalSpace,
        Assets.images.lifeSignal.image(
          width: double.infinity,
          // height: 150.h,
          fit: BoxFit.cover,
        ),
        Container(
          color: const Color(0xFF0A1F38),
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Row(
                  children: [
                    icon,
                    12.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.female,
                                  color: Colors.cyanAccent,
                                  size: 15.sp,
                                ),
                                Text(
                                  "$female%",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 7.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                            8.horizontalSpace,
                            Row(
                              children: [
                                Icon(
                                  Icons.male,
                                  color: Colors.cyanAccent,
                                  size: 15.sp,
                                ),
                                Text(
                                  "$male%",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 7.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
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

        // DigiHealthLineChart(
        //   totalValue: 258147,
        //   isChart: false,
        //   spots: const [],
        // ),
      ],
    );
  }

  Widget _buildTrancheAge(WidgetRef ref, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'RÉPARTITION PAR ÂGE',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
          ),
        ),
        // 16.verticalSpace,
        Assets.images.lifeSignal.image(
          width: double.infinity,
          // height: 150.h,
          fit: BoxFit.cover,
        ),
        AgeDistributionBarChart()
      ],
    );
  }

  Widget _buildSmallStatCard({
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A2E),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.5), width: 1.5),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 40.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          16.horizontalSpace,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12.sp,
                    letterSpacing: 1,
                  ),
                ),
                4.verticalSpace,
                Text(
                  value,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios, color: color, size: 16.sp),
        ],
      ),
    );
  }

  Widget _buildRealTimeDataFlux() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Text(
            'FLUX DE DONNÉES TEMPS RÉEL',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
        ),
        16.verticalSpace,
        Container(
          margin: EdgeInsets.symmetric(horizontal: 20.w),
          padding: EdgeInsets.all(16.sp),
          height: 200.h,
          decoration: BoxDecoration(
            color: const Color(0xFF0A1A2E),
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
          ),
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: 100,
              barTouchData: BarTouchData(enabled: true),
              titlesData: FlTitlesData(
                show: true,
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const titles = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
                      if (value.toInt() >= 0 && value.toInt() < titles.length) {
                        return Text(
                          titles[value.toInt()],
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12.sp,
                          ),
                        );
                      }
                      return const Text('');
                    },
                  ),
                ),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: 25,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Colors.cyanAccent.withOpacity(0.1),
                    strokeWidth: 1,
                  );
                },
              ),
              borderData: FlBorderData(show: false),
              barGroups: [
                _buildBarGroup(0, 65),
                _buildBarGroup(1, 80),
                _buildBarGroup(2, 45),
                _buildBarGroup(3, 90),
                _buildBarGroup(4, 70),
                _buildBarGroup(5, 55),
                _buildBarGroup(6, 75),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMainStatCards() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: _buildStatCard(
        title: 'PRISES EN CHARGE',
        value: '12,543',
        icon: Icons.people_outline,
        gradient: const LinearGradient(
          colors: [Color(0xFF00FFDD), Color(0xFF00C4B4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }

  Widget _buildSanteScolaire(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'B-1 SANTÉ SCOLAIRE',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
          ),
        ),
        // 16.verticalSpace,
        Assets.images.lifeSignal.image(
          width: double.infinity,
          // height: 150.h,
          fit: BoxFit.cover,
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Assets.images.circles.image(width: 120.w),
                        Assets.images.kids.image(width: 40.w),
                      ],
                    ),
                    16.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '34 567 ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        10.verticalSpace,
                        Text(
                          'Consultations',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
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
        16.verticalSpace,
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 20.w),
        //   child: Column(
        //     children: [
        //       _buildSmallStatCard(
        //         title: 'HTA',
        //         value: '2,543',
        //         color: const Color(0xFFFF6B6B),
        //       ),
        //       12.verticalSpace,
        //       _buildSmallStatCard(
        //         title: 'CANCER DU SEIN',
        //         value: '1,234',
        //         color: const Color(0xFFFF9F43),
        //       ),
        //       12.verticalSpace,
        //       _buildSmallStatCard(
        //         title: 'DIABÈTE',
        //         value: '3,456',
        //         color: const Color(0xFF00D2FF),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget _buildPNI(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'B-2 PNI',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
          ),
        ),
        // 16.verticalSpace,
        Assets.images.lifeSignal.image(
          width: double.infinity,
          // height: 150.h,
          fit: BoxFit.cover,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Assets.images.pni.image(width: 80.w),
                    16.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '567 ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        10.verticalSpace,
                        Text(
                          'Vaccinations',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
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
        16.verticalSpace,
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 20.w),
        //   child: Column(
        //     children: [
        //       _buildSmallStatCard(
        //         title: 'HTA',
        //         value: '2,543',
        //         color: const Color(0xFFFF6B6B),
        //       ),
        //       12.verticalSpace,
        //       _buildSmallStatCard(
        //         title: 'CANCER DU SEIN',
        //         value: '1,234',
        //         color: const Color(0xFFFF9F43),
        //       ),
        //       12.verticalSpace,
        //       _buildSmallStatCard(
        //         title: 'DIABÈTE',
        //         value: '3,456',
        //         color: const Color(0xFF00D2FF),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  Widget _buildDepistage(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Text(
            'B-3 DÉPISTAGES',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 11.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
          ),
        ),
        // 16.verticalSpace,
        Assets.images.lifeSignal.image(
          width: double.infinity,
          // height: 150.h,
          fit: BoxFit.cover,
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Assets.images.hta.image(width: 50.w),
                            16.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '567 710',
                                  style: TextStyle(
                                    color: Colors.cyanAccent,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                5.verticalSpace,
                                Text(
                                  'HTA',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        20.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Assets.images.diabete.image(width: 50.w),
                            16.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '123 456',
                                  style: TextStyle(
                                    color: Colors.cyanAccent,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                5.verticalSpace,
                                Text(
                                  'DIABÈTE',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Assets.images.cs.image(width: 50.w),
                            16.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '35 122',
                                  style: TextStyle(
                                    color: Colors.cyanAccent,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                5.verticalSpace,
                                Text(
                                  'CANCER DU SEIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        20.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Assets.images.cu.image(width: 50.w),
                            16.horizontalSpace,
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '5456',
                                  style: TextStyle(
                                    color: Colors.cyanAccent,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                5.verticalSpace,
                                Text(
                                  'CANCER DU COL \n DE L\'UTÉRUS',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
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
        16.verticalSpace,
        // Padding(
        //   padding: EdgeInsets.symmetric(horizontal: 20.w),
        //   child: Column(
        //     children: [
        //       _buildSmallStatCard(
        //         title: 'HTA',
        //         value: '2,543',
        //         color: const Color(0xFFFF6B6B),
        //       ),
        //       12.verticalSpace,
        //       _buildSmallStatCard(
        //         title: 'CANCER DU SEIN',
        //         value: '1,234',
        //         color: const Color(0xFFFF9F43),
        //       ),
        //       12.verticalSpace,
        //       _buildSmallStatCard(
        //         title: 'DIABÈTE',
        //         value: '3,456',
        //         color: const Color(0xFF00D2FF),
        //       ),
        //     ],
        //   ),
        // ),
      ],
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          gradient: const LinearGradient(
            colors: [Color(0xFF00FFDD), Color(0xFF00C4B4)],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: 16.w,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.r),
            topRight: Radius.circular(4.r),
          ),
        ),
      ],
    );
  }
}
