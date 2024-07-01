import 'package:pension_compare/data/database/tables/pensions_with_statement.dart';

class YearlyPensionStatement {
  final int year;
  final List<PensionWithStatement> pensionWithStatement;

  YearlyPensionStatement(this.year, this.pensionWithStatement);
}
