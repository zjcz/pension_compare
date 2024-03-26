import 'package:flutter/material.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:pension_compare/database/tables/pensions_with_latest_statement.dart';
import 'package:pension_compare/helpers/currency_helper.dart';

class PensionDataTable extends StatefulWidget {
  final List<PensionWithLatestStatement> pensionDataList;
  final Function(Pension) onTap;

  const PensionDataTable(
      {super.key, required this.pensionDataList, required this.onTap});

  @override
  State<PensionDataTable> createState() => _PensionDataTableState();
}

class _PensionDataTableState extends State<PensionDataTable> {
  @override
  Widget build(BuildContext context) {
    if (widget.pensionDataList.isEmpty) {
      return const Center(
          child: Text('No pensions found.  Click + to add one'));
    }

// TODO - May need to replace with InteractiveViewer
// https://api.flutter.dev/flutter/widgets/InteractiveViewer-class.html
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        showCheckboxColumn: false,
        sortColumnIndex: 0,
        columns: const <DataColumn>[
          DataColumn(
            label: Text(
              'Pension',
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
        rows:
            List<DataRow>.generate(widget.pensionDataList.length, (int index) {
          PensionWithLatestStatement pensionData =
              widget.pensionDataList[index];
          return DataRow(
            onSelectChanged: (bool? selected) =>
                widget.onTap(pensionData.pension),
            cells: <DataCell>[
              DataCell(Text(pensionData.pension.name),
                  onTap: () => widget.onTap(pensionData.pension)),
              DataCell(Text(CurrencyHelper.formatCurrency(
                  pensionData.latestStatement?.planValue ?? 0))),
              DataCell(Text(CurrencyHelper.formatCurrency(
                  pensionData.latestStatement?.projectedAnnualAmount ?? 0))),
              DataCell(Text(CurrencyHelper.formatCurrency(
                  pensionData.latestStatement?.yearlyCharges ?? 0))),
              DataCell(Text(CurrencyHelper.formatCurrency(
                  pensionData.latestStatement?.transferValue ?? 0)))
            ],
          );
        }),
      ),
    );
  }
}
