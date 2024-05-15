import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pension_compare/app/home/views/widgets/terms_of_use_widget.dart';

Widget createWidget(Function termsAndConditionsTap, Function privacyPolicyTap) {
  return MaterialApp(
    home: Scaffold(
      body: TermsOfUseWidget(
          termsAndConditionsTap: termsAndConditionsTap,
          privacyPolicyTap: privacyPolicyTap),
    ),
  );
}

void main() {
  group('TermsOfUseWidget', () {
    testWidgets('renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(createWidget(() {}, () {}));
      await tester.pumpAndSettle();

      expect(
          find.text(
              'Please read and accept our Terms & Conditions and Privacy Policy before continuing.',
              findRichText: true),
          findsOneWidget);
    });

    testWidgets(
        'navigates to policy viewer screen when Terms & Conditions is tapped',
        (WidgetTester tester) async {
      bool termsAndConditionsTapped = false;
      bool privacyPolicyTapped = false;
      onTermsAndConditionsTap() {
        termsAndConditionsTapped = true;
      }

      onPrivacyPolicyTap() {
        privacyPolicyTapped = true;
      }

      await tester.pumpWidget(
          createWidget(onTermsAndConditionsTap, onPrivacyPolicyTap));

      await tester.tap(find.byWidgetPredicate((widget) =>
          widget is RichText && tapTextSpan(widget, 'Terms & Conditions')));
      await tester.pumpAndSettle();

      expect(termsAndConditionsTapped, isTrue);
      expect(privacyPolicyTapped, isFalse);
    });

    testWidgets(
        'navigates to policy viewer screen when Privacy Policy is tapped',
        (WidgetTester tester) async {
      bool termsAndConditionsTapped = false;
      bool privacyPolicyTapped = false;
      onTermsAndConditionsTap() {
        termsAndConditionsTapped = true;
      }

      onPrivacyPolicyTap() {
        privacyPolicyTapped = true;
      }

      await tester.pumpWidget(
          createWidget(onTermsAndConditionsTap, onPrivacyPolicyTap));

      await tester.tap(find.byWidgetPredicate((widget) =>
          widget is RichText && tapTextSpan(widget, 'Privacy Policy')));
      await tester.pumpAndSettle();

      expect(termsAndConditionsTapped, isFalse);
      expect(privacyPolicyTapped, isTrue);
    });
  });
}

bool findTextAndTap(InlineSpan visitor, String text) {
  if (visitor is TextSpan && visitor.text == text) {
    if (visitor.recognizer != null &&
        visitor.recognizer is TapGestureRecognizer) {
      (visitor.recognizer! as TapGestureRecognizer).onTap!();
    }

    return false;
  }

  return true;
}

bool tapTextSpan(RichText richText, String text) {
  final isTapped = !richText.text.visitChildren(
    (visitor) => findTextAndTap(visitor, text),
  );

  return isTapped;
}
