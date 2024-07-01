import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pension_compare/app/statement/models/statement_model.dart';
import 'package:pension_compare/constants/chart_color_constants.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/helpers/currency_helper.dart';
import 'package:pension_compare/helpers/date_helper.dart';
import 'package:pension_compare/service_locator.dart';

class StatementSummaryChart extends StatefulWidget {
  final List<StatementModel>? statementData;
  const StatementSummaryChart({super.key, this.statementData});

  @override
  State<StatementSummaryChart> createState() => _StatementSummaryChartState();
}

class _StatementSummaryChartState extends State<StatementSummaryChart> {
  PensionSummaryChartStyles _selectedStyle =
      PensionSummaryChartStyles.planValue;
  static const double barWidth = 30;
  MaterialColor _barColor = Colors.purple;
  final String _currencySymbol = CurrencyHelper.getCurrencySymbol();

  @override
  Widget build(BuildContext context) {
    if (widget.statementData == null) {
      return const Center(child: Text('No data'));
    }

    ChartColorConstants chartColorConstants = getIt<ChartColorConstants>();
    _barColor = chartColorConstants
        .getColorForPension(widget.statementData!.first.pension);

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
              '${DateHelper.formatDate(widget.statementData![groupIndex].statementDate)}\n'
              '${CurrencyHelper.formatCurrency(rod.toY, _currencySymbol)}',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getBottomTitles(double value, TitleMeta meta) {
    String text =
        widget.statementData![value.toInt()].statementDate.year.toString();

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

  List<BarChartGroupData> get planValueBarGroups => widget.statementData!
      .asMap()
      .entries
      .map((entry) => BarChartGroupData(
            x: entry.key,
            barRods: [buildBarRodData(entry.value.planValue)],
          ))
      .toList();

  List<BarChartGroupData> get projectedAnnualAmountBarGroups =>
      widget.statementData!
          .asMap()
          .entries
          .map((entry) => BarChartGroupData(
                x: entry.key,
                barRods: [buildBarRodData(entry.value.projectedAnnualAmount)],
              ))
          .toList();

  List<BarChartGroupData> get yearlyChargesBarGroups => widget.statementData!
      .asMap()
      .entries
      .map((entry) => BarChartGroupData(
            x: entry.key,
            barRods: [buildBarRodData(entry.value.yearlyCharges)],
          ))
      .toList();

  List<BarChartGroupData> get transferValueBarGroups => widget.statementData!
      .asMap()
      .entries
      .map((entry) => BarChartGroupData(
            x: entry.key,
            barRods: [buildBarRodData(entry.value.transferValue)],
          ))
      .toList();

  BarChartRodData buildBarRodData(double? value) {
    return BarChartRodData(
      width: barWidth,
      toY: value ?? 0,
      gradient: LinearGradient(
        colors: [_barColor, _barColor.shade900],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
      ),
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
      PensionSummaryChartStyles.planValue => 'Pension Plan Value',
      PensionSummaryChartStyles.projectedYearlyAmount =>
        'Pension Projected Yearly Amount',
      PensionSummaryChartStyles.yearlyCharges => 'Pension Yearly Charges',
      PensionSummaryChartStyles.transferValue => 'Pension Transfer Value',
    };
  }
}

enum PensionSummaryChartStyles {
  planValue,
  projectedYearlyAmount,
  yearlyCharges,
  transferValue
}
