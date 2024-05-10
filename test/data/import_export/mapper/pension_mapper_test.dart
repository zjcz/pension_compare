import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/data/import_export/models/transfer_pension_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_statement_model.dart';
import 'package:pension_compare/data/import_export/mapper/pension_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test pension transfer mapper', () {
    testWidgets('map pension to transfer object', (tester) async {
      int pensionId = 5;
      String pensionName = 'new pension';
      DateTime maturityDate = DateTime.now();
      int statementId = 5;
      DateTime statementDate = DateTime.now();
      double planValue = 123.45;
      double projectedAnnualAmount = 678.90;
      double yearlyCharges = 987.65;
      double transferValue = 432.10;
      Pension pension = Pension(
          pensionId: pensionId, name: pensionName, maturityDate: maturityDate);
      Statement statement = Statement(
          statementId: statementId,
          pension: pensionId,
          statementDate: statementDate,
          planValue: planValue,
          projectedAnnualAmount: projectedAnnualAmount,
          yearlyCharges: yearlyCharges,
          transferValue: transferValue);

      TransferPensionModel pensionModel =
          PensionMapper.toTransfer(pension, [statement]);

      expect(pensionModel, isNotNull);
      expect(pensionModel.pensionId, pensionId);
      expect(pensionModel.name, pensionName);
      expect(pensionModel.maturityDate, maturityDate);
      expect(pensionModel.statements, isNotNull);
      expect(pensionModel.statements.length, 1);
      expect(pensionModel.statements[0].statementId, statementId);
      expect(pensionModel.statements[0].statementDate, statementDate);
      expect(pensionModel.statements[0].planValue, planValue);
      expect(pensionModel.statements[0].projectedAnnualAmount,
          projectedAnnualAmount);
      expect(pensionModel.statements[0].yearlyCharges, yearlyCharges);
      expect(pensionModel.statements[0].transferValue, transferValue);
    });

    testWidgets('map transfer object to pension object', (tester) async {
      int pensionId = 5;
      String pensionName = 'new pension';
      DateTime maturityDate = DateTime.now();
      int statementId = 5;
      DateTime statementDate = DateTime.now();
      double planValue = 123.45;
      double projectedAnnualAmount = 678.90;
      double yearlyCharges = 987.65;
      double transferValue = 432.10;
      TransferStatementModel transferStatement = TransferStatementModel(
          statementId: statementId,
          statementDate: statementDate,
          planValue: planValue,
          projectedAnnualAmount: projectedAnnualAmount,
          yearlyCharges: yearlyCharges,
          transferValue: transferValue);
      TransferPensionModel transferPension = TransferPensionModel(
          pensionId: pensionId,
          name: pensionName,
          maturityDate: maturityDate,
          statements: [transferStatement]);

      Pension pension = PensionMapper.pensionFromTransfer(transferPension);

      expect(pension, isNotNull);
      expect(pension.pensionId, pensionId);
      expect(pension.name, pensionName);
      expect(pension.maturityDate, maturityDate);
    });

    testWidgets('map transfer object to statement object', (tester) async {
      int pensionId = 5;
      String pensionName = 'new pension';
      DateTime maturityDate = DateTime.now();
      int statementId = 5;
      DateTime statementDate = DateTime.now();
      double planValue = 123.45;
      double projectedAnnualAmount = 678.90;
      double yearlyCharges = 987.65;
      double transferValue = 432.10;
      TransferStatementModel transferStatement = TransferStatementModel(
          statementId: statementId,
          statementDate: statementDate,
          planValue: planValue,
          projectedAnnualAmount: projectedAnnualAmount,
          yearlyCharges: yearlyCharges,
          transferValue: transferValue);
      TransferPensionModel transferPension = TransferPensionModel(
          pensionId: pensionId,
          name: pensionName,
          maturityDate: maturityDate,
          statements: [transferStatement]);

      List<Statement> statements =
          PensionMapper.statementFromTransfer(transferPension);

      expect(statements, isNotNull);
      expect(statements.length, 1);
      expect(statements[0].statementId, statementId);
      expect(statements[0].statementDate, statementDate);
      expect(statements[0].planValue, planValue);
      expect(statements[0].projectedAnnualAmount, projectedAnnualAmount);
      expect(statements[0].yearlyCharges, yearlyCharges);
      expect(statements[0].transferValue, transferValue);
    });

    testWidgets('map to transfer and back again', (tester) async {
      int pensionId = 5;
      String pensionName = 'new pension';
      DateTime maturityDate = DateTime.now();
      int statementId = 5;
      DateTime statementDate = DateTime.now();
      double planValue = 123.45;
      double projectedAnnualAmount = 678.90;
      double yearlyCharges = 987.65;
      double transferValue = 432.10;
      Pension pension = Pension(
          pensionId: pensionId, name: pensionName, maturityDate: maturityDate);
      Statement statement = Statement(
          statementId: statementId,
          pension: pensionId,
          statementDate: statementDate,
          planValue: planValue,
          projectedAnnualAmount: projectedAnnualAmount,
          yearlyCharges: yearlyCharges,
          transferValue: transferValue);

      TransferPensionModel pensionModel =
          PensionMapper.toTransfer(pension, [statement]);
      Pension resultPension = PensionMapper.pensionFromTransfer(pensionModel);
      List<Statement> resultStatements =
          PensionMapper.statementFromTransfer(pensionModel);

      expect(resultPension, isNotNull);
      expect(resultPension.pensionId, pension.pensionId);
      expect(resultPension.name, pension.name);
      expect(resultPension.maturityDate, pension.maturityDate);
      expect(resultStatements, isNotNull);
      expect(resultStatements.length, 1);
      expect(resultStatements[0].statementId, statement.statementId);
      expect(resultStatements[0].statementDate, statement.statementDate);
      expect(resultStatements[0].planValue, statement.planValue);
      expect(resultStatements[0].projectedAnnualAmount,
          statement.projectedAnnualAmount);
      expect(resultStatements[0].yearlyCharges, statement.yearlyCharges);
      expect(resultStatements[0].transferValue, statement.transferValue);
    });
  });
}
