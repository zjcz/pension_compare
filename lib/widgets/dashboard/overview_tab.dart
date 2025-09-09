import 'package:flutter/material.dart';
import 'package:pension_compare/helpers/responsive.dart';
import 'package:pension_compare/constants/defaults.dart';
import 'package:pension_compare/constants/custom_styles.dart';

class OverviewTab extends StatelessWidget {
  const OverviewTab({
    super.key,
    required this.title,
    required this.description,
    this.growthPercentage,
    this.isPositiveGrowth = true,
    this.icon,
    this.iconBgColor = AppColors.secondaryLightSkyBlue,
  });
  final String title, description;
  final String? growthPercentage;
  final IconData? icon;
  final bool isPositiveGrowth;
  final Color iconBgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppDefaults.padding,
          vertical: AppDefaults.padding * 0.75),
      width: double.infinity,
      // height: 100,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!Responsive.isMobile(context))
            CircleAvatar(
              radius: 20,
              backgroundColor: iconBgColor,
              child: Icon(
                icon,
                size: 24,
              ),
            ),
          if (!Responsive.isMobile(context)) CustomStyles.gapW16,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  description,
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
                if (Responsive.isMobile(context) && growthPercentage != null)
                  Column(
                    children: [
                      CustomStyles.smallestSpacerBox,
                      Chip(
                        backgroundColor: isPositiveGrowth
                            ? AppColors.success.withValues(alpha: 0.1)
                            : AppColors.error.withValues(alpha: 0.1),
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(
                            horizontal: AppDefaults.padding * 0.25,
                            vertical: AppDefaults.padding * 0.25),
                        label: Text(
                          isPositiveGrowth
                              ? "+$growthPercentage"
                              : "-$growthPercentage",
                          style: TextStyle(
                              color: isPositiveGrowth
                                  ? AppColors.success
                                  : AppColors.error),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (!Responsive.isMobile(context) && growthPercentage != null)
            Chip(
              backgroundColor: isPositiveGrowth
                  ? AppColors.success.withValues(alpha: 0.1)
                  : AppColors.error.withValues(alpha: 0.1),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(
                  horizontal: AppDefaults.padding * 0.25,
                  vertical: AppDefaults.padding * 0.25),
              label: Text(
                isPositiveGrowth ? "+$growthPercentage" : "-$growthPercentage",
                style: TextStyle(
                    color:
                        isPositiveGrowth ? AppColors.success : AppColors.error),
              ),
            ),
        ],
      ),
    );
  }
}
