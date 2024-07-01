import 'package:flutter/material.dart';
import 'package:pension_compare/app/home/models/pension_with_statement_model.dart';
import 'package:pension_compare/app/home/models/yearly_pension_statement_model.dart';
import 'package:pension_compare/app/pension/views/widgets/target_vs_actual_chart.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/constants/defaults.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/extensions/material_colors.dart';
import 'package:pension_compare/helpers/currency_helper.dart';
import 'package:pension_compare/service_locator.dart';
import 'package:pension_compare/widgets/dashboard/overview_tab.dart';

class OverviewTabs extends StatefulWidget {
  final List<PensionWithStatementModel>? pensionData;
  final List<YearlyPensionStatementModel>? yearlyPensionStatements;
  const OverviewTabs(
      {super.key, this.pensionData, this.yearlyPensionStatements});

  @override
  State<OverviewTabs> createState() => _OverviewTabsState();
}

class _OverviewTabsState extends State<OverviewTabs>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double yearlyChargesTotal = 0;
  double totalValue = 0;
  double projectedMonthlyValue = 0;
  Future<Settings>? settings;
  String currencySymbol = CurrencyHelper.getCurrencySymbol();

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    settings = _loadSettings();
    _calcTotals();
  }

  void _calcTotals() {
    if (widget.pensionData != null) {
      for (var pension in widget.pensionData!) {
        if (pension.statement != null) {
          projectedMonthlyValue +=
              pension.statement!.projectedAnnualAmount / 12;
          yearlyChargesTotal += pension.statement!.yearlyCharges ?? 0;
          totalValue += pension.statement!.transferValue ?? 0;
        }
      }
    }
  }

  Future<Settings> _loadSettings() async {
    return await getIt<SettingsService>().getAllSettings();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Settings>(
        future: settings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading data: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Not found'));
          } else {
            Settings settings = snapshot.data!;
            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: context.primaryContainer,
                    borderRadius: const BorderRadius.all(
                        Radius.circular(AppDefaults.borderRadius)),
                  ),
                  child: TabBar(
                    controller: _tabController,
                    dividerHeight: 0,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0, vertical: AppDefaults.padding),
                    indicator: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(AppDefaults.borderRadius),
                      ),
                      color: context.onPrimary,
                    ),
                    tabs: [
                      OverviewTab(
                        title: "Monthly Income",
                        icon: Icons.paid,
                        iconBgColor: AppColors.secondaryLavender,
                        description: CurrencyHelper.formatCurrency(
                                projectedMonthlyValue, currencySymbol)
                            .replaceAll('.00', ''),
                      ),
                      OverviewTab(
                        title: "Target vs Actual",
                        icon: Icons.balance,
                        description:
                            "${CurrencyHelper.formatCurrency(settings.targetIncome ?? 0, currencySymbol).replaceAll('.00', '')} / ${CurrencyHelper.formatCurrency(projectedMonthlyValue, currencySymbol).replaceAll('.00', '')}",
                        growthPercentage: settings.targetIncome == null
                            ? CurrencyHelper.formatCurrency(
                                projectedMonthlyValue)
                            : CurrencyHelper.formatCurrency(
                                settings.targetIncome! - projectedMonthlyValue),
                        isPositiveGrowth: ((settings.targetIncome ?? 0) <
                            projectedMonthlyValue),
                      ),
                    ],
                  ),
                ),
                CustomStyles.spacerBox,
                SizedBox(
                  height: 380,
                  child: TabBarView(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      Center(
                        child: TargetVsActualChart(
                            pensionData: widget.yearlyPensionStatements,
                            hideTitle: true),
                      ),
                      Center(
                        child: TargetVsActualChart(
                            targetValue: settings.targetIncome,
                            retirementDate: DateTime(
                                2042, 1, 1), // settings.retirementDate,
                            pensionData: widget.yearlyPensionStatements,
                            hideTitle: true),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }
        });
  }
}
