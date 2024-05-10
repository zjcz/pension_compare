import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pension_compare/app/settings/views/widgets/restore_password_bottomsheet.dart';

import 'dart:async';

void main() {
  group('Restore Password Bottomsheet Widget Tests', () {
    testWidgets('Testing Restore Dialog Text', (tester) async {
      await tester.pumpWidget(createWidget((_) {}));

      expect(find.text("Restore"), findsOneWidget);
      expect(find.bySemanticsLabel('Password'), findsOneWidget);
      expect(find.widgetWithText(TextButton, "Select Backup File..."), findsOneWidget);
      expect(find.widgetWithText(TextButton, "Cancel"), findsOneWidget);
    });

    testWidgets('Testing cancel removes widget', (tester) async {
      final completer = Completer<String>();
      await tester.pumpWidget(createWidget(completer.complete));

      expect(find.byType(RestorePasswordBottomsheet), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Cancel"));
      await tester.pumpAndSettle();

      expect(find.byType(RestorePasswordBottomsheet), findsNothing);
      expect(completer.isCompleted, isFalse);
    });

    testWidgets('Testing confirm widget', (tester) async {
      bool saved = false;
      String passwordToSet = 'Password';
      String? confirmPassword;
      onConfirm(String password) {
        saved = true;
        confirmPassword = password;
      }

      await tester.pumpWidget(createWidget(onConfirm));
      await tester.enterText(find.bySemanticsLabel('Password'), passwordToSet);
      await tester.tap(find.widgetWithText(TextButton, "Select Backup File..."));
      await tester.pumpAndSettle();

      expect(saved, isTrue);
      expect(confirmPassword, isNotNull);
      expect(confirmPassword, passwordToSet);
    });

    testWidgets('Testing confirm widget with blank password', (tester) async {
      bool saved = false;
      String passwordToSet = '';
      String? confirmPassword;
      onConfirm(String password) {
        saved = true;
        confirmPassword = password;
      }

      await tester.pumpWidget(createWidget(onConfirm));
      await tester.enterText(find.bySemanticsLabel('Password'), passwordToSet);
      await tester.tap(find.widgetWithText(TextButton, "Select Backup File..."));
      await tester.pumpAndSettle();

      expect(saved, isTrue);
      expect(confirmPassword, isNotNull);
      expect(confirmPassword, passwordToSet);
    });
  });
}

/// Helper function to create the widget to test with
Widget createWidget(Function(String) onConfirm) {
  return MaterialApp(
      home: Scaffold(
    body: RestorePasswordBottomsheet(onConfirm: onConfirm),
  ));
}
