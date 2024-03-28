import 'package:flutter/material.dart';
import 'package:pension_compare/helpers/currency_helper.dart';
import 'package:pension_compare/helpers/date_helper.dart';
import 'package:pension_compare/widgets/statement_data_table.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';

const String key = 'pension_data_table';

Widget createDataTable(
    List<Statement> statementData, Function(Statement) onTap) {
  StatementDataTable dataTable = StatementDataTable(
      key: const Key(key), statementDataList: statementData, onTap: onTap);

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return MaterialApp(
        home: Scaffold(
      body: dataTable,
    ));
  });
}

void main() {
  group('Test building datatable', () {
    testWidgets('show the widget with no statement records', (tester) async {
      await tester.pumpWidget(createDataTable([], (_) {}));
      await tester.pumpAndSettle();

      expect(find.text("No statements found.  Click + to add one"),
          findsOneWidget);
      expect(find.byType(DataTable), findsNothing);
    });

    testWidgets('show the data table with statement record', (tester) async {
      DateTime statementDate = DateTime.now();
      double planValue = 1000;
      double projectedAnnualAmount = 2000;
      double yearlyCharges = 100;
      double transferValue = 500;

      final statementData = [
        Statement(
            statementId: 1,
            pension: 1,
            statementDate: statementDate,
            planValue: planValue,
            projectedAnnualAmount: projectedAnnualAmount,
            yearlyCharges: yearlyCharges,
            transferValue: transferValue)
      ];

      await tester.pumpWidget(createDataTable(statementData, (_) {}));
      await tester.pumpAndSettle();

      expect(find.text(DateHelper.formatDate(statementDate)), findsOneWidget);
      expect(
          find.text(CurrencyHelper.formatCurrency(planValue)), findsOneWidget);
      expect(find.text(CurrencyHelper.formatCurrency(projectedAnnualAmount)),
          findsOneWidget);
      expect(find.text(CurrencyHelper.formatCurrency(yearlyCharges)),
          findsOneWidget);
      expect(find.text(CurrencyHelper.formatCurrency(transferValue)),
          findsOneWidget);
      expect(find.byType(DataTable), findsOneWidget);
    });

    testWidgets('is the statement record tappable', (tester) async {
      int statementId1 = 1;
      int statementId2 = 2;
      int statementId3 = 3;
      DateTime statementDate1 = DateTime(2020, 1, 1);
      DateTime statementDate2 = DateTime(2021, 1, 1);
      DateTime statementDate3 = DateTime(2022, 1, 1);
      double planValue = 1000;
      double projectedAnnualAmount = 2000;
      double yearlyCharges = 100;
      double transferValue = 500;
      Statement? onTapValue;
      bool onTapCalled = false;

      onTap(Statement value) {
        onTapValue = value;
        onTapCalled = true;
      }

      final statementData = [
        Statement(
            statementId: statementId1,
            pension: 1,
            statementDate: statementDate1,
            planValue: planValue,
            projectedAnnualAmount: projectedAnnualAmount,
            yearlyCharges: yearlyCharges,
            transferValue: transferValue),
        Statement(
            statementId: statementId2,
            pension: 1,
            statementDate: statementDate2,
            planValue: planValue,
            projectedAnnualAmount: projectedAnnualAmount,
            yearlyCharges: yearlyCharges,
            transferValue: transferValue),
        Statement(
            statementId: statementId3,
            pension: 1,
            statementDate: statementDate3,
            planValue: planValue,
            projectedAnnualAmount: projectedAnnualAmount,
            yearlyCharges: yearlyCharges,
            transferValue: transferValue)
      ];

      await tester.pumpWidget(createDataTable(statementData, onTap));
      await tester.pumpAndSettle();

      await tester.tap(find.text(DateHelper.formatDate(statementDate2)));
      await tester.pump();

      expect(onTapValue, isNotNull);
      expect(onTapValue!.statementId, equals(statementId2));
      expect(onTapCalled, isTrue);
    });
  });
}
