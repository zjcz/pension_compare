import 'package:flutter/material.dart';

import 'package:pension_compare/constants/defaults.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/extensions/material_colors.dart';
import 'package:pension_compare/widgets/dashboard/dashboard_title.dart';

class DashboardTile extends StatefulWidget {
  final String title;
  final Widget child;
  const DashboardTile({super.key, required this.title, required this.child});

  @override
  State<DashboardTile> createState() => _DashboardTileState();
}

class _DashboardTileState extends State<DashboardTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDefaults.padding),
      decoration: BoxDecoration(
        color: context.onSecondary,
        borderRadius:
            const BorderRadius.all(Radius.circular(AppDefaults.borderRadius)),
      ),
      child: Column(
        children: [
          DashboardTitle(title: widget.title),
          CustomStyles.spacerBox,
          widget.child
        ],
      ),
    );
  }
}
