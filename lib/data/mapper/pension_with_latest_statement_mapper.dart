import 'package:pension_compare/app/home/models/pension_with_latest_statement_model.dart';
import 'package:pension_compare/data/database/tables/pensions_with_latest_statement.dart';
import 'package:pension_compare/data/mapper/pension_mapper.dart';
import 'package:pension_compare/data/mapper/statement_mapper.dart';

class PensionWithLatestStatementMapper {
  static PensionWithLatestStatementModel mapToModel(
      PensionWithLatestStatement pensionWithLatestStatement) {
    return PensionWithLatestStatementModel(
      pension: PensionMapper.mapToModel(pensionWithLatestStatement.pension),
      latestStatement: pensionWithLatestStatement.latestStatement != null
          ? StatementMapper.mapToModel(
              pensionWithLatestStatement.latestStatement!)
          : null,
    );
  }

  static List<PensionWithLatestStatementModel> mapToModelList(
      List<PensionWithLatestStatement> pensionWithLatestStatements) {
    return pensionWithLatestStatements
        .map((pensionWithLatestStatement) =>
            mapToModel(pensionWithLatestStatement))
        .toList();
  }
}
