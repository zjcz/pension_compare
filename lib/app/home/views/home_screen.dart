import 'package:flutter/material.dart';
import 'package:pension_compare/app/home/models/pension_with_latest_statement_model.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/app/pension/views/widgets/pension_data_table.dart';
import 'package:pension_compare/app/pension/views/widgets/pension_summary_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/route_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pension_compare/app/home/controllers/home_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final pensionsSummaryData = ref.watch(homeControllerProvider);

    return Scaffold(
        appBar: AppBar(title: const Text('Overview'), actions: [
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
                await ref
                    .read(homeControllerProvider.notifier)
                    .populateTestData();
              }
            },
          ),
        ]),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: pensionsSummaryData.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) =>
                          Center(child: Text('Error loading data: $error')),
                      data: (List<PensionWithLatestStatementModel> pensions) {
                        if (pensions.isEmpty) {
                          return const Center(
                              child: Text(
                                  'No pensions found.  Click + to add one'));
                        } else {
                          return SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PensionSummaryChart(pensionData: pensions),
                                  PensionDataTable(
                                    pensionDataList: pensions,
                                    onTap: (PensionModel pension) {
                                      context
                                          .push(RouteDefs.pensionOverview,
                                              extra: pension)
                                          .then((_) => {setState(() {})});
                                    },
                                  )
                                ]),
                          );
                        }
                      },
                    )),
              ),
            ],
          ),
        ));
  }
}
