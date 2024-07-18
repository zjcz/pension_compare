import 'package:flutter/material.dart';
import 'package:pension_compare/app/home/models/pension_with_statement_model.dart';
import 'package:pension_compare/app/otherIncome/models/other_income_model.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/constants/chart_color_constants.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/constants/defaults.dart';
import 'package:pension_compare/helpers/currency_helper.dart';
import 'package:pension_compare/service_locator.dart';

class PensionDataTable extends StatefulWidget {
  final List<PensionWithStatementModel> pensionDataList;
  final List<OtherIncomeModel> otherIncomeDataList;
  final Function(PensionModel) onPensionTap;
  final Function(OtherIncomeModel) onOtherItemTap;

  const PensionDataTable(
      {super.key,
      required this.pensionDataList,
      required this.otherIncomeDataList,
      required this.onPensionTap,
      required this.onOtherItemTap
      });

  @override
  State<PensionDataTable> createState() => _PensionDataTableState();
}

class _PensionDataTableState extends State<PensionDataTable> {
  @override
  Widget build(BuildContext context) {
    if (widget.pensionDataList.isEmpty ) {
      return const Center(
          child: Text('No pensions found.  Click + to add one'));
    }

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
            DataColumn(
              label: Text(
                'Paid In',
                style: CustomStyles.dataTableHeaderTextStyle,
              ),
            ),
          ],
          rows: buildDataRows()),
    );
  }

  List<DataRow> buildDataRows() {
    ChartColorConstants chartColorConstants = getIt<ChartColorConstants>();

    List<DataRow> dataRows =
        List<DataRow>.generate(widget.pensionDataList.length, (int index) {
      PensionWithStatementModel pensionData = widget.pensionDataList[index];
      return DataRow(
        onSelectChanged: (bool? selected) => widget.onPensionTap(pensionData.pension),
        cells: <DataCell>[
          DataCell(
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 12,
                    decoration: BoxDecoration(
                      color: chartColorConstants.getColorForPension(
                          pensionData.pension.pensionId ?? 0),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(AppDefaults.borderRadius / 3)),
                    ),
                  ),
                  CustomStyles.gapW8,
                  Text(pensionData.pension.name)
                ],
              ),
              onTap: () => widget.onPensionTap(pensionData.pension)),
          DataCell(Text(CurrencyHelper.formatCurrency(
              pensionData.statement?.planValue ?? 0))),
          DataCell(Text(CurrencyHelper.formatCurrency(
              pensionData.statement?.projectedAnnualAmount ?? 0))),
          DataCell(Text(CurrencyHelper.formatCurrency(
              pensionData.statement?.yearlyCharges ?? 0))),
          DataCell(Text(CurrencyHelper.formatCurrency(
              pensionData.statement?.transferValue ?? 0))),
          DataCell(Text(CurrencyHelper.formatCurrency(
              pensionData.statement?.amountPaidIn ?? 0)))
        ],
      );
    });

    dataRows.addAll(
        List<DataRow>.generate(widget.otherIncomeDataList.length, (int index) {
      OtherIncomeModel otherIncomeData = widget.otherIncomeDataList[index];
      return DataRow(
        onSelectChanged: (bool? selected) => widget.onOtherItemTap(otherIncomeData),
        cells: <DataCell>[
          DataCell(
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 12,
                    decoration: BoxDecoration(
                      color: chartColorConstants.getColorForPension(-1),
                      borderRadius: const BorderRadius.all(
                          Radius.circular(AppDefaults.borderRadius / 3)),
                    ),
                  ),
                  CustomStyles.gapW8,
                  Text(otherIncomeData.name)
                ],
              ),
              onTap: () => widget.onOtherItemTap(otherIncomeData)),
          const DataCell(Text('')),
          DataCell(Text(CurrencyHelper.formatCurrency(
              otherIncomeData.annualAmount))),
          const DataCell(Text('')),
          const DataCell(Text('')),
          const DataCell(Text(''))
        ],
      );
    }));

    return dataRows;
  }
}
