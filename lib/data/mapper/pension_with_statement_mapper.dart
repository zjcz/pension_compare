import 'package:pension_compare/app/home/models/pension_with_statement_model.dart';
import 'package:pension_compare/data/database/tables/pensions_with_statement.dart';
import 'package:pension_compare/data/mapper/pension_mapper.dart';
import 'package:pension_compare/data/mapper/statement_mapper.dart';

class PensionWithStatementMapper {
  static PensionWithStatementModel mapToModel(
      PensionWithStatement pensionWithStatement) {
    return PensionWithStatementModel(
      pension: PensionMapper.mapToModel(pensionWithStatement.pension),
      statement: pensionWithStatement.statement != null
          ? StatementMapper.mapToModel(pensionWithStatement.statement!)
          : null,
    );
  }

  static List<PensionWithStatementModel> mapToModelList(
      List<PensionWithStatement> pensionWithStatements) {
    return pensionWithStatements
        .map((pensionWithStatement) => mapToModel(pensionWithStatement))
        .toList();
  }
}
