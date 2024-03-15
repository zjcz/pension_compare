import 'package:drift/drift.dart';

// Table definition for pensions table
// Need to run 'dart run build_runner build' after making changes to this file
@DataClassName('Pension')
class Pensions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(max: 100)();
  DateTimeColumn get maturityDate => dateTime()();
}
