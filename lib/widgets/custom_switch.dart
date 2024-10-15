import 'package:flutter/material.dart';

class CustomSwitch extends StatelessWidget {
  final String? labelText;
  final bool switchValue;
  final Function(bool value)? onChanged;

  const CustomSwitch(
      {super.key, this.labelText, this.onChanged, this.switchValue = true});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            onChanged!(!switchValue);
          },
          child: Text(
            labelText ?? '',
            key: Key('${key.toString()}_label'),
          ),
        ),
        Switch.adaptive(
          key: Key('${key.toString()}_switch'),
          value: switchValue,
          onChanged: onChanged,          
        ),
      ],
    );
  }
}
