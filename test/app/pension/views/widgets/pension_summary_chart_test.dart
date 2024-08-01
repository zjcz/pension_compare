import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pension_compare/app/home/models/pension_with_statement_model.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/app/pension/views/widgets/pension_summary_chart.dart';
import 'package:pension_compare/app/statement/models/statement_model.dart';
import 'package:pension_compare/constants/chart_color_constants.dart';
import 'package:pension_compare/constants/pension_status.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pension_compare/service_locator.dart';

const String key = 'pension_data_table';
Widget createChartWidget(List<PensionWithStatementModel> pensionData,
    PensionSummaryChartStyles selectedStyle, bool hideTitle) {
  getIt.registerSingleton<ChartColorConstants>(ChartColorConstants());

  PensionSummaryChart summaryChart = PensionSummaryChart(
      key: const Key(key),
      pensionData: pensionData,
      selectedStyle: selectedStyle,
      hideTitle: hideTitle);

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return MaterialApp(
        home: Scaffold(
      body: SingleChildScrollView(child: summaryChart),
    ));
  });
}

void main() {
  setUp(() async {
    // reset before each test to prevent errors with duplicate objects
    await getIt.reset();
  });
  group('Test building chart', () {
    testWidgets('show the widget with no pension record', (tester) async {
      await tester.pumpWidget(
          createChartWidget([], PensionSummaryChartStyles.planValue, false));
      await tester.pumpAndSettle();

      expect(find.text("No pension data found"), findsOneWidget);
      expect(find.byType(BarChart), findsNothing);
    });

    testWidgets('show the widget with no statement record', (tester) async {
      final pensionData = [
        PensionWithStatementModel(
            pension: PensionModel(
                pensionId: 1,
                name: 'pension one',
                maturityDate: DateTime.now(),
                status: PensionStatus.active,
                statusDate: DateTime.now()),
            statement: null)
      ];
      await tester.pumpWidget(createChartWidget(
          pensionData, PensionSummaryChartStyles.planValue, false));
      await tester.pumpAndSettle();

      expect(find.text("No statement data found"), findsOneWidget);
      expect(find.byType(BarChart), findsNothing);
    });

    testWidgets('show the widget with pension and statement record',
        (tester) async {
      String pensionName = 'new pension';

      final pensionData = [
        PensionWithStatementModel(
            pension: PensionModel(
                pensionId: 1,
                name: pensionName,
                maturityDate: DateTime.now(),
                status: PensionStatus.active,
                statusDate: DateTime.now()),
            statement: StatementModel(
              pension: 1,
              statementId: 1,
              statementDate: DateTime.now(),
              planValue: 1000,
              projectedAnnualAmount: 2000,
              yearlyCharges: 100,
              transferValue: 500,
              amountPaidIn: 500,
            ))
      ];

      await tester.pumpWidget(createChartWidget(
          pensionData, PensionSummaryChartStyles.planValue, false));
      await tester.pumpAndSettle();

      expect(find.text(pensionName), findsWidgets);
      expect(find.byType(BarChart), findsOneWidget);
    });
  });
}
