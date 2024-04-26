import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pension_compare/app/home/models/pension_with_latest_statement_model.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/helpers/currency_helper.dart';

class PensionSummaryChart extends StatefulWidget {
  final List<PensionWithLatestStatementModel>? pensionData;
  const PensionSummaryChart({super.key, this.pensionData});

  @override
  State<PensionSummaryChart> createState() => _PensionSummaryChartState();
}

class _PensionSummaryChartState extends State<PensionSummaryChart> {
  PensionSummaryChartStyles _selectedStyle =
      PensionSummaryChartStyles.planValue;
  static const double barWidth = 30;

  @override
  Widget build(BuildContext context) {
    if (widget.pensionData == null) {
      return const Center(child: Text('No data'));
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(getChartTitle(_selectedStyle),
            style: Theme.of(context).textTheme.titleMedium),
        PopupMenuButton(
          icon: const Icon(Icons.arrow_drop_down_circle_outlined),
          itemBuilder: (BuildContext bc) {
            return const [
              PopupMenuItem(
                value: PensionSummaryChartStyles.planValue,
                child: Text("Plan Value"),
              ),
              PopupMenuItem(
                value: PensionSummaryChartStyles.projectedYearlyAmount,
                child: Text("Projected Yearly Amount"),
              ),
              PopupMenuItem(
                value: PensionSummaryChartStyles.yearlyCharges,
                child: Text("Yearly Charges"),
              ),
              PopupMenuItem(
                value: PensionSummaryChartStyles.transferValue,
                child: Text("Transfer Value"),
              ),
            ];
          },
          onSelected: (value) async {
            setState(() {
              _selectedStyle = value;
            });
          },
        ),
      ]),
      AspectRatio(
          aspectRatio: 1,
          child: BarChart(
            swapAnimationDuration: const Duration(milliseconds: 300),
            swapAnimationCurve: Curves.bounceIn,
            getChartData(_selectedStyle),
          ))
    ]);
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.grey,
          tooltipPadding: const EdgeInsets.all(5),
          tooltipMargin: 8,
          fitInsideHorizontally: true,
          fitInsideVertically: true,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              '${widget.pensionData![groupIndex].pension.name}\n'
              '${CurrencyHelper.formatCurrency(rod.toY)}',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getBottomTitles(double value, TitleMeta meta) {
    String text = widget.pensionData![value.toInt()].pension.name;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4,
      child: Text(text, style: CustomStyles.chartBottomTitlesTextStyle),
    );
  }

  Widget getLeftTitles(double value, TitleMeta meta) {
    // if (value == meta.max) {
    //   return Container();
    // }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        meta.formattedValue,
        style: CustomStyles.chartLeftTitlesTextStyle,
      ),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: getBottomTitles,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: getLeftTitles,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  LinearGradient get _customBarsGradient => const LinearGradient(
        colors: [Colors.deepPurple, Colors.purple],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  LinearGradient get _systemColorBarsGradient => LinearGradient(
        colors: [
          Theme.of(context).colorScheme.primary,
          Theme.of(context).colorScheme.secondary
        ],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      );

  List<BarChartGroupData> get planValueBarGroups => widget.pensionData!
      .asMap()
      .entries
      .map((entry) => BarChartGroupData(
            x: entry.key,
            barRods: [buildBarRodData(entry.value.latestStatement?.planValue)],
          ))
      .toList();

  List<BarChartGroupData> get projectedAnnualAmountBarGroups =>
      widget.pensionData!
          .asMap()
          .entries
          .map((entry) => BarChartGroupData(
                x: entry.key,
                barRods: [
                  buildBarRodData(
                      entry.value.latestStatement?.projectedAnnualAmount)
                ],
              ))
          .toList();

  List<BarChartGroupData> get yearlyChargesBarGroups => widget.pensionData!
      .asMap()
      .entries
      .map((entry) => BarChartGroupData(
            x: entry.key,
            barRods: [
              buildBarRodData(entry.value.latestStatement?.yearlyCharges)
            ],
          ))
      .toList();

  List<BarChartGroupData> get transferValueBarGroups => widget.pensionData!
      .asMap()
      .entries
      .map((entry) => BarChartGroupData(
            x: entry.key,
            barRods: [
              buildBarRodData(entry.value.latestStatement?.transferValue)
            ],
          ))
      .toList();

  BarChartRodData buildBarRodData(double? value) {
    return BarChartRodData(
      width: barWidth,
      toY: value ?? 0,
      gradient: _customBarsGradient,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(3),
        topRight: Radius.circular(3),
      ),
    );
  }

  BarChartData getChartData(PensionSummaryChartStyles selectedStyle) {
    return BarChartData(
      barTouchData: barTouchData,
      titlesData: titlesData,
      borderData: borderData,
      barGroups: switch (selectedStyle) {
        PensionSummaryChartStyles.planValue => planValueBarGroups,
        PensionSummaryChartStyles.projectedYearlyAmount =>
          projectedAnnualAmountBarGroups,
        PensionSummaryChartStyles.yearlyCharges => yearlyChargesBarGroups,
        PensionSummaryChartStyles.transferValue => transferValueBarGroups,
      },
      gridData: FlGridData(
        show: true,
        checkToShowHorizontalLine: (value) => value % 10 == 0,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey.withOpacity(0.3),
          strokeWidth: 1,
        ),
        drawVerticalLine: false,
      ),
      alignment: BarChartAlignment.spaceAround,
    );
  }

  String getChartTitle(PensionSummaryChartStyles selectedStyle) {
    return switch (selectedStyle) {
      PensionSummaryChartStyles.planValue => 'Pensions Plan Value',
      PensionSummaryChartStyles.projectedYearlyAmount =>
        'Pensions Projected Yearly Amount',
      PensionSummaryChartStyles.yearlyCharges => 'Pensions Yearly Charges',
      PensionSummaryChartStyles.transferValue => 'Pensions Transfer Value',
    };
  }
}

enum PensionSummaryChartStyles {
  planValue,
  projectedYearlyAmount,
  yearlyCharges,
  transferValue
}
