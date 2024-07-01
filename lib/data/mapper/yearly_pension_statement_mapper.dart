import 'package:pension_compare/app/home/models/yearly_pension_statement_model.dart';
import 'package:pension_compare/data/database/tables/yearly_pension_statement.dart';
import 'package:pension_compare/data/mapper/pension_with_statement_mapper.dart';

class YearlyPensionLatestStatementMapper {
  static YearlyPensionStatementModel mapToModel(
      YearlyPensionStatement yearlyPensionStatement) {
    return YearlyPensionStatementModel(
      year: yearlyPensionStatement.year,
      pensionWithStatement: PensionWithStatementMapper.mapToModelList(
          yearlyPensionStatement.pensionWithStatement),
    );
  }

  static List<YearlyPensionStatementModel> mapToModelList(
      List<YearlyPensionStatement> yearlyPensionStatements) {
    return yearlyPensionStatements
        .map((yearlyPensionStatement) => mapToModel(yearlyPensionStatement))
        .toList();
  }
}
