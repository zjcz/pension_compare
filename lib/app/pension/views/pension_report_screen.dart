import 'package:flutter/material.dart';
import 'package:pension_compare/app/home/controllers/yearly_pension_statement_controller.dart';
import 'package:pension_compare/app/pension/views/widgets/target_vs_actual_chart.dart';
import 'package:pension_compare/app/settings/controllers/secure_settings_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/widgets/dashboard/dashboard_tile.dart';

class PensionReportScreen extends ConsumerStatefulWidget {
  const PensionReportScreen({super.key});

  @override
  ConsumerState<PensionReportScreen> createState() =>
      _PensionReportScreenState();
}

class _PensionReportScreenState extends ConsumerState<PensionReportScreen> {
  bool showTargetLine = false;
  bool showRetirementDate = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final settingsData = ref.watch(secureSettingsControllerProvider);
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
                child: settingsData.when(
                  data: (settings) => yearlyPensionSummaryData.when(
                    data: (yearlySummary) {
                      return SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DashboardTile(
                                  title: 'Projected Monthly Income',
                                  child: TargetVsActualChart(
                                      pensionData: yearlySummary,
                                      retirementDate: showRetirementDate
                                          ? settings?.retirementDate
                                          : null,
                                      targetValue: showTargetLine
                                          ? settings?.targetIncome
                                          : null,
                                      hideTitle: true)),
                              CustomStyles.spacerBox,
                              if (settings?.targetIncome != null)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                              if (settings?.retirementDate != null)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                            ]),
                      );
                    },
                    loading: () => buildLoadingWidget(),
                    error: (error, _) => buildErrorWidget(error),
                  ),
                  loading: () => buildLoadingWidget(),
                  error: (error, _) => buildErrorWidget(error),
                ),
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
