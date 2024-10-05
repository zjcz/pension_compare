import 'package:flutter/material.dart';
import 'package:pension_compare/app/pension/controllers/single_pension_controller.dart';
import 'package:pension_compare/app/statement/controllers/statement_controller.dart';
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
  final int pensionId;

  const PensionOverviewScreen({super.key, required this.pensionId});

  @override
  ConsumerState<PensionOverviewScreen> createState() =>
      _PensionOverviewScreenState();
}

class _PensionOverviewScreenState extends ConsumerState<PensionOverviewScreen> {
  @override
  Widget build(BuildContext context) {
    final pensionData =
        ref.watch(singlePensionControllerProvider(widget.pensionId));
    final statementData =
        ref.watch(statementControllerProvider(widget.pensionId));

    return pensionData.when(
      data: (pensionData) {
        if (pensionData == null) {
          return const Center(child: Text('Pension not found'));
        }

        return Scaffold(
            appBar: AppBar(title: Text(pensionData.name), actions: [
              IconButton(
                  icon: const Icon(Icons.add, semanticLabel: 'Add New Statement',),
                  onPressed: () async {
                    await context.push(RouteDefs.editStatement,
                        extra: pensionData);
                  }),
              PopupMenuButton(
                icon: const Icon(Icons.more_vert, semanticLabel: 'More Options',),
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
                    await context.push(RouteDefs.editPension,
                        extra: pensionData);
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
                              return SingleChildScrollView(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      StatementSummaryChart(
                                          statementData: statements),
                                      StatementDataTable(
                                        statementDataList: statements,
                                        onTap:
                                            (StatementModel statement) async {
                                          await context.push(
                                              RouteDefs.editStatement,
                                              extra: (pensionData, statement));
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
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Error loading data: $error')),
    );
  }
}
