import 'package:flutter/material.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:pension_compare/database/tables/pensions_with_latest_statement.dart';
import 'package:pension_compare/screens/edit_pension_screen.dart';
import 'package:pension_compare/screens/edit_statement_screen.dart';
import 'package:pension_compare/screens/edit_state_pension_screen.dart';
import 'package:pension_compare/screens/settings_screen.dart';
import 'package:pension_compare/settings/settings_service.dart';
import 'package:pension_compare/widgets/pension_data_table.dart';
import 'package:pension_compare/widgets/pension_summary_chart.dart';
import 'package:pension_compare/screens/pension_overview_screen.dart';

// TODO - Add Settings button
class HomeScreen extends StatefulWidget {
  final DatabaseService databaseService;

  const HomeScreen({super.key, required this.databaseService});

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
    DatabaseService db = _getDatabaseService();
    Future<List<PensionWithLatestStatement>> pensionsSummaryData =
        db.getAllPensionsWithLatestStatement();

    return Scaffold(
        appBar: AppBar(title: const Text('Overview'), actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditPensionScreen()))
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
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditPensionScreen(
                                databaseService: widget.databaseService)))
                    .then((_) => {setState(() {})});
              } else if (value == 'statement') {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditStatementScreen(
                                databaseService: widget.databaseService)))
                    .then((_) => {setState(() {})});
              } else if (value == 'state_pension') {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => EditStatePensionScreen(
                                databaseService: widget.databaseService)))
                    .then((_) => {setState(() {})});
              } else if (value == 'settings') {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsScreen(
                                settingsService: SettingsService())))
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
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PensionSummaryChart(pensionData: pensions),
                                PensionDataTable(
                                  pensionDataList: pensions,
                                  onTap: (Pension pension) {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PensionOverviewScreen(
                                                      pension: pension,
                                                      databaseService: db,
                                                    )))
                                        .then((_) => {setState(() {})});
                                  },
                                )
                              ]);
                        }
                      },
                    )),
              ),
            ],
          ),
        ));
  }

  DatabaseService _getDatabaseService() {
    return widget.databaseService;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
