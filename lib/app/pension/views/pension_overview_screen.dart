import 'package:flutter/material.dart';
import 'package:pension_compare/app/statement/controllers/statement_controller.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/app/statement/models/statement_model.dart';
import 'package:pension_compare/app/statement/views/widgets/statement_data_table.dart';
import 'package:pension_compare/app/statement/views/widgets/statement_summary_chart.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/route_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Pension Overview screen.  Shows an overview of one pension.
// Contains a chart and a table of statements.  Can edit the pension or add or
// edit statements.
class PensionOverviewScreen extends ConsumerStatefulWidget {
  final PensionModel pension;

  const PensionOverviewScreen({super.key, required this.pension});

  @override
  ConsumerState<PensionOverviewScreen> createState() =>
      _PensionOverviewScreenState();
}

class _PensionOverviewScreenState extends ConsumerState<PensionOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    final statementData =
        ref.watch(statementControllerProvider(widget.pension.pensionId!));

    return Scaffold(
        appBar: AppBar(title: Text(widget.pension.name), actions: [
          IconButton(
              icon: const Icon(Icons.add),
              onPressed: () async {
                context
                    .push(RouteDefs.editStatement, extra: widget.pension)
                    .then((_) => {setState(() {})});
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
                context
                    .push(RouteDefs.editPension, extra: widget.pension)
                    .then((_) => {setState(() {})});
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
                    child: statementData.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (error, _) =>
                          Center(child: Text('Error loading data: $error')),
                      data: (List<StatementModel> statements) {
                        if (statements.isEmpty) {
                          return const Center(
                              child: Text(
                                  'No statements found.  Click + to add one'));
                        } else {
                          return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                StatementSummaryChart(
                                    statementData: statements),
                                StatementDataTable(
                                  statementDataList: statements,
                                  onTap: (StatementModel statement) {
                                    context.push(RouteDefs.editStatement,
                                        extra: (
                                          widget.pension,
                                          statement
                                        )).then((_) => {setState(() {})});
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
}
