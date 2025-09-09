import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pension_compare/app/home/models/pension_with_statement_model.dart';
import 'package:pension_compare/app/home/models/yearly_pension_statement_model.dart';
import 'package:pension_compare/app/pension/views/widgets/legends_list_widget.dart';
import 'package:pension_compare/constants/chart_color_constants.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/helpers/currency_helper.dart';
import 'package:pension_compare/service_locator.dart';

class TargetVsActualChart extends StatefulWidget {
  final List<YearlyPensionStatementModel>? pensionData;
  final double? targetValue;
  final DateTime? retirementDate;
  final bool hideTitle;

  const TargetVsActualChart(
      {super.key,
      this.pensionData,
      this.retirementDate,
      this.targetValue,
      this.hideTitle = false});

  @override
  State<TargetVsActualChart> createState() => _TargetVsActualChartState();
}

class _TargetVsActualChartState extends State<TargetVsActualChart> {
  static const double _barWidth = 30;
  Map<int, Legend> legendList = {};
  List<YearlyPensionStatementModel> _reportData = [];
  final String _currencySymbol = CurrencyHelper.getCurrencySymbol();

  @override
  Widget build(BuildContext context) {
    if (widget.pensionData == null) {
      return const Center(child: Text('No data'));
    }
    _reportData = List.from(widget.pensionData!);
    if (widget.retirementDate != null) {
      int maxYear = _reportData.last.year;
      if (maxYear < widget.retirementDate!.year) {
        // add empty data for the years after retirement
        for (int i = maxYear + 1; i <= widget.retirementDate!.year; i++) {
          _reportData.add(
              YearlyPensionStatementModel(year: i, pensionWithStatement: []));
        }
      }
    }

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (!widget.hideTitle)
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text('Target vs Actual',
              style: Theme.of(context).textTheme.titleMedium),
        ]),
      AspectRatio(
          aspectRatio: 1,
          child: BarChart(
            getChartData(),
          )),
      legendList.isEmpty
          ? const SizedBox()
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomStyles.spacerBox,
                LegendsListWidget(legends: legendList.values.toList())
              ],
            ),
    ]);
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: true,
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (BarChartGroupData group) => Colors.grey,
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
              '${_reportData[groupIndex].pensionWithStatement[rodIndex].pension.name}\n'
              '${_reportData[groupIndex].year}\n'
              '${CurrencyHelper.formatCurrency(rod.toY - rod.fromY, _currencySymbol)}',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  ExtraLinesData? buildExtraLinesData(double? value) {
    return value == null
        ? null
        : ExtraLinesData(
            extraLinesOnTop: true,
            horizontalLines: [
              HorizontalLine(
                y: value,
                color: Colors.red,
                strokeWidth: 2,
                dashArray: [5, 5],
                label: HorizontalLineLabel(
                  labelResolver: (line) =>
                      'Target: ${CurrencyHelper.formatCurrency(value)}',
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 10),
                  style: CustomStyles.chartBottomTitlesTextStyle,
                ),
              ),
            ],
          );
  }

  Widget getBottomTitles(double value, TitleMeta meta) {
    String text = '';
    if (_reportData.length < 5 ||
        value == 0 ||
        value == _reportData.length - 1) {
      text = _reportData[value.toInt()].year.toString();
    }

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

  List<BarChartGroupData> get projectedAnnualAmountBarGroups => _reportData
      .asMap()
      .entries
      .map((entry) => BarChartGroupData(
            x: entry.key,
            groupVertically: true,
            barRods: buildBarRodDataForYear(entry.value.pensionWithStatement),
          ))
      .toList();

  List<BarChartRodData> buildBarRodDataForYear(
      List<PensionWithStatementModel> data) {
    int fromY = 0;
    int toY = 0;
    List<BarChartRodData> barChartRodData = [];
    ChartColorConstants chartColorConstants = getIt<ChartColorConstants>();

    for (var index = 0; index < data.length; index++) {
      final pensionData = data[index];
      Color color = chartColorConstants
          .getColorForPension(pensionData.pension.pensionId!);

      if (legendList[pensionData.pension.pensionId!] == null) {
        legendList[pensionData.pension.pensionId!] = Legend(
          pensionData.pension.name,
          color,
        );
      }

      toY = fromY + pensionData.statement!.projectedAnnualAmount ~/ 12;
      barChartRodData.add(BarChartRodData(
        width: _barWidth,
        fromY: fromY.toDouble(),
        toY: toY.toDouble(),
        color: color,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(index == data.length - 1 ? 3 : 0),
          topRight: Radius.circular(index == data.length - 1 ? 3 : 0),
        ),
      ));
      fromY = toY;
    }

    return barChartRodData;
  }

  BarChartData getChartData() {
    double? maxY = widget.targetValue;
    maxY = maxY == null ? null : maxY + (maxY / 10);
    return BarChartData(
      maxY: maxY,
      barTouchData: barTouchData,
      titlesData: titlesData,
      borderData: borderData,
      barGroups: projectedAnnualAmountBarGroups,
      extraLinesData: buildExtraLinesData(widget.targetValue),
      gridData: FlGridData(
        show: true,
        checkToShowHorizontalLine: (value) => value % 10 == 0,
        getDrawingHorizontalLine: (value) => FlLine(
          color: Colors.grey.withValues(alpha: 0.3),
          strokeWidth: 1,
        ),
        drawVerticalLine: false,
      ),
      alignment: BarChartAlignment.spaceAround,
    );
  }
}
