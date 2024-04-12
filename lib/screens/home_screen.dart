import 'package:pension_compare/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:pension_compare/database/tables/pensions_with_latest_statement.dart';
import 'package:pension_compare/widgets/pension_data_table.dart';
import 'package:pension_compare/widgets/pension_summary_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/route_config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    DatabaseService db = getIt<DatabaseService>();
    Future<List<PensionWithLatestStatement>> pensionsSummaryData =
        db.getAllPensionsWithLatestStatement();

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
                await db.populateTestData();
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
                    child: FutureBuilder<List<PensionWithLatestStatement>>(
                      future: pensionsSummaryData,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text(
                                  'Error loading data: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(
                              child: Text(
                                  'No pensions found.  Click + to add one'));
                        } else {
                          final List<PensionWithLatestStatement> pensions =
                              snapshot.data!;
                          return SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  PensionSummaryChart(pensionData: pensions),
                                  PensionDataTable(
                                    pensionDataList: pensions,
                                    onTap: (Pension pension) {
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
