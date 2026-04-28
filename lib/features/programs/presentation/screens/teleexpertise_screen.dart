import 'package:digihealth/core/random/extention.dart';
import 'package:digihealth/features/dashboard/data/models/dashboard_response.dart';
import 'package:digihealth/features/dashboard/provider/dashboard_provider.dart';
import 'package:digihealth/features/programs/presentation/widgets/tele_start_widget.dart';
import 'package:digihealth/models/date_model.dart';
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

  @override
  initState() {
    super.initState();
  }

  @override
  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    final dashboardState = ref.watch(dashboardProvider);
    super.build(context);

    return RefreshIndicator(
      onRefresh: () async {
        // Add your refresh logic here
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

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return const Color(0xFF00FFDD);
    }
  }
}
