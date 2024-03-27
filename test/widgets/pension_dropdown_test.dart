import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:pension_compare/widgets/pension_dropdown.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'pension_dropdown_test.mocks.dart';

final _formKey = GlobalKey<FormState>();
const String key = 'pension_dropdown';

// TODO - re-write these tests without the database mocks (not required)

Widget createDropdown(DatabaseService db, int? pensionId,
    Function(int?) onChanged, String? Function(int?) onValidate) {
  PensionDropdown dropdown = PensionDropdown(
      key: const Key(key),
      pensionList: db.getAllPensions(),
      pensionId: pensionId,
      onChanged: onChanged,
      onValidate: onValidate);

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return MaterialApp(
        home: Scaffold(
            body: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: dropdown)));
  });
}

@GenerateMocks([DatabaseService])
void main() {
  group('Test building dropdown', () {
    testWidgets('show the widget with no pension record', (tester) async {
      final databaseService = MockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) async => []);

      await tester
          .pumpWidget(createDropdown(databaseService, null, (_) {}, (_) {
        return null;
      }));
      await tester.pumpAndSettle();

      verify(databaseService.getAllPensions()).called(1);
      expect(
          find.text("No pensions found.  Click + to add one"), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<int>), findsNothing);
    });
    testWidgets('show the dropdown with pension record', (tester) async {
      int pensionId = 5;
      String pensionName = 'new pension';

      final databaseService = MockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) async => [
            Pension(
                pensionId: pensionId,
                name: pensionName,
                maturityDate: DateTime.now())
          ]);

      await tester
          .pumpWidget(createDropdown(databaseService, null, (_) {}, (_) {
        return null;
      }));
      await tester.pumpAndSettle();

      verify(databaseService.getAllPensions()).called(1);
      expect(find.text("Pension"), findsOneWidget);
      expect(find.byType(DropdownButtonFormField<int>), findsOneWidget);
    });

    testWidgets('is the pension record selectable', (tester) async {
      int pensionId = 5;
      String pensionName = 'Test';
      int? onSelectionChangedValue;
      bool onSelectionChangedCalled = false;

      onSelectionChanged(int? value) {
        onSelectionChangedValue = value;
        onSelectionChangedCalled = true;
      }

      String? onValidate(int? value) => null;

      final databaseService = MockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) async => [
            Pension(
                pensionId: pensionId,
                name: pensionName,
                maturityDate: DateTime.now())
          ]);

      await tester.pumpWidget(createDropdown(
          databaseService, null, onSelectionChanged, onValidate));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButtonFormField<int>));
      await tester.pumpAndSettle();
      await tester
          .tap(find.widgetWithText(DropdownMenuItem<int>, pensionName).last);
      await tester.pump();

      expect(onSelectionChangedValue, equals(pensionId));
      expect(onSelectionChangedCalled, isTrue);
    });

    testWidgets('no item selected fails validation', (tester) async {
      int pensionId = 5;
      String pensionName = 'Test';
      String validationMessage = "failed validation";
      int? onValidateValue;
      bool onValidateCalled = false;

      onSelectionChanged(int? value) => {};
      String? onValidate(int? value) {
        onValidateValue = value;
        onValidateCalled = true;
        return validationMessage;
      }

      final databaseService = MockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) async => [
            Pension(
                pensionId: pensionId,
                name: pensionName,
                maturityDate: DateTime.now())
          ]);
      await tester.pumpWidget(createDropdown(
          databaseService, null, onSelectionChanged, onValidate));
      await tester.pumpAndSettle();

      bool isValid = _formKey.currentState!.validate();

      expect(onValidateValue, isNull);
      expect(onValidateCalled, isTrue);
      expect(isValid, isFalse);
    });

    testWidgets('item selected passes validation', (tester) async {
      int pensionId = 5;
      String pensionName = 'Test';
      String validationMessage = "failed validation";
      int? onSelectionChangedValue;
      bool onSelectionChangedCalled = false;
      int? onValidateValue;
      bool onValidateCalled = false;

      onSelectionChanged(int? value) {
        onSelectionChangedValue = value;
        onSelectionChangedCalled = true;
      }

      String? onValidate(int? value) {
        onValidateValue = value;
        onValidateCalled = true;
        return value == null ? validationMessage : null;
      }

      final databaseService = MockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) async => [
            Pension(
                pensionId: pensionId,
                name: pensionName,
                maturityDate: DateTime.now())
          ]);
      await tester.pumpWidget(createDropdown(
          databaseService, null, onSelectionChanged, onValidate));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(DropdownButtonFormField<int>));
      await tester.pumpAndSettle();
      await tester
          .tap(find.widgetWithText(DropdownMenuItem<int>, pensionName).last);
      await tester.pump();

      bool isValid = _formKey.currentState!.validate();

      expect(onSelectionChangedValue, equals(pensionId));
      expect(onSelectionChangedCalled, isTrue);

      expect(onValidateValue, equals(pensionId));
      expect(onValidateCalled, isTrue);
      expect(isValid, isTrue);
    });

    testWidgets('specified pension is pre selected', (tester) async {
      int pensionId1 = 1;
      String pensionName1 = 'Test 1';
      int pensionId2 = 2;
      String pensionName2 = 'Test 2';
      int pensionId3 = 3;
      String pensionName3 = 'Test 3';
      int selectedPensionId = 2;

      onSelectionChanged(int? value) {}
      String? onValidate(int? value) => null;

      final databaseService = MockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) async => [
            Pension(
                pensionId: pensionId1,
                name: pensionName1,
                maturityDate: DateTime.now()),
            Pension(
                pensionId: pensionId2,
                name: pensionName2,
                maturityDate: DateTime.now()),
            Pension(
                pensionId: pensionId3,
                name: pensionName3,
                maturityDate: DateTime.now())
          ]);
      await tester.pumpWidget(createDropdown(
          databaseService, selectedPensionId, onSelectionChanged, onValidate));
      await tester.pumpAndSettle();

      expect(find.text(pensionName2), findsOneWidget);
    });
  });
}
