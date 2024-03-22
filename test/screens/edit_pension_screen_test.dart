import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:pension_compare/screens/edit_pension_screen.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:pension_compare/helpers/date_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'edit_pension_screen_test.mocks.dart';

Widget createEditScreen(Pension? pensionRecord, DatabaseService? db) {
  EditPensionScreen editPensionScreen =
      EditPensionScreen(pension: pensionRecord, databaseService: db);

  return MaterialApp(home: editPensionScreen);
}

@GenerateMocks([DatabaseService])
void main() {
  group('Test adding / editing of pension record', () {
    testWidgets('show the add screen with no pension record', (tester) async {
      await tester.pumpWidget(createEditScreen(null, null));

      expect(find.text("Add Pension"), findsOneWidget);

      // Check that the Name TextFormField exists
      expect(find.bySemanticsLabel('Name'), findsOneWidget);

      expect(
          find.text(
              "This is a unique name you use to identify a pension policy.  It could be the name of the pension provider or the name of the workplace associated with the pension.  The choice is yours."),
          findsOneWidget);

      // Check that the Planned Retirement Date TextFormField exists
      expect(find.bySemanticsLabel('Planned Retirement Date'), findsOneWidget);

      expect(
          find.text(
              "This is the date you have set on this pension to retire.  You can have different dates for different pensions"),
          findsOneWidget);

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byKey(EditPensionScreen.pensionNameKey), findsOneWidget);
      expect(
          find.byKey(EditPensionScreen.pensionMaturityDateKey), findsOneWidget);

      expect(find.byType(TextButton), findsOneWidget);
    });

    testWidgets('show the edit screen with a pension record', (tester) async {
      Pension p = Pension(
          pensionId: 1, name: "Test Pension", maturityDate: DateTime.now());
      await tester.pumpWidget(createEditScreen(p, null));

      expect(find.text("Edit Pension"), findsOneWidget);
      expect(find.text(p.name), findsOneWidget);
      expect(find.text(DateHelper.formatDate(p.maturityDate)), findsOneWidget);
    });

    testWidgets('Set date of date picker', (WidgetTester tester) async {
      // Build your app and trigger a frame
      await tester.pumpWidget(createEditScreen(null, null));

      // Find the TextFormField by key
      final fieldFinder = find.byKey(EditPensionScreen.pensionMaturityDateKey);

      // Check that the TextFormField exists
      expect(fieldFinder, findsOneWidget);

      // Tap on the TextFormField to open the date picker
      await tester.tap(fieldFinder);
      await tester.pumpAndSettle();

      // Find the date picker
      final datePickerFinder = find.byType(DatePickerDialog);

      // Check that the date picker is displayed
      expect(datePickerFinder, findsOneWidget);

      // Set the date to today, and tap OK
      final DateTime newDate = DateHelper.getToday();
      await tester.tap(find.text(newDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Check that the TextFormField's value is updated
      final TextFormField field = tester.widget(fieldFinder);
      expect(field.controller?.text, equals(DateHelper.formatDate(newDate)));
    });
  });

  group('Test database interaction of add/edit pension screen', () {
    testWidgets('save add new pension record', (tester) async {
      String name = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();
      final databaseService = MockDatabaseService();
      when(databaseService.createPension(name, maturityDate)).thenAnswer(
          (_) async =>
              Pension(pensionId: 1, name: name, maturityDate: maturityDate));

      await tester.pumpWidget(createEditScreen(null, databaseService));

      // Enter name into the TextFormField
      await tester.enterText(
          find.byKey(EditPensionScreen.pensionNameKey), name);

      // Set the date of the date picker
      await tester.tap(find.byKey(EditPensionScreen.pensionMaturityDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(maturityDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.byType(TextButton));

      verify(databaseService.createPension(name, maturityDate)).called(1);
      verifyNever(databaseService.updatePension(1, name, maturityDate));
    });

    testWidgets('update existing pension record', (tester) async {
      int id = 3;
      String originalName = "Test Pension";
      DateTime originalMaturityDate = DateTime(2024, 1, 1);
      String newName = "New Pension";
      DateTime newMaturityDate = DateTime(2024, 1, 20);
      final databaseService = MockDatabaseService();
      when(databaseService.updatePension(id, newName, newMaturityDate))
          .thenAnswer((_) async => true);

      await tester.pumpWidget(createEditScreen(
          Pension(
              pensionId: id,
              name: originalName,
              maturityDate: originalMaturityDate),
          databaseService));

      // Enter name into the TextFormField
      await tester.enterText(
          find.byKey(EditPensionScreen.pensionNameKey), newName);

      // Set the date of the date picker
      await tester.tap(find.byKey(EditPensionScreen.pensionMaturityDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(newMaturityDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.byType(TextButton));

      verifyNever(databaseService.createPension(newName, newMaturityDate));
      verify(databaseService.updatePension(id, newName, newMaturityDate))
          .called(1);
    });
  });

  group('Test validation of add/edit pension screen', () {
    testWidgets('validation should prevent empty name and date',
        (tester) async {
      final databaseService = MockDatabaseService();

      await tester.pumpWidget(createEditScreen(null, databaseService));

      // Tap the save button
      await tester.tap(find.byType(TextButton));
      await tester.pumpAndSettle();

      expect(find.text("Please enter some text"), findsOneWidget);
      expect(find.text("Please select a date"), findsOneWidget);

      verifyZeroInteractions(databaseService);
    });
    // test delete
    // test cancel
  });
}
