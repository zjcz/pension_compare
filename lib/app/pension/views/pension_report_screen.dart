import 'package:flutter/material.dart';
import 'package:pension_compare/app/home/controllers/yearly_pension_statement_controller.dart';
import 'package:pension_compare/app/home/models/pension_with_statement_model.dart';
import 'package:pension_compare/app/home/models/yearly_pension_statement_model.dart';
import 'package:pension_compare/app/otherIncome/controllers/other_income_controller.dart';
import 'package:pension_compare/app/otherIncome/models/other_income_model.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/app/pension/views/widgets/target_vs_actual_chart.dart';
import 'package:pension_compare/app/settings/controllers/secure_settings_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pension_compare/app/statement/models/statement_model.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/constants/pension_status.dart';
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
    final otherIncomeData = ref.watch(otherIncomeControllerProvider);

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
                    data: (yearlySummary) => otherIncomeData.when(
                      data: (otherIncomes) {
                        return SingleChildScrollView(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                DashboardTile(
                                    title: 'Projected Monthly Income',
                                    child: TargetVsActualChart(
                                        pensionData:
                                            addStatePensionToPensionList(
                                                yearlySummary,
                                                otherIncomes.firstOrNull),
                                        retirementDate: showRetirementDate
                                            ? settings.retirementDate
                                            : null,
                                        targetValue: showTargetLine
                                            ? settings.targetIncome
                                            : null,
                                        hideTitle: true)),
                                CustomStyles.spacerBox,
                                if (settings.targetIncome != null)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                if (settings.retirementDate != null)
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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

  List<YearlyPensionStatementModel> addStatePensionToPensionList(
      List<YearlyPensionStatementModel> pensionData,
      OtherIncomeModel? statePension) {
    if (statePension == null) {
      return pensionData;
    }

    List<YearlyPensionStatementModel> combinedData = [];
    for (YearlyPensionStatementModel item in pensionData) {
      List<PensionWithStatementModel> oldList = item.pensionWithStatement;
      List<PensionWithStatementModel> newList = List.from(oldList)
        ..add(PensionWithStatementModel(
            pension: PensionModel(
              pensionId: -statePension.otherIncomeId!,
              name: statePension.name,
              status: PensionStatus.active,
              statusDate: DateTime.now(),
            ),
            statement: StatementModel(
                pension: -statePension.otherIncomeId!,
                statementDate: DateTime(item.year, 1, 1),
                planValue: 0,
                projectedAnnualAmount: statePension.annualAmount)));

      combinedData.add(YearlyPensionStatementModel(
        year: item.year,
        pensionWithStatement: newList,
      ));
    }

    return combinedData;
  }
}
