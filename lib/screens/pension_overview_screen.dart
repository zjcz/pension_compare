import 'package:flutter/material.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:pension_compare/screens/edit_pension_screen.dart';
import 'package:pension_compare/screens/edit_statement_screen.dart';
import 'package:pension_compare/widgets/statement_data_table.dart';
import 'package:pension_compare/widgets/statement_summary_chart.dart';

// Pension Overview screen.  Shows an overview of one pension.
// Contains a chart and a table of statements.  Can edit the pension or add or
// edit statements.
class PensionOverviewScreen extends StatefulWidget {
  final DatabaseService databaseService;
  final Pension pension;

  const PensionOverviewScreen(
      {super.key, required this.pension, required this.databaseService});

  @override
  State<PensionOverviewScreen> createState() => _PensionOverviewScreenState();
}

class _PensionOverviewScreenState extends State<PensionOverviewScreen>
    with WidgetsBindingObserver {
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
    Future<List<Statement>> statementData =
        db.getAllStatementsForPension(widget.pension.pensionId);

    return Scaffold(
        appBar: AppBar(title: Text(widget.pension.name), actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => EditStatementScreen(
                              parentPension: widget.pension,
                              databaseService: widget.databaseService,
                            ))).then((_) => {setState(() {})});
              }),
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (BuildContext bc) {
              return const [
                PopupMenuItem(
                  value: 'pension',
                  child: Text("Edit Pension"),
                ),
              ];
            },
            onSelected: (value) async {
              if (value == 'pension') {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                EditPensionScreen(pension: widget.pension)))
                    .then((_) async => {setState(() {})});
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
                    child: FutureBuilder<List<Statement>>(
                      future: statementData,
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
                                  'No statements found.  Click + to add one'));
                        } else {
                          final List<Statement> statements = snapshot.data!;
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StatementSummaryChart(
                                    statementData: statements),
                                StatementDataTable(
                                  statementDataList: statements,
                                  onTap: (Statement statement) {
                                    Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    EditStatementScreen(
                                                      statement: statement,
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
