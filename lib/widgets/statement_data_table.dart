import 'package:flutter/material.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:pension_compare/helpers/currency_helper.dart';
import 'package:pension_compare/helpers/date_helper.dart';

class StatementDataTable extends StatefulWidget {
  final List<Statement> statementDataList;
  final Function(Statement) onTap;

  const StatementDataTable(
      {super.key, required this.statementDataList, required this.onTap});

  @override
  State<StatementDataTable> createState() => _StatementDataTableState();
}

class _StatementDataTableState extends State<StatementDataTable> {
  @override
  Widget build(BuildContext context) {
    if (widget.statementDataList.isEmpty) {
      return const Center(
          child: Text('No statements found.  Click + to add one'));
    }
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        sortColumnIndex: 0,
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'Statement Date',
              style: CustomStyles.dataTableHeaderTextStyle,
            ),
          ),
          DataColumn(
            label: Text(
              'Plan Value',
              style: CustomStyles.dataTableHeaderTextStyle,
            ),
          ),
          DataColumn(
            label: Text(
              'Projected',
              style: CustomStyles.dataTableHeaderTextStyle,
            ),
          ),
          DataColumn(
            label: Text(
              'Charges',
              style: CustomStyles.dataTableHeaderTextStyle,
            ),
          ),
          DataColumn(
            label: Text(
              'Transfer',
              style: CustomStyles.dataTableHeaderTextStyle,
            ),
          ),
        ],
        rows: List<DataRow>.generate(widget.statementDataList.length,
            (int index) {
          Statement statementData = widget.statementDataList[index];
          return DataRow(
            onSelectChanged: (bool? selected) => widget.onTap(statementData),
            cells: <DataCell>[
              DataCell(Text(DateHelper.formatDate(statementData.statementDate)),
                  onTap: () => widget.onTap(statementData)),
              DataCell(
                  Text(CurrencyHelper.formatCurrency(statementData.planValue))),
              DataCell(Text(CurrencyHelper.formatCurrency(
                  statementData.projectedAnnualAmount))),
              DataCell(Text(CurrencyHelper.formatCurrency(
                  statementData.yearlyCharges ?? 0))),
              DataCell(Text(CurrencyHelper.formatCurrency(
                  statementData.transferValue ?? 0)))
            ],
          );
        }),
      ),
    );
  }
}
