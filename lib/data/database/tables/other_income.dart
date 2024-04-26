import 'package:drift/drift.dart';

// Table definition for otherIncomes table
// Need to run 'dart run build_runner build' after making changes to this file
@DataClassName('OtherIncome')
class OtherIncomes extends Table {
  IntColumn get otherIncomeId => integer()();
  TextColumn get name => text()();
  RealColumn get annualAmount => real()();

  @override
  Set<Column> get primaryKey => {otherIncomeId};
}
