import 'package:flutter/material.dart';
import 'package:pension_compare/app/home/models/pension_with_latest_statement_model.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/app/statement/models/statement_model.dart';
import 'package:pension_compare/helpers/currency_helper.dart';
import 'package:pension_compare/app/pension/views/widgets/pension_data_table.dart';
import 'package:flutter_test/flutter_test.dart';

const String key = 'pension_data_table';

Widget createDataTable(List<PensionWithLatestStatementModel> pensionData,
    Function(PensionModel) onTap) {
  PensionDataTable dataTable = PensionDataTable(
      key: const Key(key), pensionDataList: pensionData, onTap: onTap);

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return MaterialApp(
        home: Scaffold(
      body: dataTable,
    ));
  });
}

void main() {
  group('Test building datatable', () {
    testWidgets('show the widget with no pension record', (tester) async {
      await tester.pumpWidget(createDataTable([], (_) {}));
      await tester.pumpAndSettle();

      expect(
          find.text("No pensions found.  Click + to add one"), findsOneWidget);
      expect(find.byType(DataTable), findsNothing);
    });

    testWidgets('show the data table with pension record (but no statement)',
        (tester) async {
      String pensionName = 'new pension';

      final pensionData = [
        PensionWithLatestStatementModel(
            pension: PensionModel(
                pensionId: 1, name: pensionName, maturityDate: DateTime.now()),
            latestStatement: null)
      ];

      await tester.pumpWidget(createDataTable(pensionData, (_) {}));
      await tester.pumpAndSettle();

      expect(find.text(pensionName), findsOneWidget);
      expect(find.byType(DataTable), findsOneWidget);
    });

    testWidgets('show the data table with pension and statement record',
        (tester) async {
      String pensionName = 'new pension';
      double planValue = 1000;
      double projectedAnnualAmount = 2000;
      double yearlyCharges = 100;
      double transferValue = 500;

      final pensionData = [
        PensionWithLatestStatementModel(
            pension: PensionModel(
                pensionId: 1, name: pensionName, maturityDate: DateTime.now()),
            latestStatement: StatementModel(
                statementId: 1,
                pension: 1,
                statementDate: DateTime.now(),
                planValue: planValue,
                projectedAnnualAmount: projectedAnnualAmount,
                yearlyCharges: yearlyCharges,
                transferValue: transferValue))
      ];

      await tester.pumpWidget(createDataTable(pensionData, (_) {}));
      await tester.pumpAndSettle();

      expect(find.text(pensionName), findsOneWidget);
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

    testWidgets('is the pension record tappable', (tester) async {
      int pensionId1 = 1;
      int pensionId2 = 2;
      int pensionId3 = 3;
      String pensionName1 = 'new pension one';
      String pensionName2 = 'new pension two';
      String pensionName3 = 'new pension three';
      PensionModel? onTapValue;
      bool onTapCalled = false;

      onTap(PensionModel value) {
        onTapValue = value;
        onTapCalled = true;
      }

      final pensionData = [
        PensionWithLatestStatementModel(
            pension: PensionModel(
                pensionId: pensionId1,
                name: pensionName1,
                maturityDate: DateTime.now()),
            latestStatement: null),
        PensionWithLatestStatementModel(
            pension: PensionModel(
                pensionId: pensionId2,
                name: pensionName2,
                maturityDate: DateTime.now()),
            latestStatement: null),
        PensionWithLatestStatementModel(
            pension: PensionModel(
                pensionId: pensionId3,
                name: pensionName3,
                maturityDate: DateTime.now()),
            latestStatement: null)
      ];

      await tester.pumpWidget(createDataTable(pensionData, onTap));
      await tester.pumpAndSettle();

      await tester.tap(find.text(pensionName2));
      await tester.pump();

      expect(onTapValue, isNotNull);
      expect(onTapValue!.pensionId, equals(pensionId2));
      expect(onTapCalled, isTrue);
    });

    testWidgets('is the pension record tappable multiple times',
        (tester) async {
      int pensionId1 = 1;
      int pensionId2 = 2;
      int pensionId3 = 3;
      String pensionName1 = 'new pension one';
      String pensionName2 = 'new pension two';
      String pensionName3 = 'new pension three';
      PensionModel? onTapValue;
      int onTapCalled = 0;

      onTap(PensionModel value) {
        onTapValue = value;
        onTapCalled++;
      }

      final pensionData = [
        PensionWithLatestStatementModel(
            pension: PensionModel(
                pensionId: pensionId1,
                name: pensionName1,
                maturityDate: DateTime.now()),
            latestStatement: null),
        PensionWithLatestStatementModel(
            pension: PensionModel(
                pensionId: pensionId2,
                name: pensionName2,
                maturityDate: DateTime.now()),
            latestStatement: null),
        PensionWithLatestStatementModel(
            pension: PensionModel(
                pensionId: pensionId3,
                name: pensionName3,
                maturityDate: DateTime.now()),
            latestStatement: null)
      ];

      await tester.pumpWidget(createDataTable(pensionData, onTap));
      await tester.pumpAndSettle();

      await tester.tap(find.text(pensionName2));
      await tester.pump();
      await tester.tap(find.text(pensionName2));
      await tester.pump();
      await tester.tap(find.text(pensionName2));
      await tester.pump();

      expect(onTapValue, isNotNull);
      expect(onTapValue!.pensionId, equals(pensionId2));
      expect(onTapCalled, 3);
    });
  });
}
