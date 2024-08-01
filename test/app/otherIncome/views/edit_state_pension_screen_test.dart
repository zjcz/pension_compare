import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:pension_compare/app/otherIncome/views/edit_state_pension_screen.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/constants/defaults.dart' as defaults;
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';
import '../../../mocks/mock_url_launcher.dart';
import 'edit_state_pension_screen_test.mocks.dart';

Widget createEditScreen(DatabaseService db) {
  EditStatePensionScreen editStatePensionScreen =
      const EditStatePensionScreen();

  return ProviderScope(overrides: [
    DatabaseService.provider.overrideWithValue(db),
  ], child: MaterialApp(home: editStatePensionScreen));
}

@GenerateMocks([DatabaseService])
void main() {
  group('Test editing of state pension record', () {
    testWidgets('show the screen', (tester) async {
      double value = 12345.67;
      final databaseService = MockDatabaseService();
      when(databaseService.getStatePension()).thenAnswer((_) async =>
          OtherIncome(
              otherIncomeId: defaults.defaultStatePensionId,
              name: defaults.defaultStatePensionName,
              annualAmount: value));

      await tester.pumpWidget(createEditScreen(databaseService));
      await tester.pumpAndSettle();

      expect(find.text("State Pension"), findsOneWidget);

      expect(find.bySemanticsLabel('Yearly Value'), findsOneWidget);
      expect(find.byKey(EditStatePensionScreen.yearlyValueKey), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);

      expect(
          find.text(
              "This is the yearly value you will receive from your state pension.  If you don't know this you can find the amount here:"),
          findsOneWidget);

      expect(find.text("gov.uk/check-state-pension"), findsOneWidget);

      expect(find.byType(TextButton), findsOneWidget);
    });
  });

  group('Test database interaction of edit state pension screen', () {
    testWidgets('load state pension record', (tester) async {
      double value = 12345.67;
      final databaseService = MockDatabaseService();
      when(databaseService.getStatePension()).thenAnswer((_) async =>
          OtherIncome(
              otherIncomeId: defaults.defaultStatePensionId,
              name: defaults.defaultStatePensionName,
              annualAmount: value));

      await tester.pumpWidget(createEditScreen(databaseService));
      await tester.pumpAndSettle();

      expect(find.text("12,345.67"), findsOneWidget);

      verify(databaseService.getStatePension()).called(1);
      verifyNever(databaseService.saveStatePension(value, null));
    });

    testWidgets('load state pension record and format correctly',
        (tester) async {
      double value = 12345.6;
      final databaseService = MockDatabaseService();
      when(databaseService.getStatePension()).thenAnswer((_) async =>
          OtherIncome(
              otherIncomeId: defaults.defaultStatePensionId,
              name: defaults.defaultStatePensionName,
              annualAmount: value));

      await tester.pumpWidget(createEditScreen(databaseService));
      await tester.pumpAndSettle();

      expect(find.text("12,345.60"), findsOneWidget);
    });

    testWidgets('save state pension record', (tester) async {
      double initialValue = 123.45;
      double updatedValue = 12345.67;
      final databaseService = MockDatabaseService();
      when(databaseService.getStatePension()).thenAnswer((_) async =>
          OtherIncome(
              otherIncomeId: defaults.defaultStatePensionId,
              name: defaults.defaultStatePensionName,
              annualAmount: initialValue));
      when(databaseService.saveStatePension(updatedValue, null)).thenAnswer(
          (_) async => OtherIncome(
              otherIncomeId: defaults.defaultStatePensionId,
              name: defaults.defaultStatePensionName,
              annualAmount: updatedValue));

      await tester.pumpWidget(createEditScreen(databaseService));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(EditStatePensionScreen.yearlyValueKey),
          updatedValue.toString());

      // Tap the save button
      await tester.tap(find.byType(TextButton));

      verify(databaseService.saveStatePension(updatedValue, null)).called(1);
    });

    testWidgets('do not save state pension record with invalid values',
        (tester) async {
      double initialValue = 123.45;
      String invalidValue = 'invalid';
      final databaseService = MockDatabaseService();
      when(databaseService.getStatePension()).thenAnswer((_) async =>
          OtherIncome(
              otherIncomeId: defaults.defaultStatePensionId,
              name: defaults.defaultStatePensionName,
              annualAmount: initialValue));
      when(databaseService.saveStatePension(0, null)).thenAnswer((_) async =>
          const OtherIncome(
              otherIncomeId: defaults.defaultStatePensionId,
              name: defaults.defaultStatePensionName,
              annualAmount: 0));

      await tester.pumpWidget(createEditScreen(databaseService));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(EditStatePensionScreen.yearlyValueKey), invalidValue);

      // Tap the save button
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.text(invalidValue), findsOneWidget);
      expect(
          find.text("Please enter a value, or 0 if unknown"), findsOneWidget);

      verifyNever(databaseService.saveStatePension(0, null));
    });

    testWidgets('do not save state pension record with negative values',
        (tester) async {
      double initialValue = 123.45;
      double negativeValue = -42;
      final databaseService = MockDatabaseService();
      when(databaseService.getStatePension()).thenAnswer((_) async =>
          OtherIncome(
              otherIncomeId: defaults.defaultStatePensionId,
              name: defaults.defaultStatePensionName,
              annualAmount: initialValue));
      when(databaseService.saveStatePension(0, null)).thenAnswer((_) async =>
          const OtherIncome(
              otherIncomeId: defaults.defaultStatePensionId,
              name: defaults.defaultStatePensionName,
              annualAmount: 0));

      await tester.pumpWidget(createEditScreen(databaseService));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(EditStatePensionScreen.yearlyValueKey), negativeValue.toString());

      // Tap the save button
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.text(negativeValue.toString()), findsOneWidget);
      expect(
          find.text("Please enter a value, or 0 if unknown"), findsOneWidget);

      verifyNever(databaseService.saveStatePension(0, null));
    });
  });

  group('Test url launcher to state pension site', () {
    testWidgets('test url launcher is successful', (tester) async {
      final MockUrlLauncher mock = MockUrlLauncher();
      mock.setLaunchUrlExpectation(true);
      UrlLauncherPlatform.instance = mock;

      final databaseService = MockDatabaseService();
      when(databaseService.getStatePension()).thenAnswer((_) async =>
          const OtherIncome(
              otherIncomeId: defaults.defaultStatePensionId,
              name: defaults.defaultStatePensionName,
              annualAmount: 1));

      await tester.pumpWidget(createEditScreen(databaseService));
      await tester.pumpAndSettle();

      expect(find.text("gov.uk/check-state-pension"), findsOneWidget);
      await tester.tap(
          find.widgetWithText(ElevatedButton, "gov.uk/check-state-pension"));

      expect(mock.launchUrlCalledCount(), 1);
    });

    testWidgets('test url launcher fails', (tester) async {
      final MockUrlLauncher mock = MockUrlLauncher();
      mock.setLaunchUrlExpectation(false);
      UrlLauncherPlatform.instance = mock;

      final databaseService = MockDatabaseService();
      when(databaseService.getStatePension()).thenAnswer((_) async =>
          const OtherIncome(
              otherIncomeId: defaults.defaultStatePensionId,
              name: defaults.defaultStatePensionName,
              annualAmount: 1));

      await tester.pumpWidget(createEditScreen(databaseService));
      await tester.pumpAndSettle();

      expect(find.text("gov.uk/check-state-pension"), findsOneWidget);
      await tester.tap(
          find.widgetWithText(ElevatedButton, "gov.uk/check-state-pension"));
      await tester.pumpAndSettle();

      expect(mock.launchUrlCalledCount(), 1);
      expect(find.text("Unable to launch website"), findsOneWidget);
    });
  });
}
