import 'package:digihealth/core/random/extention.dart';
import 'package:digihealth/features/dashboard/presentation/widgets/patient_chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/chart_export_menu.dart';
import '../../../../generated_assets/assets.gen.dart';
import '../../../dashboard/presentation/widgets/bar_chart.dart';
import '../../../dashboard/presentation/widgets/border_painter.dart';
import '../../../dashboard/presentation/widgets/custom_dropdown.dart';
import '../../../dashboard/provider/filter_provider.dart';
import '../../data/models/consultation_response.dart';
import '../../provider/consultation_provider.dart';
import '../widgets/start_card.dart';

class ConsultationScreen extends ConsumerStatefulWidget {
  const ConsultationScreen({super.key});

  @override
  ConsumerState<ConsultationScreen> createState() => _ConsultationScreenState();
}

class _ConsultationScreenState extends ConsumerState<ConsultationScreen>
    with AutomaticKeepAliveClientMixin {
  // === Global Keys for Chart Export ===
  final GlobalKey _consultationRepaintBoundaryKey = GlobalKey();
  final GlobalKey _evacuationRepaintBoundaryKey = GlobalKey();

  // === Dropdown State ===
  String _evacuationEvolutionType = 'Somme';
  String _epathologieType = 'TOP 20';
  String _consultationType = 'Somme';

  // === Keep Alive ===
  @override
  bool get wantKeepAlive => true;

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
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final consultationState = ref.watch(consultationProvider);
    final filterState = ref.watch(filterProvider);

    return RefreshIndicator(
      onRefresh: () async {
        // Apply current filters when refreshing
        final selection = filterState.currentSelection;
        await ref.read(consultationProvider.notifier).fetchConsultationData(
              region: selection.region,
              province: selection.province,
              ummc: selection.ummc,
              from: selection.fromDate != null
                  ? DateFormat('yyyy-MM-dd').format(selection.fromDate!)
                  : null,
              to: selection.toDate != null
                  ? DateFormat('yyyy-MM-dd').format(selection.toDate!)
                  : null,
              tranche: selection.tranche,
              isItinerance: selection.isItinerance,
            );
      },
      color: Colors.cyanAccent,
      backgroundColor: const Color(0xFF0A1A2E),
      child: SingleChildScrollView(
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
      return ErrorWidget(state.errorMessage!);
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
      padding: EdgeInsets.all(10.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          _buildSummaryCards(data),
          24.verticalSpace,

          // Consultation per Region Chart
          if (data.consultationPerRegion != null &&
              data.consultationPerRegion!.isNotEmpty) ...[
            _buildSectionTitle('Consultations par Régions'),
            _buildRegionChart(
                data.consultationPerRegion!, data.maxDate, data.minDate),
            24.verticalSpace,
          ],
          // Consultation per Unity
          if (data.consultationPerUmmc != null &&
              data.consultationPerUmmc!.isNotEmpty) ...[
            _buildSectionTitle('Consultation par Unité'),
            _buildConsPerUni(data.consultationPerUmmc!),
            24.verticalSpace,
          ],
          // Evolution Chart
          if (data.evolutionConsultations != null &&
              data.evolutionConsultations!.isNotEmpty) ...[
            _buildEvolutionChart(data),
            24.verticalSpace,
          ],
          // Pathologies
          if (data.pathologies != null && data.pathologies!.isNotEmpty) ...[
            _buildPathologiesList(data),
            24.verticalSpace,
          ],

          // === Evacuation Charts ===
          // Evacuation per region
          if (data.evacuationPerRegion != null &&
              data.evacuationPerRegion!.isNotEmpty) ...[
            _buildSectionTitle('Évacuation par régions'),
            _buildEvacuationPerRegion(
                data.evacuationPerRegion!, data.maxDate, data.minDate),
            24.verticalSpace,
          ],
          // Evacuation per unity
          if (data.evacuationPerUmmc != null &&
              data.evacuationPerUmmc!.isNotEmpty) ...[
            _buildSectionTitle('Évacuation par régions'),
            _buildEvacuationPerUmmc(data.evacuationPerUmmc!),
            24.verticalSpace,
          ],
          // Evolution evacuation
          if ((data.evolutionEvacuations != null &&
                  data.evolutionEvacuations!.isNotEmpty) ||
              (data.evolutionEvacuationsAvg != null &&
                  data.evolutionEvacuationsAvg!.isNotEmpty)) ...[
            _buildEvolutionEvacuationTitleWithDropdown(data),
            24.verticalSpace,
          ],
        ],
      ),
    );
  }

  // === Summary Cards Section ===

  Widget _buildSummaryCards(ConsultationResponse data) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: StartCard(
                  title: 'PRISE EN CHARGE',
                  value:
                      data.totalPriseEnCharge?.value.toFormattedString() ?? '0',
                  icon: Assets.svg.priseEncharge.svg(
                    width: 30.w,
                    height: 30.h,
                  ),
                  color: Colors.cyanAccent,
                  moyenne:
                      "Moy ${data.totalPriseEnChargeAvg != null ? data.totalPriseEnChargeAvg!.value.toStringAsFixed(3) : '0'} /u/j"),
            ),
            5.horizontalSpace,
            Expanded(
              child: StartCard(
                  title: 'ÉVACUATIONS',
                  value: data.evacuation?.value.toFormattedString() ?? '0',
                  icon: Assets.svg.priseEncharge.svg(
                    width: 30.w,
                    height: 30.h,
                  ),
                  color: Colors.redAccent,
                  moyenne:
                      "Moy ${data.evacuationAvg != null ? data.evacuationAvg!.value.toStringAsFixed(3) : '0'} /u/j"),
            ),
          ],
        ),
        16.verticalSpace,
        Row(
          children: [
            Expanded(
              child: StartCard(
                  title: 'CONSULTATIONS',
                  value: data.consultationGenerale?.value.toFormattedString() ??
                      '0',
                  icon: Assets.svg.priseEncharge.svg(
                    width: 30.w,
                    height: 30.h,
                  ),
                  color: Colors.cyanAccent,
                  moyenne:
                      "Moy ${data.consultationGeneraleAvg != null ? data.consultationGeneraleAvg!.value.toStringAsFixed(3) : '0'} /u/j"),
            ),
            5.horizontalSpace,
            Expanded(
              child: StartCard(
                  title: 'RÉFÉRENCES',
                  value: data.referencement?.value.toFormattedString() ?? '0',
                  icon: Assets.svg.priseEncharge.svg(
                    width: 30.w,
                    height: 30.h,
                  ),
                  color: Colors.cyanAccent,
                  moyenne:
                      "Moy ${data.referencementAvg != null ? data.referencementAvg!.value.toStringAsFixed(3) : '0'} /u/j"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: Colors.white,
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                letterSpacing: 0,
              ),
        ),
        Assets.images.lifeSignal.image(
          width: double.infinity,
          // height: 150.h,
          fit: BoxFit.cover,
        ),
      ],
    );
  }

  Widget _buildRegionChart(
      List<RegionData> regions, DateModel? maxdate, DateModel? mindate) {
    return _buildPieChartWidget(
      regions: regions,
      repaintBoundaryKey: _consultationRepaintBoundaryKey,
      chartTitle: 'Consultation par régions',
      minDate: mindate,
      maxDate: maxdate,
    );
  }

  Widget _buildConsPerUni(List<UmmcData> data) {
    return UmmcBarChart<UmmcData>(
      data: data,
      getLabel: (item) => item.ummc,
      getValue: (item) => double.tryParse(item.sum) ?? 0,
    );
  }

  Widget _buildEvolutionChart(ConsultationResponse data) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Évolution des Consultations',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
            ),
            Assets.images.lifeSignal.image(
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            if (_consultationType == "Somme" &&
                data.evolutionEvacuations != null)
              PatientsTrendChart<EvolutionData>(
                  chartTitle: "Consultations",
                  data: data.evolutionConsultations!,
                  getLabel: (e) => e.dateActivite,
                  getValue: (e) => double.tryParse(e.sum) ?? 0)
            else if (_consultationType == "Moyenne" &&
                data.evolutionEvacuationsAvg != null)
              PatientsTrendChart<EvolutionAvgData>(
                  chartTitle: "Consultations",
                  data: data.evolutionConsultationsAvg!,
                  getLabel: (e) => e.dateActivite,
                  getValue: (e) => double.tryParse(e.avg) ?? 0)
            else
              Center(
                child: Text(
                  'Aucune donnée disponible',
                  style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                ),
              ),
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            elevation: 8,
            child: CustomDropdown(
              selectedValue: _consultationType,
              width: 80.w,
              onChanged: (value) {
                setState(() {
                  _consultationType = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPathologiesList(ConsultationResponse data) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pathologies',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
            ),
            Assets.images.lifeSignal.image(
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            // Conditional rendering based on dropdown selection
            if (_epathologieType == "TOP 20" &&
                data.evolutionEvacuations != null)
              UmmcBarChart<PathologyData>(
                data: data.pathologies!,
                getLabel: (item) => item.pathology,
                getValue: (item) => item.count.toDouble(),
              )
            else if (_epathologieType == "PARETO 20/80" &&
                data.evolutionEvacuationsAvg != null)
              UmmcBarChart<PathologyData>(
                data: data.pathologiesPareto!,
                getLabel: (item) => item.pathology,
                getValue: (item) => item.count.toDouble(),
              )
            else
              Center(
                child: Text(
                  'Aucune donnée disponible',
                  style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                ),
              ),
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            elevation: 8,
            child: CustomDropdown(
              selectedValue: _epathologieType,
              options: const ['TOP 20', 'PARETO 20/80'],
              width: 110.w,
              onChanged: (value) {
                setState(() {
                  _epathologieType = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEvacuationPerRegion(
      List<RegionData> regions, DateModel? maxdate, DateModel? mindate) {
    return _buildPieChartWidget(
      regions: regions,
      repaintBoundaryKey: _evacuationRepaintBoundaryKey,
      chartTitle: 'Évacuation par régions',
      minDate: mindate,
      maxDate: maxdate,
    );
  }

  Widget _buildEvacuationPerUmmc(List<UmmcData> ummcs) {
    return UmmcBarChart<UmmcData>(
      data: ummcs,
      getLabel: (item) => item.ummc,
      getValue: (item) => double.parse(item.sum),
    );
  }

  Widget _buildEvolutionEvacuationTitleWithDropdown(ConsultationResponse data) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Évolution des évacuations',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
            ),
            Assets.images.lifeSignal.image(
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            // Conditional rendering based on dropdown selection
            if (_evacuationEvolutionType == "Somme" &&
                data.evolutionEvacuations != null)
              PatientsTrendChart<EvolutionData>(
                  chartTitle: "Évacuations",
                  accentColor: Color(0xFF194260),
                  data: data.evolutionEvacuations!,
                  getLabel: (e) => e.dateActivite,
                  getValue: (e) => double.tryParse(e.sum) ?? 0)
            else if (_evacuationEvolutionType == "Moyenne" &&
                data.evolutionEvacuationsAvg != null)
              PatientsTrendChart<EvolutionAvgData>(
                  accentColor: Color(0xFF194260),
                  chartTitle: "Évacuations",
                  data: data.evolutionEvacuationsAvg!,
                  getLabel: (e) => e.dateActivite,
                  getValue: (e) => double.tryParse(e.avg) ?? 0)
            else
              Center(
                child: Text(
                  'Aucune donnée disponible',
                  style: TextStyle(color: Colors.grey, fontSize: 14.sp),
                ),
              ),
          ],
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Material(
            color: Colors.transparent,
            elevation: 8,
            child: CustomDropdown(
              selectedValue: _evacuationEvolutionType,
              onChanged: (value) {
                setState(() {
                  _evacuationEvolutionType = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  // === Reusable Components ===

  /// Builds a reusable pie chart with legend and export menu
  Widget _buildPieChartWidget({
    required List<RegionData> regions,
    required GlobalKey repaintBoundaryKey,
    required String chartTitle,
    DateModel? minDate,
    DateModel? maxDate,
  }) {
    final total = regions.fold(0, (sum, item) => sum + item.value);

    return Stack(
      children: [
        RepaintBoundary(
          key: repaintBoundaryKey,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0A1F38),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.w),
                  child: Column(
                    children: [
                      // Date Range and Total Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Depuis le ${minDate != null ? DateFormat("yyyy-MM-dd").format(DateTime.parse(minDate.dateActivite)) : 'N/A'} -- ${maxDate != null ? DateFormat("yyyy-MM-dd").format(DateTime.parse(maxDate.dateActivite)) : 'N/A'}",
                            style:
                                TextStyle(color: Colors.grey, fontSize: 8.sp),
                          ),
                          Text.rich(
                            TextSpan(
                              text: "Total: ",
                              children: [
                                TextSpan(
                                  text: "$total",
                                  style: TextStyle(
                                    color: Colors.cyanAccent,
                                    fontSize: 8.sp,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 8.sp),
                            ),
                          ),
                        ],
                      ),
                      10.verticalSpace,
                      // Pie Chart
                      SizedBox(
                        height: 250.h,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 50.r,
                            sections: regions.map((region) {
                              final percentage = total > 0
                                  ? (region.value / total) * 100
                                  : 0.0;
                              return PieChartSectionData(
                                color: _parseColor(region.color ?? '#00FFDD'),
                                value: region.value.toDouble(),
                                title: '${percentage.toStringAsFixed(1)}%',
                                titleStyle: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                radius: 80.r,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      16.verticalSpace,
                      // Legend
                      Wrap(
                        spacing: 12.w,
                        runSpacing: 8.h,
                        alignment: WrapAlignment.center,
                        children: regions.map((region) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 12.w,
                                height: 12.h,
                                decoration: BoxDecoration(
                                  color: _parseColor(region.color ?? '#00FFDD'),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              6.horizontalSpace,
                              Text(
                                region.region.length > 30
                                    ? '${region.region.substring(0, 30)}...'
                                    : region.region,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 10.sp,
                                ),
                              ),
                              4.horizontalSpace,
                              Text(
                                '(${region.value})',
                                style: TextStyle(
                                  color: _parseColor(region.color ?? '#00FFDD'),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                Positioned.fill(
                  child: CustomPaint(
                    painter: CornerBorderPainter(
                      color: Colors.cyanAccent,
                      strokeWidth: 1,
                      cornerLength: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 30.h,
          right: 5.w,
          child: ChartExportMenu<RegionData>(
            repaintBoundaryKey: repaintBoundaryKey,
            chartTitle: chartTitle,
            data: regions,
            getLabel: (item) => item.region,
            getValue: (item) => double.parse(item.sum),
            valueColumnName: 'Sum',
          ),
        ),
      ],
    );
  }

  // === Utility Methods ===

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return const Color(0xFF00FFDD);
    }
  }

}
