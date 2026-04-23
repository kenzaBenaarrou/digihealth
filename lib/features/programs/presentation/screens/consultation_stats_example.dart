import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:digihealth/features/programs/provider/consultation_provider.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../data/models/consultation_response.dart';

/// Example: Consultation Screen showing statistics and charts
class ConsultationStatsScreen extends ConsumerStatefulWidget {
  const ConsultationStatsScreen({super.key});

  @override
  ConsumerState<ConsultationStatsScreen> createState() =>
      _ConsultationStatsScreenState();
}

class _ConsultationStatsScreenState
    extends ConsumerState<ConsultationStatsScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch consultation data when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(consultationProvider.notifier).fetchConsultationData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final consultationState = ref.watch(consultationProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF051024),
      appBar: AppBar(
        backgroundColor: const Color(0xFF051024),
        title: const Text('CONSULTATIONS'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.cyanAccent),
            onPressed: _showFilters,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(consultationProvider.notifier).refresh();
        },
        color: Colors.cyanAccent,
        backgroundColor: const Color(0xFF0A1A2E),
        child: _buildContent(consultationState),
      ),
    );
  }

  Widget _buildContent(ConsultationState state) {
    if (state.status == ConsultationStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.cyanAccent),
      );
    }

    if (state.status == ConsultationStatus.error) {
      return _buildErrorWidget(state.errorMessage);
    }

    if (state.data == null) {
      return const Center(
        child: Text(
          'Aucune donnée disponible',
          style: TextStyle(color: Colors.white),
        ),
      );
    }

    final data = state.data!;

    return SingleChildScrollView(
      padding: EdgeInsets.all(20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          _buildSummaryCards(data),
          24.verticalSpace,

          // Consultation per Region Chart
          if (data.consultationPerRegion != null &&
              data.consultationPerRegion!.isNotEmpty) ...[
            _buildSectionTitle('Consultations par Région'),
            16.verticalSpace,
            _buildRegionChart(data.consultationPerRegion!),
            24.verticalSpace,
          ],

          // Evolution Chart
          if (data.evolutionConsultations != null &&
              data.evolutionConsultations!.isNotEmpty) ...[
            _buildSectionTitle('Évolution des Consultations'),
            16.verticalSpace,
            _buildEvolutionChart(data.evolutionConsultations!),
            24.verticalSpace,
          ],

          // Pathologies
          if (data.pathologies != null && data.pathologies!.isNotEmpty) ...[
            _buildSectionTitle('Principales Pathologies'),
            16.verticalSpace,
            _buildPathologiesList(data.pathologies!),
            24.verticalSpace,
          ],

          // Specialities
          if (data.specialities != null && data.specialities!.isNotEmpty) ...[
            _buildSectionTitle('Spécialités'),
            16.verticalSpace,
            _buildSpecialitiesList(data.specialities!),
            24.verticalSpace,
          ],

          // UMMC Stats
          if (data.consultationPerUmmc != null &&
              data.consultationPerUmmc!.isNotEmpty) ...[
            _buildSectionTitle('Top 10 UMMC'),
            16.verticalSpace,
            _buildUmmcList(data.consultationPerUmmc!.take(10).toList()),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCards(data) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Total Consultations',
                data.consultationGenerale?.value.toString() ?? '0',
                Icons.medical_services,
                Colors.cyanAccent,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: _buildStatCard(
                'Évacuations',
                data.evacuation?.value.toString() ?? '0',
                Icons.local_hospital,
                Colors.redAccent,
              ),
            ),
          ],
        ),
        16.verticalSpace,
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Télé-expertise',
                data.teleexpertise?.value.toString() ?? '0',
                Icons.video_call,
                Colors.purpleAccent,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: _buildStatCard(
                'Vaccinations',
                data.vaccination?.value.toString() ?? '0',
                Icons.vaccines,
                Colors.greenAccent,
              ),
            ),
          ],
        ),
        16.verticalSpace,
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Dépistage HTA',
                data.depistageHta?.value.toString() ?? '0',
                Icons.favorite,
                Colors.orangeAccent,
              ),
            ),
            16.horizontalSpace,
            Expanded(
              child: _buildStatCard(
                'Dépistage Diabète',
                data.depistageDiabete?.value.toString() ?? '0',
                Icons.water_drop,
                Colors.blueAccent,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A2E),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24.sp),
          12.verticalSpace,
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 11.sp,
            ),
          ),
          4.verticalSpace,
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        color: Colors.white,
        fontSize: 18.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildRegionChart(List<RegionData> regions) {
    return Container(
      height: 300.h,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A2E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: BarChart(
        BarChartData(
          barGroups: regions.asMap().entries.map((entry) {
            return BarChartGroupData(
              x: entry.key,
              barRods: [
                BarChartRodData(
                  toY: entry.value.value.toDouble(),
                  color: _parseColor(entry.value.color ?? '#00FFDD'),
                  width: 16.w,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: TextStyle(color: Colors.grey[400], fontSize: 10.sp),
                ),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= regions.length) return const SizedBox();
                  return Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: Text(
                      regions[value.toInt()].region.substring(0, 3),
                      style:
                          TextStyle(color: Colors.grey[400], fontSize: 10.sp),
                    ),
                  );
                },
              ),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey[800]!,
              strokeWidth: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEvolutionChart(List<EvolutionData> evolution) {
    final dataPoints = evolution.map((e) => e.value.toDouble()).toList();

    return Container(
      height: 200.h,
      padding: EdgeInsets.all(16.sp),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1A2E),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: dataPoints
                  .asMap()
                  .entries
                  .map((e) => FlSpot(e.key.toDouble(), e.value))
                  .toList(),
              color: Colors.cyanAccent,
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                color: Colors.cyanAccent.withOpacity(0.1),
              ),
            ),
          ],
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: TextStyle(color: Colors.grey[400], fontSize: 10.sp),
                ),
              ),
            ),
            bottomTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => FlLine(
              color: Colors.grey[800]!,
              strokeWidth: 1,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPathologiesList(List<PathologyData> pathologies) {
    return Column(
      children: pathologies.take(10).map((pathology) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.sp),
          decoration: BoxDecoration(
            color: const Color(0xFF0A1A2E),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: Colors.cyanAccent.withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  pathology.pathology,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                  ),
                ),
              ),
              Text(
                pathology.count.toString(),
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSpecialitiesList(List<SpecialityData> specialities) {
    return Column(
      children: specialities.map((speciality) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.sp),
          decoration: BoxDecoration(
            color: const Color(0xFF0A1A2E),
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color:
                  _parseColor(speciality.color ?? '#00FFDD').withOpacity(0.3),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  speciality.specialite.toUpperCase(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Text(
                speciality.count.toString(),
                style: TextStyle(
                  color: _parseColor(speciality.color ?? '#00FFDD'),
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildUmmcList(List<UmmcData> ummcs) {
    return Column(
      children: ummcs.map((ummc) {
        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.sp),
          decoration: BoxDecoration(
            color: const Color(0xFF0A1A2E),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  ummc.ummc,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13.sp,
                  ),
                ),
              ),
              Text(
                ummc.value.toString(),
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildErrorWidget(String? errorMessage) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.redAccent, size: 64.sp),
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
              style: TextStyle(color: Colors.grey[400], fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            ElevatedButton(
              onPressed: () {
                ref.read(consultationProvider.notifier).fetchConsultationData();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: const Color(0xFF051024),
              ),
              child: const Text('Réessayer'),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilters() {
    // Show filter bottom sheet (reuse FilterBottomSheet from dashboard)
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF051024),
      builder: (context) => Container(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filtres',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Add filter UI here or reuse from dashboard feature
          ],
        ),
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
}
