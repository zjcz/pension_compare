import 'package:flutter/material.dart';
import 'package:pension_compare/app/home/controllers/pension_with_latest_statement_controller.dart';
import 'package:pension_compare/app/home/controllers/yearly_pension_statement_controller.dart';
import 'package:pension_compare/app/home/models/pension_with_statement_model.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/app/pension/views/widgets/pension_data_table.dart';
import 'package:pension_compare/app/pension/views/widgets/pension_summary_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/app/settings/controllers/secure_settings_controller.dart';
import 'package:pension_compare/app/settings/models/secure_settings_model.dart';
import 'package:pension_compare/constants/custom_styles.dart';
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

    return Scaffold(
        appBar: AppBar(title: const Text('Pension Compare'), actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              context
                  .push(RouteDefs.editPension)
                  .then((_) => {setState(() {})});
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
                  value: 'reset_test_data',
                  child: Text("Reset Test Data"),
                )
              ];
            },
            onSelected: (value) async {
              if (value == 'pension') {
                context
                    .push(RouteDefs.editPension)
                    .then((_) => {setState(() {})});
              } else if (value == 'statement') {
                context
                    .push(RouteDefs.editStatement)
                    .then((_) => {setState(() {})});
              } else if (value == 'state_pension') {
                context
                    .push(RouteDefs.editStatePension)
                    .then((_) => {setState(() {})});
              } else if (value == 'settings') {
                context
                    .push(RouteDefs.editSettings)
                    .then((_) => {setState(() {})});
              } else if (value == 'reset_test_data') {
                await ref.read(DatabaseService.provider).populateTestData();
              }
            },
          ),
        ]),
        body: SafeArea(
          minimum: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: settingsData.when(
                      data: (settings) => yearlyPensionSummaryData.when(
                        data: (yearlySummary) => pensionsSummaryData.when(
                          data: (List<PensionWithStatementModel> pensions) {
                            if (pensions.isEmpty && yearlySummary.isEmpty) {
                              return const Center(
                                  child: Text(
                                      'No pensions found.  Click + to add one'));
                            } else {
                              return SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      DashboardTile(
                                          title: 'Monthly Income',
                                          child: GestureDetector(
                                            onTap: () {
                                              context
                                                  .push(
                                                      RouteDefs.pensionProgress)
                                                  .then(
                                                      (_) => {setState(() {})});
                                            },
                                            child: buildTargetVsActual(
                                                pensions, settings),
                                          )),
                                      CustomStyles.spacerBox,
                                      DashboardTile(
                                          title: 'Pensions',
                                          child: PensionDataTable(
                                            pensionDataList: pensions,
                                            onTap: (PensionModel pension) {
                                              context
                                                  .push(
                                                      '${RouteDefs.pensionOverview}/${pension.pensionId}')
                                                  .then(
                                                      (_) => {setState(() {})});
                                            },
                                          )),
                                      CustomStyles.spacerBox,
                                      DashboardTile(
                                          title: "Pension Summary",
                                          child: PensionSummaryChart(
                                              pensionData: pensions)),
                                      // TODO - Add Other Income list, Warnings / Missing statements
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
                    )),
              ),
            ],
          ),
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
      SecureSettingsModel? settings) {
    double projectedMonthlyValue = 0;

    for (var pensionRecord in pensionData) {
      if (pensionRecord.statement != null) {
        projectedMonthlyValue +=
            pensionRecord.statement!.projectedAnnualAmount / 12;
      }
    }

    return TargetVsActual(
      targetValue: settings?.targetIncome,
      actualValue: projectedMonthlyValue,
      retirementDate: settings?.retirementDate,
    );
  }
}
