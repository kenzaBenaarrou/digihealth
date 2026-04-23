import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer/shimmer.dart';
import 'package:digihealth/features/programs/provider/program_provider.dart';

/// Example widget showing how to use the program provider with pagination and shimmer loading
class ProgramsListWidget extends ConsumerStatefulWidget {
  final String? category;
  final String? status;

  const ProgramsListWidget({
    super.key,
    this.category,
    this.status,
  });

  @override
  ConsumerState<ProgramsListWidget> createState() => _ProgramsListWidgetState();
}

class _ProgramsListWidgetState extends ConsumerState<ProgramsListWidget> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    // Fetch initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(programsProvider(
            category: widget.category,
            status: widget.status,
          ).notifier)
          .fetchPrograms();
    });

    // Setup infinite scroll listener
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      // Load more when user is 200px from bottom
      ref
          .read(programsProvider(
            category: widget.category,
            status: widget.status,
          ).notifier)
          .loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final programsState = ref.watch(programsProvider(
      category: widget.category,
      status: widget.status,
    ));

    return RefreshIndicator(
      onRefresh: () async {
        await ref
            .read(programsProvider(
              category: widget.category,
              status: widget.status,
            ).notifier)
            .refresh();
      },
      color: Colors.cyanAccent,
      backgroundColor: const Color(0xFF0A1A2E),
      child: _buildContent(programsState),
    );
  }

  Widget _buildContent(ProgramsState state) {
    // Show shimmer on initial load
    if (state.status == ProgramsStatus.loading) {
      return _buildShimmerList();
    }

    // Show error state
    if (state.status == ProgramsStatus.error && state.programs.isEmpty) {
      return _buildErrorWidget(state.errorMessage);
    }

    // Show empty state
    if (state.programs.isEmpty) {
      return _buildEmptyWidget();
    }

    // Show programs list
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      itemCount: state.programs.length + (state.hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        // Show loading indicator at the bottom when loading more
        if (index == state.programs.length) {
          return _buildLoadingMoreIndicator();
        }

        final program = state.programs[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 16.h),
          child: _buildProgramCard(
            title: program.title,
            description: program.description,
            participants: program.participants.toString(),
            progress: program.progress,
            color: _parseColor(program.color ?? '#00FFDD'),
            icon: _parseIcon(program.icon ?? 'health_and_safety'),
          ),
        );
      },
    );
  }

  Widget _buildShimmerList() {
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: const Color(0xFF0A1A2E),
          highlightColor: Colors.grey[800]!,
          child: Container(
            margin: EdgeInsets.only(bottom: 16.h),
            height: 180.h,
            decoration: BoxDecoration(
              color: const Color(0xFF0A1A2E),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: Colors.grey[800]!,
                width: 1.5,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      alignment: Alignment.center,
      child: SizedBox(
        width: 24.sp,
        height: 24.sp,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent),
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String? errorMessage) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.redAccent,
              size: 64.sp,
            ),
            16.verticalSpace,
            Text(
              'Erreur',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            8.verticalSpace,
            Text(
              errorMessage ?? 'Une erreur est survenue',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14.sp,
              ),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            ElevatedButton(
              onPressed: () {
                ref
                    .read(programsProvider(
                      category: widget.category,
                      status: widget.status,
                    ).notifier)
                    .fetchPrograms();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: const Color(0xFF051024),
                padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              ),
              child: Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            color: Colors.grey[600],
            size: 64.sp,
          ),
          16.verticalSpace,
          Text(
            'Aucun programme',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16.sp,
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

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return const Color(0xFF00FFDD);
    }
  }

  IconData _parseIcon(String iconString) {
    final iconMap = {
      'vaccines': Icons.vaccines_outlined,
      'favorite': Icons.favorite_border,
      'water_drop': Icons.water_drop_outlined,
      'health_and_safety': Icons.health_and_safety_outlined,
      'pregnant_woman': Icons.pregnant_woman,
      'child_care': Icons.child_care,
      'medical_services': Icons.medical_services_outlined,
    };
    return iconMap[iconString] ?? Icons.health_and_safety_outlined;
  }
}
