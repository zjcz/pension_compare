import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pension_compare/app/settings/views/widgets/backup_password_bottomsheet.dart';

import 'dart:async';

void main() {
  group('Backup Password Bottomsheet Widget Tests', () {
    testWidgets('Testing Backup Dialog Text', (tester) async {
      await tester.pumpWidget(createWidget((_) {}));

      expect(find.text("Backup"), findsOneWidget);
      expect(find.bySemanticsLabel('Password'), findsOneWidget);
      expect(find.bySemanticsLabel('Confirm password'), findsOneWidget);
      expect(find.widgetWithText(TextButton, "Save Backup..."), findsOneWidget);
      expect(find.widgetWithText(TextButton, "Cancel"), findsOneWidget);
    });

    testWidgets('Testing cancel removes widget', (tester) async {
      final completer = Completer<String>();
      await tester.pumpWidget(createWidget(completer.complete));

      expect(find.byType(BackupPasswordBottomsheet), findsOneWidget);

      await tester.tap(find.widgetWithText(TextButton, "Cancel"));
      await tester.pumpAndSettle();

      expect(find.byType(BackupPasswordBottomsheet), findsNothing);
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
      await tester.enterText(
          find.bySemanticsLabel('Confirm password'), passwordToSet);
      await tester.tap(find.widgetWithText(TextButton, "Save Backup..."));
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
      await tester.enterText(
          find.bySemanticsLabel('Confirm password'), passwordToSet);
      await tester.tap(find.widgetWithText(TextButton, "Save Backup..."));
      await tester.pumpAndSettle();

      expect(saved, isTrue);
      expect(confirmPassword, isNotNull);
      expect(confirmPassword, passwordToSet);
    });

    testWidgets('Testing validating widget', (tester) async {
      bool saved = false;
      String passwordToSet = 'Password';
      String confirmPasswordToSet = 'Different Password';
      String? confirmPassword;
      onConfirm(String password) {
        saved = true;
        confirmPassword = password;
      }

      await tester.pumpWidget(createWidget(onConfirm));
      await tester.enterText(find.bySemanticsLabel('Password'), passwordToSet);
      await tester.enterText(
          find.bySemanticsLabel('Confirm password'), confirmPasswordToSet);
      await tester.tap(find.widgetWithText(TextButton, "Save Backup..."));
      await tester.pumpAndSettle();

      expect(saved, isFalse);
      expect(confirmPassword, isNull);
      expect(find.text("Passwords do not match"), findsOneWidget);
    });
  });
}

/// Helper function to create the widget to test with
Widget createWidget(Function(String) onConfirm) {
  return MaterialApp(
      home: Scaffold(
    body: BackupPasswordBottomsheet(onConfirm: onConfirm),
  ));
}
