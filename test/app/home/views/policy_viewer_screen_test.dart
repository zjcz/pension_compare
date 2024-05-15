import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pension_compare/app/home/views/policy_viewer_screen.dart';

void main() {
  group('PolicyViewerScreen', () {
    testWidgets('renders Terms & Conditions correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: PolicyViewerScreen(policyType: PolicyType.termsAndConditions)));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Terms & Conditions'), findsOneWidget);
      expect(find.byType(MarkdownBody), findsOneWidget);
    });

    testWidgets('renders Privacy Policy correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
          home: PolicyViewerScreen(policyType: PolicyType.privacyPolicy)));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(AppBar, 'Privacy Policy'), findsOneWidget);
      expect(find.byType(MarkdownBody), findsOneWidget);
    });
  });
}
