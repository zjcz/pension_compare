import 'package:flutter/material.dart';
import 'package:pension_compare/constants/custom_styles.dart';
import 'package:pension_compare/widgets/custom_switch.dart';

class AnalyticsOptIn extends StatelessWidget {
  final bool optIntoAnalyticsValue;
  final Function(bool) onChanged;
  const AnalyticsOptIn(
      {super.key,
      required this.optIntoAnalyticsValue,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
              'I agree for analytics and crash data to be sent to Google to help improve this application'),
          CustomStyles.spacerBox,
          CustomSwitch(
            key: key,
            labelText: 'I agree',
            onChanged: onChanged,
            switchValue: optIntoAnalyticsValue,
          )
        ]);
  }
}
