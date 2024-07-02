import 'package:pension_compare/app/statement/models/statement_model.dart';
import 'package:pension_compare/data/database/database_service.dart';

class StatementMapper {
  static StatementModel mapToModel(Statement statement) {
    return StatementModel(
      statementId: statement.statementId,
      pension: statement.pension,
      statementDate: statement.statementDate,
      planValue: statement.planValue,
      projectedAnnualAmount: statement.projectedAnnualAmount,
      yearlyCharges: statement.yearlyCharges,
      transferValue: statement.transferValue,
      amountPaidIn: statement.amountPaidIn,
    );
  }

  static List<StatementModel> mapToModelList(List<Statement> statements) {
    return statements.map((statement) => mapToModel(statement)).toList();
  }
}
