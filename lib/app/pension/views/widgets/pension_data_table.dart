import 'package:flutter/material.dart';
import 'package:pension_compare/app/home/models/pension_with_statement_model.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/constants/chart_color_constants.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/constants/defaults.dart';
import 'package:pension_compare/helpers/currency_helper.dart';
import 'package:pension_compare/service_locator.dart';

class PensionDataTable extends StatefulWidget {
  final List<PensionWithStatementModel> pensionDataList;
  final Function(PensionModel) onTap;

  const PensionDataTable(
      {super.key, required this.pensionDataList, required this.onTap});

  @override
  State<PensionDataTable> createState() => _PensionDataTableState();
}

class _PensionDataTableState extends State<PensionDataTable> {
  @override
  Widget build(BuildContext context) {
    ChartColorConstants chartColorConstants = getIt<ChartColorConstants>();

    if (widget.pensionDataList.isEmpty) {
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
        ],
        rows:
            List<DataRow>.generate(widget.pensionDataList.length, (int index) {
          PensionWithStatementModel pensionData = widget.pensionDataList[index];
          return DataRow(
            onSelectChanged: (bool? selected) =>
                widget.onTap(pensionData.pension),
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
                  onTap: () => widget.onTap(pensionData.pension)),
              DataCell(Text(CurrencyHelper.formatCurrency(
                  pensionData.statement?.planValue ?? 0))),
              DataCell(Text(CurrencyHelper.formatCurrency(
                  pensionData.statement?.projectedAnnualAmount ?? 0))),
              DataCell(Text(CurrencyHelper.formatCurrency(
                  pensionData.statement?.yearlyCharges ?? 0))),
              DataCell(Text(CurrencyHelper.formatCurrency(
                  pensionData.statement?.transferValue ?? 0)))
            ],
          );
        }),
      ),
    );
  }
}
