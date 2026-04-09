import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: const Color(0xFF051024),
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Stack(
                children: [
                  // Map placeholder
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF051024),
                          const Color(0xFF0A1A2E).withOpacity(0.5),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map_outlined,
                            size: 100.sp,
                            color: Colors.cyanAccent.withOpacity(0.3),
                          ),
                          20.verticalSpace,
                          Text(
                            'CARTE INTERACTIVE',
                            style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          10.verticalSpace,
                          Text(
                            'Visualisation géographique des données',
                            style: TextStyle(
                              color: Colors.grey[400],
                              fontSize: 14.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Floating location markers
                  Positioned(
                    top: 100.h,
                    right: 40.w,
                    child: _buildLocationMarker('Zone A', '234 patients'),
                  ),
                  Positioned(
                    top: 200.h,
                    left: 60.w,
                    child: _buildLocationMarker('Zone B', '156 patients'),
                  ),
                  Positioned(
                    bottom: 150.h,
                    right: 80.w,
                    child: _buildLocationMarker('Zone C', '89 patients'),
                  ),
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
          Text(
            'CARTE',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.cyanAccent, width: 2),
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.filter_list,
                  color: Colors.cyanAccent,
                  size: 20.sp,
                ),
                8.horizontalSpace,
                Text(
                  'FILTRES',
                  style: TextStyle(
                    color: Colors.cyanAccent,
                    fontSize: 12.sp,
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

  Widget _buildLocationMarker(String zone, String patients) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A2E),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: Colors.cyanAccent, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            zone,
            style: TextStyle(
              color: Colors.cyanAccent,
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          4.verticalSpace,
          Text(
            patients,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
