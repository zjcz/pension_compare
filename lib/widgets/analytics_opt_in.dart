import 'package:flutter/material.dart';
import 'package:pension_compare/constants/custom_styles.dart';

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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('I agree'),
              Switch.adaptive(
                key: Key('${key.toString()}_switch'),
                value: optIntoAnalyticsValue,
                onChanged: onChanged,
              ),
            ],
          ),
        ]);
  }
}
