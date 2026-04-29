import 'package:digihealth/core/random/extention.dart';
import 'package:digihealth/features/dashboard/data/models/dashboard_response.dart';
import 'package:digihealth/features/dashboard/presentation/widgets/bar_chart.dart';
import 'package:digihealth/features/dashboard/presentation/widgets/patient_chart.dart';
import 'package:digihealth/features/dashboard/provider/dashboard_provider.dart';
import 'package:digihealth/features/programs/presentation/widgets/tele_start_widget.dart';
import 'package:digihealth/models/annulation_model.dart';
import 'package:digihealth/models/avgcall_model.dart';
import 'package:digihealth/models/date_model.dart';
import 'package:digihealth/models/evolution_model.dart';
import 'package:digihealth/models/speciality_model.dart';
import 'package:digihealth/models/teleexpertise_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/chart_export_menu.dart';
import '../../../../generated_assets/assets.gen.dart';
import '../../../dashboard/presentation/widgets/border_painter.dart';
import '../../../dashboard/presentation/widgets/custom_dropdown.dart';
import '../../../dashboard/provider/filter_provider.dart';
import '../widgets/start_card.dart';

class TeleexpertiseScreen extends ConsumerStatefulWidget {
  const TeleexpertiseScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TeleexpertiseScreenState();
}

class _TeleexpertiseScreenState extends ConsumerState<TeleexpertiseScreen>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey _specialityRepaintBoundaryKey = GlobalKey();
  final GlobalKey _rdvRepaintBoundaryKey = GlobalKey();
  final GlobalKey _regionRepaintBoundaryKey = GlobalKey();
  String _teleexpertiseType = "Somme";
  String? _selectedSpeciality;
  String? _selectedSpecialiste;

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);
    final filterState = ref.watch(filterProvider);

    super.build(context);

    return RefreshIndicator(
      onRefresh: () async {
        final selection = filterState.currentSelection;
        await ref.read(dashboardProvider.notifier).fetchDashboardData(
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
              isItenerance: selection.isItinerance,
            );
      },
      child: _buildContent(dashboardState),
    );
  }

  Widget _buildContent(DashboardState state) {
    if (state.status == DashboardStatus.loading) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.cyanAccent),
      );
    }

    if (state.status == DashboardStatus.error) {
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
      child: Padding(
        padding: EdgeInsets.all(10.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(data),
            if (data.specialities != null && data.specialities!.isNotEmpty) ...[
              16.verticalSpace,
              _buildSectionTitle("Répartition par spécialité"),
              _buildRepartitionPerSpeciality(
                  data.specialities ?? [], data.maxDate, data.minDate),
            ],
            if (data.consultationGenerale != null) ...[
              16.verticalSpace,
              _buildSectionTitle('Rendez-vous'),
              _buildRDV(
                  [
                    {
                      "COUNT": "${data.closed_rdv?.sum ?? 0}",
                      "color": "#00c4c4",
                      "name": "RDV clôturé",
                    },
                    {
                      "COUNT": "${data.reserved_rdv?.sum ?? 0}",
                      "color": "#3cb4c5",
                      "name": "Non disponibilité patient",
                    },
                    {
                      "COUNT": "${data.honored_rdv?.sum ?? 0}",
                      "color": "#ffd500",
                      "name": "Non disponibilité spécialiste",
                    },
                    {
                      "COUNT": "${data.cancelled_rdv?.sum ?? 0}",
                      "color": "#2e678b",
                      "name": "RDV annulé",
                    },
                  ],
                  data.maxDate,
                  data.minDate,
                  ((data.closed_rdv?.sum ?? 0) +
                          (data.reserved_rdv?.sum ?? 0) +
                          (data.honored_rdv?.sum ?? 0) +
                          (data.cancelled_rdv?.sum ?? 0))
                      .toDouble()),
            ],
            if (data.consultationGenerale != null) ...[
              16.verticalSpace,
              _buildSectionTitle('Statut des RDV'),
              _buildRDVStatut(data),
            ],
            if (data.teleexpertiseperregion != null &&
                data.teleexpertiseperregion!.isNotEmpty) ...[
              16.verticalSpace,
              _buildSectionTitle('Répartition par région'),
              _buildPieChartWidgetRegion(
                region: data.teleexpertiseperregion ?? [],
                repaintBoundaryKey: _regionRepaintBoundaryKey,
                chartTitle: 'Répartition par région',
                minDate: data.minDate,
                maxDate: data.maxDate,
              ),
            ],
            if (data.teleexpertiseperummc != null &&
                data.teleexpertiseperummc!.isNotEmpty) ...[
              16.verticalSpace,
              _buildSectionTitle('Répartition par Unité'),
              UmmcBarChart<TeleExpertisePerUmmc>(
                  data: data.teleexpertiseperummc ?? [],
                  getLabel: (item) => item.ummc,
                  getValue: (item) => double.parse(item.SUM))
            ],
            if (data.evolutionteleexpertise != null &&
                data.evolutionteleexpertise!.isNotEmpty) ...[
              16.verticalSpace,
              _buildEvolutionChart(data),
            ],
            if (data.annulationperummc != null &&
                data.annulationperummc!.isNotEmpty) ...[
              16.verticalSpace,
              _buildSectionTitle('Annulations par Unité'),
              UmmcBarChart<AnnulationPerUmmc>(
                  data: data.annulationperummc ?? [],
                  getLabel: (item) => item.ummc,
                  getValue: (item) => double.parse(item.cancelled))
            ],
            if (data.evolutionannulation != null &&
                data.evolutionannulation!.isNotEmpty) ...[
              16.verticalSpace,
              _buildSectionTitle('Évolution des Annulations'),
              PatientsTrendChart<EvolutionAnnulation>(
                  chartTitle: "Annulations",
                  data: data.evolutionannulation ?? [],
                  getLabel: (item) => item.date,
                  getValue: (item) => double.parse(item.cancelled))
            ],
            if (data.evolutionannulation != null &&
                data.evolutionannulation!.isNotEmpty) ...[
              16.verticalSpace,
              _buildSectionTitle('Évolution du Taux de Télé-expertise'),
              Text(
                "values are not available for this chart",
                style: TextStyle(color: Colors.grey, fontSize: 14.sp),
              ),
            ],
            if (data.evolutionbyspecialite != null &&
                data.evolutionbyspecialite!.isNotEmpty) ...[
              16.verticalSpace,
              _buildEvolutionPerSpecChart(data),
            ],
            if (data.evolutionbyspecialiste != null &&
                data.evolutionbyspecialiste!.isNotEmpty) ...[
              16.verticalSpace,
              _buildEvolutionPerSpecialisteChart(data),
            ],
            16.verticalSpace,
            Divider(color: Colors.cyanAccent, height: 2.h),
            16.verticalSpace,
            Text(
              "Durée des Télé-expertises",
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.cyanAccent,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0,
                  ),
            ),
            16.verticalSpace,
            StartCard(
              title: "Durée moyenne des appels",
              value: "values are not available",
              moyenne: "Durée moyenne par appel",
              icon: Assets.svg.consultationGenerale.svg(
                width: 30.w,
                height: 30.w,
              ),
              color: Colors.cyanAccent,
            ),
            if (data.avgcalldurationperummc != null &&
                data.avgcalldurationperummc!.isNotEmpty) ...[
              16.verticalSpace,
              _buildSectionTitle('Durée moyenne par Unité'),
              UmmcBarChart<AvgCallDurationPerUmmc>(
                  data: [...(data.avgcalldurationperummc ?? [])]..sort((a, b) =>
                      double.parse(b.avg_duration)
                          .compareTo(double.parse(a.avg_duration))),
                  getLabel: (item) => item.ummc,
                  getValue: (item) => double.parse(item.avg_duration))
            ],
            if (data.avgcalldurationperspecialite != null &&
                data.avgcalldurationperspecialite!.isNotEmpty) ...[
              16.verticalSpace,
              _buildSectionTitle('Durée moyenne par Spécialité'),
              UmmcBarChart<AvgCallDurationPerSpecialite>(
                  data: [...(data.avgcalldurationperspecialite ?? [])]..sort(
                      (a, b) => double.parse(b.avg_duration)
                          .compareTo(double.parse(a.avg_duration))),
                  getLabel: (item) => item.specialite,
                  getValue: (item) => double.parse(item.avg_duration))
            ],
            if (data.avgcalldurationperspecialite != null &&
                data.avgcalldurationperspecialite!.isNotEmpty) ...[
              16.verticalSpace,
              _buildSectionTitle('Durée moyenne par Spécialiste'),
              UmmcBarChart<AvgCallDurationPerSpecialiste>(
                  data: [...(data.avgcalldurationperspecialiste ?? [])]..sort(
                      (a, b) => double.parse(b.avg_duration)
                          .compareTo(double.parse(a.avg_duration))),
                  getLabel: (item) => item.specialiste,
                  getValue: (item) => double.parse(item.avg_duration))
            ],
            if (data.avgcalldurationperummc != null &&
                data.avgcalldurationperummc!.isNotEmpty) ...[
              16.verticalSpace,
              _buildSectionTitle('Evolution de la Durée moyenne'),
              PatientsTrendChart<EvolutionCallDuration>(
                  chartTitle: "Durée moyenne",
                  data: (data.evolutioncallduration ?? [])
                      .where((item) => double.parse(item.avg_duration) >= 0)
                      .toList(),
                  getLabel: (item) => item.date_activite,
                  getValue: (item) => double.parse(item.avg_duration))
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(DashboardResponse data) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: TeleStartWidget(
                  title: "Taux d'Utilisation",
                  value:
                      "${((data.teleexpertise?.sum ?? 0) / (data.consultationGenerale?.sum ?? 1) * 100).toStringAsFixed(1)} %",
                  icon: Icon(Icons.bar_chart_outlined,
                      color: Colors.cyanAccent, size: 20.w),
                  color: Colors.cyanAccent,
                  moyenne:
                      "${(data.teleexpertise?.sum ?? 0).toFormattedString()} / ${(data.consultationGenerale?.sum ?? 0).toFormattedString()}"),
            ),
            5.horizontalSpace,
            Expanded(
              child: TeleStartWidget(
                  title: "Taux d'Honneur",
                  value:
                      "${((data.closed_rdv?.sum ?? 0) / ((data.closed_rdv?.sum ?? 0) + (data.reserved_rdv?.sum ?? 0) + (data.honored_rdv?.sum ?? 0)) * 100).toStringAsFixed(1)} %",
                  icon: Icon(Icons.check_circle_outline_rounded,
                      color: Colors.green, size: 20.w),
                  color: Colors.green,
                  moyenne:
                      "${(data.closed_rdv?.sum ?? 0).toFormattedString()} / ${((data.closed_rdv?.sum ?? 0) + (data.reserved_rdv?.sum ?? 0) + (data.honored_rdv?.sum ?? 0)).toFormattedString()}"),
            ),
          ],
        ),
        16.verticalSpace,
        Row(
          children: [
            Expanded(
              child: TeleStartWidget(
                  title: "Taux d'Absence",
                  value:
                      "${(((data.honored_rdv?.sum ?? 0) + (data.reserved_rdv?.sum ?? 0)) / ((data.closed_rdv?.sum ?? 0) + (data.reserved_rdv?.sum ?? 0) + (data.honored_rdv?.sum ?? 0) + (data.cancelled_rdv?.sum ?? 0)) * 100).toStringAsFixed(1)} %",
                  icon: Icon(Icons.warning, color: Colors.yellow, size: 20.w),
                  color: Colors.yellow,
                  moyenne:
                      "${((data.honored_rdv?.sum ?? 0) + (data.reserved_rdv?.sum ?? 0)).toFormattedString()} / ${((data.closed_rdv?.sum ?? 0) + (data.reserved_rdv?.sum ?? 0) + (data.honored_rdv?.sum ?? 0) + (data.cancelled_rdv?.sum ?? 0)).toFormattedString()}"),
            ),
            5.horizontalSpace,
            Expanded(
              child: TeleStartWidget(
                  title: "Taux d'Annulation",
                  value:
                      "${((data.cancelled_rdv?.sum ?? 0) / ((data.closed_rdv?.sum ?? 0) + (data.reserved_rdv?.sum ?? 0) + (data.honored_rdv?.sum ?? 0) + (data.cancelled_rdv?.sum ?? 0)) * 100).toStringAsFixed(1)} %",
                  icon: Icon(Icons.close, color: Colors.red, size: 20.w),
                  color: Colors.red,
                  moyenne:
                      "${(data.cancelled_rdv?.sum ?? 0).toFormattedString()} / ${((data.closed_rdv?.sum ?? 0) + (data.reserved_rdv?.sum ?? 0) + (data.honored_rdv?.sum ?? 0) + (data.cancelled_rdv?.sum ?? 0)).toFormattedString()}"),
            ),
          ],
        ),
        StartCard(
          title: "Total des Télé-expertises",
          value: data.teleexpertise?.sum.toFormattedString() ?? "0",
          icon: Assets.svg.consultationGenerale.svg(
            width: 30.w,
            height: 30.w,
          ),
          color: Colors.cyanAccent,
        ),
      ],
    );
  }

  Widget _buildRepartitionPerSpeciality(
      List<Speciality> specialities, DateInfo? maxdate, DateInfo? mindate) {
    return _buildPieChartWidget(
      specialities: specialities,
      repaintBoundaryKey: _specialityRepaintBoundaryKey,
      chartTitle: 'Répartition par Spécialités',
      minDate: mindate,
      maxDate: maxdate,
    );
  }

  Widget _buildRDV(List<Map<String, String>> specialities, DateInfo? maxdate,
      DateInfo? mindate, double total) {
    return _buildPieChartWidgetRDV(
      rdv: specialities,
      total: total,
      repaintBoundaryKey: _rdvRepaintBoundaryKey,
      chartTitle: 'Rendez-vous',
      minDate: mindate,
      maxDate: maxdate,
    );
  }

  Widget _buildPieChartWidget({
    required List<Speciality> specialities,
    required GlobalKey repaintBoundaryKey,
    required String chartTitle,
    DateInfo? minDate,
    DateInfo? maxDate,
  }) {
    final total = specialities.fold(0, (sum, item) => sum + item.COUNT);

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
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Depuis le ${minDate != null ? DateFormat("yyyy-MM-dd").format(DateTime.parse(minDate.date_activite)) : 'N/A'} -- ${maxDate != null ? DateFormat("yyyy-MM-dd").format(DateTime.parse(maxDate.date_activite)) : 'N/A'}",
                          style: TextStyle(color: Colors.grey, fontSize: 8.sp),
                        ),
                      ),
                      10.verticalSpace,
                      // Pie Chart
                      SizedBox(
                        height: 250.h,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 50.r,
                            sections: specialities.map((speciality) {
                              final percentage = total > 0
                                  ? (speciality.COUNT / total) * 100
                                  : 0.0;
                              return PieChartSectionData(
                                color:
                                    _parseColor(speciality.color ?? '#00FFDD'),
                                value: speciality.COUNT.toDouble(),
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
                        children: specialities.map((speciality) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 5.w,
                                height: 5.h,
                                decoration: BoxDecoration(
                                  color: _parseColor(
                                      speciality.color ?? '#00FFDD'),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              6.horizontalSpace,
                              SvgPicture.asset(
                                "assets/svg/${speciality.specialite.toLowerCase()}.svg",
                                width: 14.w,
                                height: 14.h,
                              ),
                              6.horizontalSpace,
                              Text(
                                speciality.specialite.length > 30
                                    ? '${speciality.specialite.substring(0, 30)}...'
                                    : speciality.specialite,
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 10.sp,
                                ),
                              ),
                              4.horizontalSpace,
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
          child: ChartExportMenu<Speciality>(
            repaintBoundaryKey: repaintBoundaryKey,
            chartTitle: chartTitle,
            data: specialities,
            getLabel: (item) => item.specialite,
            getValue: (item) => double.parse(item.COUNT.toString()),
            valueColumnName: 'Sum',
          ),
        ),
      ],
    );
  }

  Widget _buildPieChartWidgetRDV({
    required List<Map<String, String>> rdv,
    required double total,
    required GlobalKey repaintBoundaryKey,
    required String chartTitle,
    DateInfo? minDate,
    DateInfo? maxDate,
  }) {
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
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Depuis le ${minDate != null ? DateFormat("yyyy-MM-dd").format(DateTime.parse(minDate.date_activite)) : 'N/A'} -- ${maxDate != null ? DateFormat("yyyy-MM-dd").format(DateTime.parse(maxDate.date_activite)) : 'N/A'}",
                          style: TextStyle(color: Colors.grey, fontSize: 8.sp),
                        ),
                      ),
                      10.verticalSpace,
                      // Pie Chart
                      SizedBox(
                        height: 250.h,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 50.r,
                            sections: rdv.map((rdv) {
                              final percentage = total > 0
                                  ? (rdv["COUNT"] != null
                                      ? (double.parse(rdv["COUNT"]!) / total) *
                                          100
                                      : 0.0)
                                  : 0.0;
                              return PieChartSectionData(
                                color: _parseColor(rdv["color"] ?? '#00FFDD'),
                                value: rdv["COUNT"] != null
                                    ? double.parse(rdv["COUNT"]!)
                                    : 0.0,
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
                        children: rdv.map((rdv) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7.w,
                                height: 7.h,
                                decoration: BoxDecoration(
                                  color: _parseColor(rdv["color"] ?? '#00FFDD'),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              6.horizontalSpace,
                              Text(
                                rdv["name"] != null && rdv["name"]!.length > 30
                                    ? '${rdv["name"]!.substring(0, 30)}...'
                                    : rdv["name"] ?? '',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 10.sp,
                                ),
                              ),
                              4.horizontalSpace,
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
          child: ChartExportMenu<Speciality>(
            repaintBoundaryKey: repaintBoundaryKey,
            chartTitle: chartTitle,
            data: rdv
                .map((item) => Speciality(
                      specialite: item["name"] ?? '',
                      COUNT: int.tryParse(item["COUNT"] ?? '0') ?? 0,
                      color: item["color"] ?? '#00FFDD',
                    ))
                .toList(),
            getLabel: (item) => item.specialite,
            getValue: (item) => double.parse(item.COUNT.toString()),
            valueColumnName: 'Sum',
          ),
        ),
      ],
    );
  }

  Widget _buildPieChartWidgetRegion({
    required List<TeleExpertisePerRegion> region,
    required GlobalKey repaintBoundaryKey,
    required String chartTitle,
    DateInfo? minDate,
    DateInfo? maxDate,
  }) {
    final total =
        region.fold(0, (sum, item) => sum + (int.tryParse(item.SUM) ?? 0));
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
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "Depuis le ${minDate != null ? DateFormat("yyyy-MM-dd").format(DateTime.parse(minDate.date_activite)) : 'N/A'} -- ${maxDate != null ? DateFormat("yyyy-MM-dd").format(DateTime.parse(maxDate.date_activite)) : 'N/A'}",
                          style: TextStyle(color: Colors.grey, fontSize: 8.sp),
                        ),
                      ),
                      10.verticalSpace,
                      // Pie Chart
                      SizedBox(
                        height: 250.h,
                        child: PieChart(
                          PieChartData(
                            sectionsSpace: 2,
                            centerSpaceRadius: 50.r,
                            sections: region.map((region) {
                              final percentage = total > 0
                                  ? (region.SUM != null
                                      ? (int.tryParse(region.SUM) ?? 0) /
                                          total *
                                          100
                                      : 0.0)
                                  : 0.0;
                              return PieChartSectionData(
                                color: _parseColor(region.color ?? '#00FFDD'),
                                value: region.SUM != null
                                    ? double.parse(region.SUM)
                                    : 0.0,
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
                        children: region.map((region) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 7.w,
                                height: 7.h,
                                decoration: BoxDecoration(
                                  color: _parseColor(region.color ?? '#00FFDD'),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              6.horizontalSpace,
                              Text(
                                region.region != null &&
                                        region.region!.length > 30
                                    ? '${region.region!.substring(0, 30)}...'
                                    : region.region ?? '',
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 10.sp,
                                ),
                              ),
                              4.horizontalSpace,
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
          child: ChartExportMenu<TeleExpertisePerRegion>(
            repaintBoundaryKey: repaintBoundaryKey,
            chartTitle: chartTitle,
            data: region.toList(),
            getLabel: (item) => item.region,
            getValue: (item) => double.parse(item.SUM),
            valueColumnName: 'Sum',
          ),
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
                fontSize: 16.sp,
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

  Widget _buildRDVStatut(DashboardResponse data) {
    return Container(
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
                _buildStatusIndicator('Honorés', _parseColor("#00c4c4"),
                    data.closed_rdv?.sum.toFormattedString() ?? "0"),
                _buildStatusIndicator(
                    'Non-Honorés',
                    _parseColor("#ffd500"),
                    ((data.honored_rdv?.sum ?? 0) +
                            (data.reserved_rdv?.sum ?? 0))
                        .toFormattedString()),
                _buildStatusIndicator('Annulés', _parseColor("#2e678b"),
                    data.cancelled_rdv?.sum.toFormattedString() ?? "0"),
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
    );
  }

  Widget _buildStatusIndicator(String label, Color color, String sum) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: const Color(0xFF0A1F38),
        borderRadius: BorderRadius.circular(5.r),
        boxShadow: [
          BoxShadow(
            color: Colors.cyanAccent.withOpacity(0.3),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 7.w,
            height: 30.h,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(5.r),
            ),
          ),
          6.horizontalSpace,
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(color: Colors.grey[400], fontSize: 7.sp),
              ),
              5.verticalSpace,
              Text(
                sum,
                style: TextStyle(color: Colors.cyanAccent, fontSize: 10.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEvolutionChart(DashboardResponse data) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Évolution de la Télé-expertise',
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
            if (_teleexpertiseType == "Somme" &&
                data.evolutionteleexpertise != null)
              PatientsTrendChart<EvolutionTeleExpertise>(
                  chartTitle: "Télé-expertises",
                  data: data.evolutionteleexpertise!,
                  getLabel: (e) => e.date_activite,
                  getValue: (e) => double.tryParse(e.SUM) ?? 0)
            else if (_teleexpertiseType == "Moyenne" &&
                data.evolutionteleexpertiseavg != null)
              PatientsTrendChart<EvolutionTeleExpertiseAvg>(
                  chartTitle: "Moy",
                  data: data.evolutionteleexpertiseavg!,
                  getLabel: (e) => e.date_activite,
                  getValue: (e) => double.tryParse(e.AVG) ?? 0)
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
              selectedValue: _teleexpertiseType,
              width: 80.w,
              onChanged: (value) {
                setState(() {
                  _teleexpertiseType = value;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEvolutionPerSpecChart(DashboardResponse data) {
    // Initialize selected specialty if not set
    if (_selectedSpeciality == null &&
        data.specialities != null &&
        data.specialities!.isNotEmpty) {
      _selectedSpeciality = data.specialities!.first.specialite;
    }

    // Filter evolution data by selected specialty
    final filteredData = data.evolutionbyspecialite
            ?.where((item) => item.specialite == _selectedSpeciality)
            .toList() ??
        [];

    // Get the color for the selected specialty
    final selectedSpecialtyObj = data.specialities?.firstWhere(
      (spec) => spec.specialite == _selectedSpeciality,
      orElse: () => data.specialities!.first,
    );
    final specialtyColor = selectedSpecialtyObj?.color != null
        ? _parseColor(selectedSpecialtyObj!.color!)
        : Colors.cyanAccent;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Évolution par Spécialité',
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
            if (filteredData.isNotEmpty)
              PatientsTrendChart<EvolutionBySpecialite>(
                  chartTitle: _selectedSpeciality ?? "Spécialité",
                  data: filteredData,
                  getLabel: (e) => e.date_activite,
                  getValue: (e) => e.count.toDouble(),
                  lineColor: specialtyColor,
                  accentColor: specialtyColor)
            else
              Center(
                child: Text(
                  'Aucune donnée disponible pour cette spécialité',
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/svg/${_selectedSpeciality?.toLowerCase() ?? 'cardiologist'}.svg",
                  width: 16.w,
                  height: 16.h,
                ),
                4.horizontalSpace,
                Container(
                  constraints: BoxConstraints(maxWidth: 110.w),
                  child: CustomDropdown(
                    selectedValue: _selectedSpeciality ?? '',
                    width: 110.w,
                    options: data.specialities
                            ?.map((spec) => spec.specialite)
                            .toList() ??
                        [],
                    onChanged: (value) {
                      setState(() {
                        _selectedSpeciality = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEvolutionPerSpecialisteChart(DashboardResponse data) {
    // Initialize selected specialty if not set
    if (_selectedSpecialiste == null &&
        data.specialities != null &&
        data.specialities!.isNotEmpty) {
      _selectedSpecialiste =
          "${data.evolutionbyspecialiste!.first.specialisteN}[${data.evolutionbyspecialiste!.first.specialite}]";
    }

    // Filter evolution data by selected specialty
    final filteredData = data.evolutionbyspecialiste
            ?.where((item) =>
                "${item.specialisteN}[${item.specialite}]" ==
                _selectedSpecialiste)
            .toList() ??
        [];

    // Extract specialty name from selected string (between brackets)
    String? specialtyName;
    if (_selectedSpecialiste != null &&
        _selectedSpecialiste!.contains('[') &&
        _selectedSpecialiste!.contains(']')) {
      final startIndex = _selectedSpecialiste!.indexOf('[');
      final endIndex = _selectedSpecialiste!.indexOf(']');
      specialtyName = _selectedSpecialiste!.substring(startIndex + 1, endIndex);
    }

    // Get the color for the selected specialty
    final selectedSpecialtyObj = data.specialities?.firstWhere(
      (spec) => spec.specialite == specialtyName,
      orElse: () => data.specialities!.first,
    );
    final specialtyColor = selectedSpecialtyObj?.color != null
        ? _parseColor(selectedSpecialtyObj!.color!)
        : Colors.cyanAccent;

    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Évolution\npar Spécialiste',
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
            if (filteredData.isNotEmpty)
              PatientsTrendChart<EvolutionBySpecialiste>(
                  chartTitle: _selectedSpecialiste ?? "Spécialiste",
                  data: filteredData,
                  getLabel: (e) => e.date_activite,
                  getValue: (e) => e.count.toDouble(),
                  lineColor: specialtyColor,
                  accentColor: specialtyColor)
            else
              Center(
                child: Text(
                  'Aucune donnée disponible pour ce spécialiste',
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  "assets/svg/${specialtyName?.toLowerCase() ?? 'cardiologist'}.svg",
                  width: 16.w,
                  height: 16.h,
                ),
                4.horizontalSpace,
                Container(
                  constraints: BoxConstraints(maxWidth: 200.w),
                  child: CustomDropdown(
                    selectedValue: _selectedSpecialiste ?? '',
                    width: 200.w,
                    options: data.evolutionbyspecialiste
                            ?.map((spec) =>
                                "${spec.specialisteN}[${spec.specialite}]")
                            .toSet()
                            .toList() ??
                        [],
                    onChanged: (value) {
                      setState(() {
                        _selectedSpecialiste = value;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
