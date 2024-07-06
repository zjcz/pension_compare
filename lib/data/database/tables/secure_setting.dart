import 'package:drift/drift.dart';

// Table definition for secureSettings table
// Need to run 'dart run build_runner build' after making changes to this file
@DataClassName('SecureSettings')
class SecureSetting extends Table {
  IntColumn get secureSettingsId => integer().autoIncrement()();
  RealColumn get targetIncome => real().nullable()();
  DateTimeColumn get retirementDate => dateTime().nullable()();
}
