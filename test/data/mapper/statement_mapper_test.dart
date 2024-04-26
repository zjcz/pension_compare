import 'package:pension_compare/app/statement/models/statement_model.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/data/mapper/statement_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test statement mapper', () {
    testWidgets('map single object', (tester) async {
      int statementId = 5;
      int pensionId = 9;
      DateTime statementDate = DateTime.now();
      double planValue = 123.45;
      double projectedAnnualAmount = 678.90;
      double yearlyCharges = 987.65;
      double transferValue = 432.10;
      Statement statement = Statement(
          statementId: statementId,
          pension: pensionId,
          statementDate: statementDate,
          planValue: planValue,
          projectedAnnualAmount: projectedAnnualAmount,
          yearlyCharges: yearlyCharges,
          transferValue: transferValue);

      StatementModel statementModel = StatementMapper.mapToModel(statement);

      expect(statementModel, isNotNull);
      expect(statementModel.statementId, statementId);
      expect(statementModel.pension, pensionId);
      expect(statementModel.statementDate, statementDate);
      expect(statementModel.planValue, planValue);
      expect(statementModel.projectedAnnualAmount, projectedAnnualAmount);
      expect(statementModel.yearlyCharges, yearlyCharges);
      expect(statementModel.transferValue, transferValue);
    });

    testWidgets('map single object preserves nulls', (tester) async {
      int statementId = 5;
      int pensionId = 9;
      DateTime statementDate = DateTime.now();
      double planValue = 123.45;
      double projectedAnnualAmount = 678.90;
      double? yearlyCharges;
      double? transferValue;

      Statement statement = Statement(
          statementId: statementId,
          pension: pensionId,
          statementDate: statementDate,
          planValue: planValue,
          projectedAnnualAmount: projectedAnnualAmount,
          yearlyCharges: yearlyCharges,
          transferValue: transferValue);

      StatementModel statementModel = StatementMapper.mapToModel(statement);

      expect(statementModel, isNotNull);
      expect(statementModel.statementId, statementId);
      expect(statementModel.pension, pensionId);
      expect(statementModel.statementDate, statementDate);
      expect(statementModel.planValue, planValue);
      expect(statementModel.projectedAnnualAmount, projectedAnnualAmount);
      expect(statementModel.yearlyCharges, isNull);
      expect(statementModel.transferValue, isNull);
    });

    testWidgets('map list object object', (tester) async {
      int statementId = 5;
      int pensionId = 9;
      DateTime statementDate = DateTime.now();
      double planValue = 123.45;
      double projectedAnnualAmount = 678.90;
      double yearlyCharges = 987.65;
      double transferValue = 432.10;
      Statement statement = Statement(
          statementId: statementId,
          pension: pensionId,
          statementDate: statementDate,
          planValue: planValue,
          projectedAnnualAmount: projectedAnnualAmount,
          yearlyCharges: yearlyCharges,
          transferValue: transferValue);

      List<StatementModel> statementModel = StatementMapper.mapToModelList([statement]);

      expect(statementModel, isNotNull);
      expect(statementModel.length, 1);
      expect(statementModel[0].statementId, statementId);
      expect(statementModel[0].pension, pensionId);
      expect(statementModel[0].statementDate, statementDate);
      expect(statementModel[0].planValue, planValue);
      expect(statementModel[0].projectedAnnualAmount, projectedAnnualAmount);
      expect(statementModel[0].yearlyCharges, yearlyCharges);
      expect(statementModel[0].transferValue, transferValue);
    });
  });
}
