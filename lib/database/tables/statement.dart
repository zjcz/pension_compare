import 'package:drift/drift.dart';
import 'package:pension_compare/database/tables/pension.dart';

// Table definition for statements table
// Need to run 'dart run build_runner build' after making changes to this file
@DataClassName('Statement')
@TableIndex(name: 'parent_pension', columns: {#pension})
class Statements extends Table {
  IntColumn get statementId => integer().autoIncrement()();
  IntColumn get pension =>
      integer().references(Pensions, #pensionId, onDelete: KeyAction.cascade)();
  DateTimeColumn get statementDate => dateTime()();
  RealColumn get planValue => real()();
  RealColumn get projectedAnnualAmount => real()();
  RealColumn get yearlyCharges => real().nullable()();
  RealColumn get transferValue => real().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
        {pension, statementDate}
      ];
}
