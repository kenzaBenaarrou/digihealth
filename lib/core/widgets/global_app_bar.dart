import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../features/dashboard/presentation/widgets/advanced_analytics_bottom_sheet.dart';
import '../../features/dashboard/presentation/widgets/filter_bottom_sheet.dart';
import '../../features/dashboard/provider/dashboard_provider.dart';
import '../../features/dashboard/provider/filter_provider.dart';
import '../../features/programs/provider/consultation_provider.dart';
import '../../generated_assets/assets.gen.dart';

/// Global app bar widget that can be used across the entire app
/// Maintains filter state globally and applies filters to all screens
class GlobalAppBar extends ConsumerWidget {
  /// Optional callback when filters are applied
  /// If not provided, will automatically refresh dashboard and consultation data
  final Function(
      String? region,
      String? province,
      String? ummc,
      String? fromDate,
      String? toDate,
      int? tranche,
      bool isItinerance)? onFilterApplied;

  /// Whether to show the analytics button (default: true)
  final bool showAnalytics;

  /// Whether to show the logo (default: true)
  final bool showLogo;

  const GlobalAppBar({
    super.key,
    this.onFilterApplied,
    this.showAnalytics = true,
    this.showLogo = true,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(filterProvider);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 16.h),
      child: Column(
        children: [
          if (showLogo)
            Assets.images.digihealthLogo.image(
              height: 25.h,
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Filter button with active indicator
              Stack(
                children: [
                  Container(
                    padding: EdgeInsets.all(5.sp),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyanAccent, width: 2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: InkWell(
                      onTap: () {
                        showFilterBottomSheet(
                          context,
                          onFilterApplied: (region, province, ummc, fromDate,
                              toDate, tranche, isItinerance) {
                            // Apply custom callback if provided
                            if (onFilterApplied != null) {
                              onFilterApplied!(region, province, ummc, fromDate,
                                  toDate, tranche, isItinerance);
                            } else {
                              // Default behavior: refresh all data with filters
                              _applyGlobalFilters(
                                ref,
                                region: region,
                                province: province,
                                ummc: ummc,
                                fromDate: fromDate,
                                toDate: toDate,
                                tranche: tranche,
                                isItinerance: isItinerance,
                              );
                            }
                          },
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.filter_list,
                            color: Colors.cyanAccent,
                            size: 20.sp,
                          ),
                          3.horizontalSpace,
                          Text(
                            'Filtres',
                            style: TextStyle(
                              color: Colors.cyanAccent,
                              fontSize: 12.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Active filter indicator
                  if (filterState.currentSelection.hasSelection)
                    Positioned(
                      right: 2,
                      top: 2,
                      child: Container(
                        width: 8.w,
                        height: 8.h,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: const Color(0xFF051024),
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              8.horizontalSpace,
              // Analytics button
              if (showAnalytics)
                InkWell(
                  onTap: () {
                    showAdvancedAnalyticsBottomSheet(context);
                  },
                  child: Container(
                    padding: EdgeInsets.all(5.sp),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.cyanAccent, width: 2),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.bar_chart_sharp,
                          color: Colors.cyanAccent,
                          size: 20.sp,
                        ),
                        3.horizontalSpace,
                        Text(
                          'Analyses',
                          style: TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  /// Apply filters globally to all data providers
  void _applyGlobalFilters(
    WidgetRef ref, {
    String? region,
    String? province,
    String? ummc,
    String? fromDate,
    String? toDate,
    int? tranche,
    bool? isItinerance,
  }) {
    // Refresh dashboard data with filters
    ref.read(dashboardProvider.notifier).fetchDashboardData(
          region: region,
          province: province,
          ummc: ummc,
          from: fromDate,
          to: toDate,
          tranche: tranche,
          isItenerance: isItinerance,
        );

    // Refresh consultation data with filters (if consultation provider is available)
    try {
      ref.read(consultationProvider.notifier).fetchConsultationData(
            region: region,
            province: province,
            ummc: ummc,
            from: fromDate,
            to: toDate,
            tranche: tranche,
            isItinerance: isItinerance,
          );
    } catch (e) {
      // Consultation provider might not be available in all contexts
      debugPrint('Consultation provider not available: $e');
    }

    // Add more provider refreshes here as needed
    // e.g., ref.read(otherProvider.notifier).fetchWithFilters(...)
  }
}

/// Helper function to show the filter bottom sheet
void showFilterBottomSheet(
  BuildContext context, {
  Function(String? region, String? province, String? ummc, String? fromDate,
          String? toDate, int? tranche, bool isItinerance)?
      onFilterApplied,
}) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => FilterBottomSheet(onFilterApplied: onFilterApplied),
  );
}
