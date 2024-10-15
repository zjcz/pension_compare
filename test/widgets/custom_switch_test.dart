import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pension_compare/widgets/custom_switch.dart';

const key = Key('custom_switch_field');
final _formKey = GlobalKey<FormState>();

Widget createSwitch(
    String labelText, Function(bool) onChanged, bool switchValue) {
  CustomSwitch customSwitch = CustomSwitch(
      key: key,
      labelText: labelText,
      onChanged: onChanged,
      switchValue: switchValue);

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return MaterialApp(
        home: Scaffold(
            body: Form(
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: customSwitch)));
  });
}

void main() {
  group('Test building widget', () {
    testWidgets('show the widget with initial true value', (tester) async {
      String label = 'test switch field';
      await tester.pumpWidget(createSwitch(label, (_) {}, true));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel(label), findsOneWidget);
    });

    testWidgets('show the widget with initial false value', (tester) async {
      String label = 'test switch field';
      await tester.pumpWidget(createSwitch(label, (_) {}, false));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel(label), findsOneWidget);
    });

    testWidgets(
        'Given the custom switch widget, When tapping the switch widget the value changed',
        (tester) async {
      String label = 'test switch field';
      bool initialValue = true;
      bool? onSelectionChangedValue;
      bool onSelectionChangedCalled = false;

      onSelectionChanged(bool value) {
        onSelectionChangedValue = value;
        onSelectionChangedCalled = true;
      }

      await tester
          .pumpWidget(createSwitch(label, onSelectionChanged, initialValue));

      // Tap on the switch to change the value
      await tester.tap(find.byKey(Key('${key.toString()}_switch')));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel(label), findsOneWidget);
      expect(onSelectionChangedValue, isFalse);
      expect(onSelectionChangedCalled, isTrue);
    });

    testWidgets(
        'Given the custom switch widget, When tapping the label widget the value changed',
        (tester) async {
      String label = 'test switch field';
      bool initialValue = true;
      bool? onSelectionChangedValue;
      bool onSelectionChangedCalled = false;

      onSelectionChanged(bool value) {
        onSelectionChangedValue = value;
        onSelectionChangedCalled = true;
      }

      await tester
          .pumpWidget(createSwitch(label, onSelectionChanged, initialValue));

      // Tap on the switch to change the value
      await tester.tap(find.byKey(Key('${key.toString()}_label')));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel(label), findsOneWidget);
      expect(onSelectionChangedValue, isFalse);
      expect(onSelectionChangedCalled, isTrue);
    });

    testWidgets(
        'Given the custom switch widget, When tapping the text the value changed',
        (tester) async {
      String label = 'test switch field';
      bool initialValue = true;
      bool? onSelectionChangedValue;
      bool onSelectionChangedCalled = false;

      onSelectionChanged(bool value) {
        onSelectionChangedValue = value;
        onSelectionChangedCalled = true;
      }

      await tester
          .pumpWidget(createSwitch(label, onSelectionChanged, initialValue));

      // Tap on the switch to change the value
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();

      expect(onSelectionChangedValue, isFalse);
      expect(onSelectionChangedCalled, isTrue);
    });

        testWidgets(
        'Given the custom switch widget set to false, When tapping the text the value changed to true',
        (tester) async {
      String label = 'test switch field';
      bool initialValue = false;
      bool? onSelectionChangedValue;
      bool onSelectionChangedCalled = false;

      onSelectionChanged(bool value) {
        onSelectionChangedValue = value;
        onSelectionChangedCalled = true;
      }

      await tester
          .pumpWidget(createSwitch(label, onSelectionChanged, initialValue));

      // Tap on the switch to change the value
      await tester.tap(find.text(label));
      await tester.pumpAndSettle();

      expect(onSelectionChangedValue, isTrue);
      expect(onSelectionChangedCalled, isTrue);
    });
  });
}
