import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pension_compare/constants/custom_styles.dart';

/// Widget to encapsulate the terms of use text and links to the terms and conditions and privacy policy.
class TermsOfUseWidget extends StatelessWidget {
  final Function termsAndConditionsTap;
  final Function privacyPolicyTap;
  const TermsOfUseWidget(
      {super.key,
      required this.termsAndConditionsTap,
      required this.privacyPolicyTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "Please read and accept our ",
          style: Theme.of(context).textTheme.bodyMedium,
          children: [
            TextSpan(
              text: "Terms & Conditions",
              style: CustomStyles.highlightedTextStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  termsAndConditionsTap();
                },
            ),
            const TextSpan(text: " and "),
            TextSpan(
              text: "Privacy Policy",
              style: CustomStyles.highlightedTextStyle,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  privacyPolicyTap();
                },
            ),
            const TextSpan(text: " before continuing."),
          ],
        ),
      ),
    );
  }
}
