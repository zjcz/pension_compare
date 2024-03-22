import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:pension_compare/screens/edit_state_pension_screen.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/constants/defaults.dart' as defaults;

import 'edit_state_pension_screen_test.mocks.dart';

Widget createEditScreen(DatabaseService? db) {
  EditStatePensionScreen editStatePensionScreen =
      EditStatePensionScreen(databaseService: db);

  return MaterialApp(home: editStatePensionScreen);
}

@GenerateMocks([DatabaseService])
void main() {
  group('Test editing of state pension record', () {
    testWidgets('show the screen', (tester) async {
      await tester.pumpWidget(createEditScreen(null));

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
          StatePension(
              statePensionId: defaults.defaultStatePensionId,
              projectedAnnualAmount: value));

      await tester.pumpWidget(createEditScreen(databaseService));

      expect(find.text("12,345.67"), findsOneWidget);

      verify(databaseService.getStatePension()).called(1);
      verifyNever(databaseService.saveStatePension(value));
    });

    testWidgets('load state pension record and format correctly',
        (tester) async {
      double value = 12345.6;
      final databaseService = MockDatabaseService();
      when(databaseService.getStatePension()).thenAnswer((_) async =>
          StatePension(
              statePensionId: defaults.defaultStatePensionId,
              projectedAnnualAmount: value));

      await tester.pumpWidget(createEditScreen(databaseService));

      expect(find.text("12,345.60"), findsOneWidget);
    });

    testWidgets('save state pension record', (tester) async {
      double initialValue = 123.45;
      double updatedValue = 12345.67;
      final databaseService = MockDatabaseService();
      when(databaseService.getStatePension()).thenAnswer((_) async =>
          StatePension(
              statePensionId: defaults.defaultStatePensionId,
              projectedAnnualAmount: initialValue));
      when(databaseService.saveStatePension(updatedValue)).thenAnswer(
          (_) async => StatePension(
              statePensionId: 1, projectedAnnualAmount: updatedValue));

      await tester.pumpWidget(createEditScreen(databaseService));

      await tester.enterText(find.byKey(EditStatePensionScreen.yearlyValueKey),
          updatedValue.toString());

      // Tap the save button
      await tester.tap(find.byType(TextButton));

      verify(databaseService.saveStatePension(updatedValue)).called(1);
    });
  });
}
