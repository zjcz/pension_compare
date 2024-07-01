import 'package:pension_compare/helpers/responsive.dart';
import 'package:flutter/material.dart';
import 'package:pension_compare/constants/defaults.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/extensions/material_colors.dart';

class DashboardTitle extends StatelessWidget {
  const DashboardTitle({
    super.key,
    required this.title,
    this.color,
  });

  final String title;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 24,
          decoration: BoxDecoration(
            color: color ?? context.primary,
            borderRadius: const BorderRadius.all(
                Radius.circular(AppDefaults.borderRadius / 3)),
          ),
        ),
        CustomStyles.gapW8,
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: Responsive.isDesktop(context) ? null : 20,
              ),
        )
      ],
    );
  }
}
