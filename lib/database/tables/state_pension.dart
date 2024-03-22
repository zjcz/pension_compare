import 'package:drift/drift.dart';
import 'package:pension_compare/constants/defaults.dart' as defaults;

// Table definition for statePensions table
// Need to run 'dart run build_runner build' after making changes to this file
@DataClassName('StatePension')
class StatePensions extends Table {
  IntColumn get statePensionId => integer()
      .check(statePensionId.equals(defaults.defaultStatePensionId))
      .withDefault(const Constant(defaults.defaultStatePensionId))();
  RealColumn get projectedAnnualAmount => real()();

  @override
  Set<Column> get primaryKey => {statePensionId};
}
