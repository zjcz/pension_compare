import 'package:drift/drift.dart';

// Table definition for statePensions table
// Need to run 'dart run build_runner build' after making changes to this file
@DataClassName('StatePension')
class StatePensions extends Table {
  // TODO this needs to be a constant
  IntColumn get id =>
      integer().check(id.equals(1)).withDefault(const Constant(1))();
  RealColumn get projectedAnnualAmount => real()();

  @override
  Set<Column> get primaryKey => {id};
}
