import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/data/import_export/models/transfer_pension_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_statement_model.dart';

class PensionMapper {
  static TransferPensionModel toTransfer(
      Pension pension, List<Statement> statements) {
    return TransferPensionModel(
      pensionId: pension.pensionId,
      name: pension.name,
      maturityDate: pension.maturityDate,
      statements: statements
          .map((statement) => TransferStatementModel(
                statementId: statement.statementId,
                statementDate: statement.statementDate,
                planValue: statement.planValue,
                projectedAnnualAmount: statement.projectedAnnualAmount,
                yearlyCharges: statement.yearlyCharges,
                transferValue: statement.transferValue,
              ))
          .toList(),
    );
  }

  static Pension pensionFromTransfer(TransferPensionModel pension) {
    return Pension(
        pensionId: pension.pensionId,
        name: pension.name,
        maturityDate: pension.maturityDate);
  }

  static List<Statement> statementFromTransfer(TransferPensionModel pension) {
    return pension.statements
        .map((statement) => Statement(
            pension: pension.pensionId,
            statementId: statement.statementId,
            statementDate: statement.statementDate,
            planValue: statement.planValue,
            projectedAnnualAmount: statement.projectedAnnualAmount,
            yearlyCharges: statement.yearlyCharges,
            transferValue: statement.transferValue))
        .toList();
  }
}
