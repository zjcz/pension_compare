import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pension_compare/widgets/dashboard/target_vs_actual.dart';

void main() {
  group('TargetVsActual', () {
    testWidgets(
        'Given target and actual values, '
        'When the widget is built, '
        'Then it should display the correct values',
        (WidgetTester tester) async {
      // Arrange
      const targetValue = 1000.0;
      const actualValue = 800.0;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TargetVsActual(
              targetValue: targetValue,
              actualValue: actualValue,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('\$800'), findsOneWidget);
      expect(find.text('Target: \$1,000'), findsOneWidget);
    });

    testWidgets(
        'Given a positive difference, '
        'When the widget is built, '
        'Then it should display the difference with a "+" sign',
        (WidgetTester tester) async {
      // Arrange
      const targetValue = 1000.0;
      const actualValue = 1200.0;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TargetVsActual(
              targetValue: targetValue,
              actualValue: actualValue,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Difference: +\$200 (120%)'), findsOneWidget);
    });

    testWidgets(
        'Given a negative difference, '
        'When the widget is built, '
        'Then it should display the difference with a "-" sign',
        (WidgetTester tester) async {
      // Arrange
      const targetValue = 1000.0;
      const actualValue = 800.0;

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TargetVsActual(
              targetValue: targetValue,
              actualValue: actualValue,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Difference: -\$200 (80%)'), findsOneWidget);
    });

    testWidgets(
        'Given a retirement date, '
        'When the widget is built, '
        'Then it should display the retirement date',
        (WidgetTester tester) async {
      // Arrange
      const targetValue = 1000.0;
      const actualValue = 800.0;
      final retirementDate = DateTime.now().add(const Duration(days: 365));

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TargetVsActual(
              targetValue: targetValue,
              actualValue: actualValue,
              retirementDate: retirementDate,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Retire in 1 Year'), findsOneWidget);
    });
  });
}
