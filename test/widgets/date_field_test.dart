import 'package:flutter/material.dart';
import 'package:pension_compare/helpers/date_helper.dart';
import 'package:pension_compare/widgets/date_field.dart';
import 'package:flutter_test/flutter_test.dart';

const key = Key('date_field');
final _formKey = GlobalKey<FormState>();

Widget createDateField(
    DateTime? initialDate,
    String labelText,
    Function(DateTime?) onDateSelected,
    String? Function(DateTime?)? onValidate) {
  DateField field = DateField(
      key: key,
      initialDate: initialDate,
      onDateSelected: onDateSelected,
      onValidate: onValidate,
      labelText: labelText);

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return MaterialApp(
        home: Scaffold(
            body: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: field)));
  });
}

void main() {
  group('Test building dropdown', () {
    testWidgets('show the widget with no initial value', (tester) async {
      String label = 'test date field';
      await tester.pumpWidget(createDateField(null, label, (_) {}, (_) {
        return null;
      }));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel(label), findsOneWidget);
    });

    testWidgets('show the widget with initial value', (tester) async {
      String label = 'test date field';
      DateTime initialDate = DateTime(2024, 2, 15);
      await tester.pumpWidget(createDateField(initialDate, label, (_) {}, (_) {
        return null;
      }));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel(label), findsOneWidget);
      expect(find.text(DateHelper.formatDate(initialDate)), findsOneWidget);
    });

    testWidgets('is the date changed', (tester) async {
      String label = 'test date field';
      DateTime initialDate = DateTime(2024, 2, 15);
      DateTime changedDate = DateTime(2024, 2, 16);
      DateTime? onSelectionChangedValue;
      bool onSelectionChangedCalled = false;

      onSelectionChanged(DateTime? value) {
        onSelectionChangedValue = value;
        onSelectionChangedCalled = true;
      }

      await tester.pumpWidget(
          createDateField(initialDate, label, onSelectionChanged, (_) {
        return null;
      }));

      // Find the TextFormField by key
      final fieldFinder = find.byKey(key);

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
      await tester.tap(find.text(changedDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(onSelectionChangedValue, equals(changedDate));
      expect(onSelectionChangedCalled, isTrue);
      expect(find.text(DateHelper.formatDate(changedDate)), findsOneWidget);
    });

    testWidgets('no date selected fails validation', (tester) async {
      String label = 'test date field';
      String validationMessage = "failed validation";
      DateTime? onValidateValue;
      bool onValidateCalled = false;

      onSelectionChanged(DateTime? value) => {};
      String? onValidate(DateTime? value) {
        onValidateValue = value;
        onValidateCalled = true;
        return validationMessage;
      }

      await tester.pumpWidget(
          createDateField(null, label, onSelectionChanged, onValidate));
      await tester.pumpAndSettle();

      bool isValid = _formKey.currentState!.validate();

      expect(onValidateValue, isNull);
      expect(onValidateCalled, isTrue);
      expect(isValid, isFalse);
    });

    testWidgets('date selected passes validation', (tester) async {
      String label = 'test date field';
      DateTime initialDate = DateTime(2024, 2, 15);
      DateTime changedDate = DateTime(2024, 2, 16);
      DateTime? onSelectionChangedValue;
      bool onSelectionChangedCalled = false;
      String validationMessage = "failed validation";
      DateTime? onValidateValue;
      bool onValidateCalled = false;

      onSelectionChanged(DateTime? value) {
        onSelectionChangedValue = value;
        onSelectionChangedCalled = true;
      }

      String? onValidate(DateTime? value) {
        onValidateValue = value;
        onValidateCalled = true;
        return value == null ? validationMessage : null;
      }

      await tester.pumpWidget(
          createDateField(initialDate, label, onSelectionChanged, onValidate));
      await tester.pumpAndSettle();

      // Find the TextFormField by key
      final fieldFinder = find.byKey(key);

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
      await tester.tap(find.text(changedDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      bool isValid = _formKey.currentState!.validate();

      expect(onSelectionChangedValue, equals(changedDate));
      expect(onSelectionChangedCalled, isTrue);

      expect(onValidateCalled, isTrue);
      expect(onValidateValue, equals(changedDate));
      expect(isValid, isTrue);
    });
  });
}
