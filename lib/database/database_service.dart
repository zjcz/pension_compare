import 'package:drift/drift.dart';
import 'connection/connection.dart' as dbconn;

import 'package:pension_compare/database/tables/pension.dart';
import 'package:pension_compare/database/tables/statement.dart';
import 'package:pension_compare/database/tables/state_pension.dart';

part 'database_service.g.dart';

@DriftDatabase(tables: [Pensions, Statements, StatePensions])
class DatabaseService extends _$DatabaseService {
  DatabaseService(super.connection);

  // Create a new database service with the default connection
  factory DatabaseService.withDefaultConnection() {
    return DatabaseService(dbconn.Connection.getDatabaseConnection());
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      beforeOpen: (details) async {
        // Make sure that foreign keys are enabled
        await customStatement('PRAGMA foreign_keys = ON');

        if (details.wasCreated) {
          // Create default records here
          // we create a default state pension record with a value of 0
          await saveStatePension(0);
        }
      },
    );
  }

  // List all the pensions in the database
  Future<List<Pension>> getAllPensions() {
    return select(pensions).get();
  }

  // Get a single pension by its id
  Future<Pension?> getPension(int id) {
    return (select(pensions)..where((p) => p.id.equals(id))).getSingleOrNull();
  }

  // Create a new pension record
  Future<Pension?> createPension(String name, DateTime maturityDate) {
    return into(pensions).insertReturningOrNull(
        PensionsCompanion.insert(name: name, maturityDate: maturityDate));
  }

  // Update an existing pension record, return true if successful
  Future<bool> updatePension(int id, String name, DateTime maturityDate) {
    return update(pensions)
        .replace(Pension(id: id, name: name, maturityDate: maturityDate));
  }

  // Delete a pension record by its id and return the number of records deleted
  Future<int> deletePension(int id) {
    return (delete(pensions)..where((p) => p.id.equals(id))).go();
  }

  // List all the statements in the database for a given pension
  Future<List<Statement>> getAllStatementsForPension(int pensionId) {
    return (select(statements)..where((s) => s.pension.equals(pensionId)))
        .get();
  }

  // Get a single statement by its id
  Future<Statement?> getStatement(int id) {
    return (select(statements)..where((s) => s.id.equals(id)))
        .getSingleOrNull();
  }

  // Create a new statement record
  Future<Statement?> createStatement(
      int pensionId,
      DateTime statementDate,
      double planValue,
      double projectedAnnualAmount,
      double? yearlyCharges,
      double? transferValue) {
    return into(statements).insertReturningOrNull(StatementsCompanion.insert(
        pension: pensionId,
        statementDate: statementDate,
        planValue: planValue,
        projectedAnnualAmount: projectedAnnualAmount,
        yearlyCharges: Value(yearlyCharges),
        transferValue: Value(transferValue)));
  }

  // Update an existing statement record, return true if successful
  Future<bool> updateStatement(
      int id,
      int pensionId,
      DateTime statementDate,
      double planValue,
      double projectedAnnualAmount,
      double? yearlyCharges,
      double? transferValue) {
    return update(statements).replace(Statement(
        id: id,
        pension: pensionId,
        statementDate: statementDate,
        planValue: planValue,
        projectedAnnualAmount: projectedAnnualAmount,
        yearlyCharges: yearlyCharges,
        transferValue: transferValue));
  }

  // Delete a statement record by its id and return the number of records deleted
  Future<int> deleteStatement(int id) {
    return (delete(statements)..where((s) => s.id.equals(id))).go();
  }

  // Get the state pension record.  There should only be one record in the table
  Future<StatePension?> getStatePension() async {
    return select(statePensions).getSingleOrNull();
  }

  // Save the state pension data.  Update the existing record, or insert a new
  // one if it doesn't exist
  // there should only be one record in the table
  Future<StatePension?> saveStatePension(double projectedAnnualAmount) async {
    StatePension statePension = StatePension(
      id: 1,
      projectedAnnualAmount: projectedAnnualAmount,
    );

    // attempt to update the state pension record, if it doesn't exist then insert it
    bool success = await update(statePensions).replace(statePension);
    if (!success) {
      return into(statePensions).insertReturning(statePension);
    }

    return statePension;
  }
}
