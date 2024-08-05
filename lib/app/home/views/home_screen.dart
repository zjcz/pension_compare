import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pension_compare/app/home/controllers/pension_with_latest_statement_controller.dart';
import 'package:pension_compare/app/home/controllers/yearly_pension_statement_controller.dart';
import 'package:pension_compare/app/home/models/pension_with_statement_model.dart';
import 'package:pension_compare/app/otherIncome/controllers/other_income_controller.dart';
import 'package:pension_compare/app/otherIncome/models/other_income_model.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/app/pension/views/widgets/pension_data_table.dart';
import 'package:pension_compare/app/pension/views/widgets/pension_summary_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/app/settings/controllers/secure_settings_controller.dart';
import 'package:pension_compare/app/settings/models/secure_settings_model.dart';
import 'package:pension_compare/app/statement/models/statement_model.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/constants/pension_status.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/route_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pension_compare/widgets/dashboard/dashboard_tile.dart';
import 'package:pension_compare/widgets/dashboard/target_vs_actual.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final pensionsSummaryData =
        ref.watch(pensionWithLatestStatementControllerProvider);
    final yearlyPensionSummaryData =
        ref.watch(yearlyPensionStatementControllerProvider);
    final settingsData = ref.watch(secureSettingsControllerProvider);
    final otherIncomeData = ref.watch(otherIncomeControllerProvider);

    return Scaffold(
        appBar: AppBar(title: const Text('Pension Compare'), actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await context.push(RouteDefs.editPension);
            },
          ),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext bc) {
              return const [
                PopupMenuItem(
                  value: 'pension',
                  child: Text("Add Pension"),
                ),
                PopupMenuItem(
                  value: 'statement',
                  child: Text("Add Statement"),
                ),
                PopupMenuItem(
                  value: 'state_pension',
                  child: Text("Edit State Pension"),
                ),
                PopupMenuItem(
                  value: 'settings',
                  child: Text("Settings"),
                ),
                PopupMenuItem(
                  value: 'about',
                  child: Text("About..."),
                ),
                if (kDebugMode)
                  PopupMenuItem(
                    value: 'reset_test_data',
                    child: Text("Reset Test Data"),
                  )
              ];
            },
            onSelected: (value) async {
              if (value == 'pension') {
                await context.push(RouteDefs.editPension);
              } else if (value == 'statement') {
                await context.push(RouteDefs.editStatement);
              } else if (value == 'state_pension') {
                await context.push(RouteDefs.editStatePension);
              } else if (value == 'settings') {
                await context.push(RouteDefs.editSettings);
              } else if (value == 'about') {
                await context.push(RouteDefs.aboutScreen);
              } else if (value == 'reset_test_data' && kDebugMode) {
                await ref.read(DatabaseService.provider).populateTestData();
              }
            },
          ),
        ]),
        body: SafeArea(
          minimum: const EdgeInsets.all(10.0),
          child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: settingsData.when(
                data: (settings) => otherIncomeData.when(
                  data: (otherIncomes) => yearlyPensionSummaryData.when(
                    data: (yearlySummary) => pensionsSummaryData.when(
                      data: (List<PensionWithStatementModel> pensions) {
                        if (pensions.isEmpty && yearlySummary.isEmpty) {
                          return const Center(
                              child: Text(
                                  'No pensions found.  Click + to add one'));
                        } else {
                          return SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  DashboardTile(
                                      title: 'Monthly Income',
                                      child: GestureDetector(
                                        onTap: () {
                                          context
                                              .push(RouteDefs.pensionProgress)
                                              .then((_) => {setState(() {})});
                                        },
                                        child: buildTargetVsActual(
                                            pensions, otherIncomes, settings),
                                      )),
                                  CustomStyles.spacerBox,
                                  DashboardTile(
                                      title: 'Pensions',
                                      child: PensionDataTable(
                                        pensionDataList: pensions,
                                        otherIncomeDataList: otherIncomes,
                                        onPensionTap: (PensionModel pension) {
                                          context.push(
                                              '${RouteDefs.pensionOverview}/${pension.pensionId}');
                                        },
                                        onOtherItemTap:
                                            (OtherIncomeModel otherIncome) {
                                          context
                                              .push(RouteDefs.editStatePension);
                                        },
                                      )),
                                  CustomStyles.spacerBox,
                                  DashboardTile(
                                    title: "Pension Summary",
                                    child: PensionSummaryChart(
                                        pensionData:
                                            addStatePensionToPensionList(
                                                pensions,
                                                otherIncomes.firstOrNull)),
                                  ),
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
                  loading: () => buildLoadingWidget(),
                  error: (error, _) => buildErrorWidget(error),
                ),
                loading: () => buildLoadingWidget(),
                error: (error, _) => buildErrorWidget(error),
              )),
        ));
  }

  Widget buildLoadingWidget() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget buildErrorWidget(Object error) {
    return Center(child: Text('Error loading data: $error'));
  }

  TargetVsActual buildTargetVsActual(
      List<PensionWithStatementModel> pensionData,
      List<OtherIncomeModel> otherIncomeData,
      SecureSettingsModel? settings) {
    double projectedMonthlyValue = 0;

    for (var pensionRecord in pensionData) {
      if (pensionRecord.statement != null) {
        projectedMonthlyValue +=
            pensionRecord.statement!.projectedAnnualAmount / 12;
      }
    }

    for (var otherIncomeRecord in otherIncomeData) {
      projectedMonthlyValue += otherIncomeRecord.annualAmount / 12;
    }

    return TargetVsActual(
      targetValue: settings?.targetIncome,
      actualValue: projectedMonthlyValue,
      retirementDate: settings?.retirementDate,
    );
  }

  List<PensionWithStatementModel> addStatePensionToPensionList(
      List<PensionWithStatementModel> pensionData,
      OtherIncomeModel? statePension) {
    if (statePension == null) {
      return pensionData;
    }

    List<PensionWithStatementModel> combinedData = List.from(pensionData);
    combinedData.add(PensionWithStatementModel(
        pension: PensionModel(
          pensionId: -statePension.otherIncomeId!,
          name: statePension.name,
          status: PensionStatus.active,
          statusDate: DateTime.now(),
        ),
        statement: StatementModel(
            pension: -statePension.otherIncomeId!,
            statementDate: DateTime.now(),
            planValue: 0,
            projectedAnnualAmount: statePension.annualAmount)));

    return combinedData;
  }
}
