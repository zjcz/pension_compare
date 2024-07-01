import 'package:flutter/material.dart';
import 'package:pension_compare/app/home/controllers/pension_with_latest_statement_controller.dart';
import 'package:pension_compare/app/home/controllers/yearly_pension_statement_controller.dart';
import 'package:pension_compare/app/home/models/pension_with_statement_model.dart';
import 'package:pension_compare/app/pension/views/widgets/target_vs_actual_chart.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/service_locator.dart';
import 'package:pension_compare/widgets/dashboard/dashboard_tile.dart';

class PensionReportScreen extends ConsumerStatefulWidget {
  const PensionReportScreen({super.key});

  @override
  ConsumerState<PensionReportScreen> createState() =>
      _PensionReportScreenState();
}

class _PensionReportScreenState extends ConsumerState<PensionReportScreen> {
  Future<Settings>? settings;
  bool showTargetLine = false;
  bool showRetirementDate = false;

  @override
  void initState() {
    super.initState();
    settings = _loadSettings();
  }

  Future<Settings> _loadSettings() async {
    return await getIt<SettingsService>().getAllSettings();
  }

  @override
  Widget build(BuildContext context) {
    // TO DO - do we need this?
    final pensionsSummaryData =
        ref.watch(pensionWithLatestStatementControllerProvider);
    final yearlyPensionSummaryData =
        ref.watch(yearlyPensionStatementControllerProvider);

    return Scaffold(
        appBar: AppBar(title: const Text('Pension Performance')),
        body: SafeArea(
            minimum: const EdgeInsets.all(10.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: yearlyPensionSummaryData.when(
                  data: (yearlySummary) => pensionsSummaryData.when(
                    data: (List<PensionWithStatementModel> pensions) {
                      if (pensions.isEmpty && yearlySummary.isEmpty) {
                        return const Center(child: Text('No pensions found'));
                      } else {
                        return SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DashboardTile(
                                    title: 'Projected Monthly Income',
                                    child: FutureBuilder<Settings>(
                                        future: settings,
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator());
                                          } else if (snapshot.hasError) {
                                            return Center(
                                                child: Text(
                                                    'Error loading data: ${snapshot.error}'));
                                          } else if (!snapshot.hasData ||
                                              snapshot.data == null) {
                                            return const Center(
                                                child: Text('Not found'));
                                          } else {
                                            Settings settings = snapshot.data!;
                                            return TargetVsActualChart(
                                                pensionData: yearlySummary,
                                                retirementDate:
                                                    showRetirementDate
                                                        ? settings
                                                            .retirementDate
                                                        : null,
                                                targetValue: showTargetLine
                                                    ? settings.targetIncome
                                                    : null,
                                                hideTitle: true);
                                          }
                                        })),
                              ]),
                        );
                      }
                    },
                    loading: () => buildLoadingWidget(),
                    error: (error, _) => buildErrorWidget(error),
                  ),
                  loading: () => buildLoadingWidget(),
                  error: (error, _) => buildErrorWidget(error),
                ),
              ),
              CustomStyles.spacerBox,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Show Target Line'),
                  Switch.adaptive(
                    value: showTargetLine,
                    onChanged: (newValue) {
                      setState(() {
                        showTargetLine = newValue;
                      });
                    },
                  ),
                ],
              ),
              CustomStyles.spacerBox,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Show Retirement Date'),
                  Switch.adaptive(
                    value: showRetirementDate,
                    onChanged: (newValue) {
                      setState(() {
                        showRetirementDate = newValue;
                      });
                    },
                  ),
                ],
              ),
            ])));
  }

  Widget buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget buildErrorWidget(Object error) {
    return Center(child: Text('Error loading data: $error'));
  }
}
