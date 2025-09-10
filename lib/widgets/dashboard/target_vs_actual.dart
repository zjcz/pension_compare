import 'package:flutter/material.dart';
import 'package:pension_compare/extensions/material_colors.dart';
import 'package:pension_compare/helpers/currency_helper.dart';
import 'package:pension_compare/helpers/date_helper.dart';
import 'package:pension_compare/helpers/responsive.dart';
import 'package:pension_compare/constants/defaults.dart';
import 'package:pension_compare/constants/custom_styles.dart';

class TargetVsActual extends StatelessWidget {
  const TargetVsActual({
    super.key,
    this.targetValue,
    required this.actualValue,
    this.retirementDate,
  });
  final double? targetValue;
  final double actualValue;
  final DateTime? retirementDate;

  @override
  Widget build(BuildContext context) {
    String currencySymbol = CurrencyHelper.getCurrencySymbol();
    double difference = actualValue - (targetValue ?? 0);
    double differencePercentage =
        targetValue == null ? 0 : (actualValue / targetValue!) * 100;

    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDefaults.padding,
          vertical: AppDefaults.padding * 0.75),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 275.0,
            height: 275.0,
            padding: const EdgeInsets.all(1.0),
            child: Stack(alignment: Alignment.center, children: [
              Positioned.fill(
                child: CircularProgressIndicator.adaptive(
                  value: differencePercentage / 100,
                  backgroundColor: context.onPrimaryContainer,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      differencePercentage > 100
                          ? AppColors.success
                          : AppColors.error),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    CurrencyHelper.formatCurrency(actualValue, currencySymbol)
                        .replaceAll('.00', ''),
                    style: Responsive.isDesktop(context)
                        ? Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(fontWeight: FontWeight.bold)
                        : Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Target: ${targetValue == null ? "Not Set" : CurrencyHelper.formatCurrency(targetValue, currencySymbol).replaceAll('.00', '')}',
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  CustomStyles.smallestSpacerBox,
                  Chip(
                    backgroundColor: difference > 0
                        ? AppColors.success.withValues(alpha: 0.1)
                        : AppColors.error.withValues(alpha: 0.1),
                    side: BorderSide.none,
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppDefaults.padding * 0.25,
                        vertical: AppDefaults.padding * 0.25),
                    label: Text(
                      "Difference: ${difference > 0 ? "+" : ""}${CurrencyHelper.formatCurrency(difference, currencySymbol).replaceAll('.00', '')} (${differencePercentage.toStringAsFixed(1).replaceAll(".0", "")}%)",
                      style: TextStyle(
                          color: difference > 0
                              ? AppColors.success
                              : AppColors.error),
                    ),
                  ),
                  CustomStyles.smallestSpacerBox,
                  if (retirementDate != null)
                    Chip(
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDefaults.padding * 0.25,
                            vertical: AppDefaults.padding * 0.25),
                        label: Text(
                          'Retire in ${DateHelper.formatDifference(DateHelper.getToday(), retirementDate!)}',
                        )),
                ],
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
