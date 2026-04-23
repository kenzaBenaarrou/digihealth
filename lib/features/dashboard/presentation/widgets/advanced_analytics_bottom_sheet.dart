import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../../generated_assets/assets.gen.dart';
import 'border_painter.dart';

/// Advanced Analytics Bottom Sheet with two tabs:
/// 1. Indicateurs Clés (Key Indicators)
/// 2. Qualité des Données (Data Quality)
class AdvancedAnalyticsBottomSheet extends StatefulWidget {
  const AdvancedAnalyticsBottomSheet({super.key});

  @override
  State<AdvancedAnalyticsBottomSheet> createState() =>
      _AdvancedAnalyticsBottomSheetState();
}

class _AdvancedAnalyticsBottomSheetState
    extends State<AdvancedAnalyticsBottomSheet>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: const Color(0xFF051024), // Dark blue background
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          // Handle bar
          _buildHandleBar(),

          // Header with title and close button
          _buildHeader(context),

          SizedBox(height: 16.h),

          // Tab Bar
          _buildTabBar(),

          // Tab Bar View
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildIndicateursTab(),
                _buildQualiteTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Handle bar at the top
  Widget _buildHandleBar() {
    return Container(
      margin: EdgeInsets.only(top: 12.h),
      width: 40.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(2.r),
      ),
    );
  }

  /// Header with title and close button
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          Icon(
            Icons.bar_chart_sharp,
            color: Colors.cyanAccent,
            size: 24.sp,
          ),
          SizedBox(width: 12.w),
          // Title
          Text(
            'Analyses Avancées',
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          // Close button
        ],
      ),
    );
  }

  /// Tab Bar
  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1F38),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: Colors.cyanAccent.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: Colors.cyanAccent.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10.r),
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.cyanAccent,
        unselectedLabelColor: Colors.white.withOpacity(0.5),
        labelStyle: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.poppins(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        padding: EdgeInsets.all(4.w),
        tabs: [
          Tab(
            child: Text('Indicateurs Clés'),
          ),
          Tab(
            child: Text('Qualité Données'),
          ),
        ],
      ),
    );
  }

  /// Indicateurs Clés Tab
  Widget _buildIndicateursTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          20.verticalSpace,
          _buildIndicatorCard(
              context,
              'TAUX DE COUVERTURE DÉPISTAGE',
              '27.2%',
              'Femmes: 780K | Hommes: 522K',
              Icon(Icons.check_circle_outline_rounded,
                  color: Colors.cyanAccent, size: 22.sp),
              Colors.cyanAccent),
          20.verticalSpace,
          _buildIndicatorCard(
              context,
              "TAUX D'ÉVACUATION",
              '7.63',
              'Femmes: 780K | Hommes: 522K',
              Icon(Icons.electric_bolt, color: Colors.red, size: 22.sp),
              Colors.red),
          20.verticalSpace,
          _buildIndicatorCard(
              context,
              "TAUX D'UTILISATION",
              '27.2%',
              'Femmes: 780K | Hommes: 522K',
              Icon(Icons.laptop, color: Colors.cyanAccent, size: 22.sp),
              Colors.cyanAccent),
        ],
      ),
    );
  }

  /// Qualité des Données Tab
  Widget _buildQualiteTab() {
    return SingleChildScrollView(
        padding: EdgeInsets.all(20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Text(
                "QUALITÉ DES DONNÉES",
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
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
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.w,
                      vertical: 20.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.check_circle_outline_sharp,
                                  color: Colors.grey,
                                  size: 15.sp,
                                ),
                                5.horizontalSpace,
                                Text(
                                  'Complétude',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                                decoration: BoxDecoration(
                                  color: Colors.cyanAccent.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.w),
                                  border: Border.all(
                                    color: Colors.cyanAccent.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                padding: EdgeInsets.all(8.w),
                                child: Text("100.0%",
                                    style: TextStyle(
                                      color: Colors.cyanAccent,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    ))),
                          ],
                        ),
                        12.verticalSpace,
                        Text(
                          "Exactitude des Données Cliniques et Administratives",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        12.verticalSpace,
                        Divider(
                          color: Colors.grey.withOpacity(0.3),
                          height: 1,
                        ),
                        12.verticalSpace,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.grey,
                                  size: 15.sp,
                                ),
                                5.horizontalSpace,
                                Text(
                                  'Dernière Mise à Jour',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text("il y a 5 minutes",
                                    style: TextStyle(
                                      color: Colors.cyanAccent,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.bold,
                                    )),
                                5.verticalSpace,
                                Text(
                                  DateFormat.yMMMd()
                                      .add_jm()
                                      .format(DateTime.now()),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
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
        ));
  }

  Widget _buildIndicatorCard(BuildContext context, String title, String value,
      String subvalue, Widget icon, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Text(
            title,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
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
                padding: EdgeInsets.all(
                  20.w,
                ),
                child: Row(
                  children: [
                    Container(
                        padding: EdgeInsets.all(15.w),
                        decoration: BoxDecoration(
                          color: Colors.cyanAccent.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: icon),
                    12.horizontalSpace,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          value,
                          style: TextStyle(
                            color: color,
                            fontSize: 25.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        5.verticalSpace,
                        Text(
                          subvalue,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 10.sp,
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
}

/// Helper function to show the Advanced Analytics Bottom Sheet
void showAdvancedAnalyticsBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => const AdvancedAnalyticsBottomSheet(),
  );
}
