import 'package:drift/drift.dart';
import 'connection/connection.dart' as dbconn;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pension_compare/data/database/tables/pension.dart';
import 'package:pension_compare/data/database/tables/statement.dart';
import 'package:pension_compare/data/database/tables/other_income.dart';
import 'package:pension_compare/data/database/tables/pensions_with_latest_statement.dart';
import 'package:pension_compare/constants/defaults.dart' as defaults;
import 'package:pension_compare/helpers/date_helper.dart';

part 'database_service.g.dart';

@DriftDatabase(
  tables: [Pensions, Statements, OtherIncomes],
)
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
  Stream<List<Pension>> getAllPensions() {
    return select(pensions).watch();
  }

  // Get a single pension by its id
  Future<Pension?> getPension(int id) {
    return (select(pensions)..where((p) => p.pensionId.equals(id)))
        .getSingleOrNull();
  }

  // Watch a single pension by its id
  Stream<Pension?> watchPension(int id) {
    return (select(pensions)..where((p) => p.pensionId.equals(id)))
        .watchSingleOrNull();
  }

  // Create a new pension record
  Future<Pension?> createPension(String name, DateTime maturityDate) {
    return into(pensions).insertReturningOrNull(PensionsCompanion.insert(
        name: name, maturityDate: DateHelper.removeTime(maturityDate)));
  }

  // Update an existing pension record, return true if successful
  Future<bool> updatePension(int id, String name, DateTime maturityDate) {
    return update(pensions).replace(Pension(
        pensionId: id,
        name: name,
        maturityDate: DateHelper.removeTime(maturityDate)));
  }

  // Delete a pension record by its id and return the number of records deleted
  Future<int> deletePension(int id) {
    return (delete(pensions)..where((p) => p.pensionId.equals(id))).go();
  }

  // Checks to see if a pension with this name already exists in the database,
  // but with a different id
  Future<bool> doesPensionNameExist(int? id, String name) async {
    final pension = await (select(pensions)
          ..where((p) =>
              p.pensionId.equals(id ?? 0).not() &
              p.name.collate(Collate.noCase).equals(name))
          ..limit(1))
        .getSingleOrNull();

    return (pension != null);
  }

  // List all the statements in the database for a given pension
  Stream<List<Statement>> getAllStatementsForPension(int pensionId) {
    return (select(statements)..where((s) => s.pension.equals(pensionId)))
        .watch();
  }

  // Get a single statement by its id
  Future<Statement?> getStatement(int id) {
    return (select(statements)..where((s) => s.statementId.equals(id)))
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
        statementDate: DateHelper.removeTime(statementDate),
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
        statementId: id,
        pension: pensionId,
        statementDate: DateHelper.removeTime(statementDate),
        planValue: planValue,
        projectedAnnualAmount: projectedAnnualAmount,
        yearlyCharges: yearlyCharges,
        transferValue: transferValue));
  }

  // Delete a statement record by its id and return the number of records deleted
  Future<int> deleteStatement(int id) {
    return (delete(statements)..where((s) => s.statementId.equals(id))).go();
  }

  // Checks to see if a statement date already exists in the database for this pension,
  // but with a different id
  Future<bool> doesStatementDateExist(
      int? id, int pensionId, DateTime statementDate) async {
    final pension = await (select(statements)
          ..where((s) =>
              s.pension.equals(pensionId) &
              s.statementId.equals(id ?? 0).not() &
              s.statementDate.equals(DateHelper.removeTime(statementDate)))
          ..limit(1))
        .getSingleOrNull();

    return (pension != null);
  }

  // Get the state pension record.
  Future<OtherIncome?> getStatePension() async {
    return (select(otherIncomes)
          ..where(
              (o) => o.otherIncomeId.equals(defaults.defaultStatePensionId)))
        .getSingleOrNull();
  }

  // Save the state pension data.  Update the existing record, or insert a new
  // one if it doesn't exist
  Future<OtherIncome?> saveStatePension(double annualAmount) async {
    OtherIncome statePension = OtherIncome(
      otherIncomeId: defaults.defaultStatePensionId,
      name: defaults.defaultStatePensionName,
      annualAmount: annualAmount,
    );

    // attempt to update the record, if it doesn't exist then insert it
    bool success = await update(otherIncomes).replace(statePension);
    if (!success) {
      return into(otherIncomes).insertReturning(statePension);
    }

    return statePension;
  }

  // List all the pensions in the database
  Stream<List<PensionWithLatestStatement>> getAllPensionsWithLatestStatement() {
    // list all the pensions, joined with the latest statement for each pension.
    // we get this by finding the latest statement date for each pension, and then
    // joining this with the statements table to get the latest statement data
    final query = customSelect(
        'SELECT pensions.*, statements.* '
        'FROM pensions LEFT JOIN '
        '   (statements INNER JOIN (SELECT pension, MAX(statement_date) as latest_statement_date '
        '                           FROM statements GROUP BY pension) AS latest_statements ON statements.pension = latest_statements.pension '
        '                                                                AND statements.statement_date = latest_statements.latest_statement_date)'
        '           ON pensions.pension_id = statements.pension '
        'ORDER BY pensions.name',
        readsFrom: {pensions, statements});

    return query
        .map((row) => PensionWithLatestStatement(
              pensions.map(row.data),
              row.data["statement_id"] == null
                  ? null
                  : statements.map(row.data),
            ))
        .watch();
  }

  // Populate the database with some test data
  Future<void> populateTestData() async {
    await clearAllData();

    // create some test pensions
    Pension? p1 = await createPension("Pension 1", DateTime(2030, 1, 1));
    Pension? p2 = await createPension("Pension 2", DateTime(2030, 1, 1));
    await createPension(
        "Pension 3", DateTime(2030, 1, 1)); // no statements required
    Pension? p4 = await createPension("Pension 4", DateTime(2030, 1, 1));

    // create some test statements
    await createStatement(
        p1!.pensionId, DateTime(2020, 1, 1), 1000, 100, 10, 1000);
    await createStatement(
        p1.pensionId, DateTime(2021, 1, 1), 2000, 200, 20, 2000);
    await createStatement(
        p1.pensionId, DateTime(2022, 1, 1), 3000, 300, 30, 3000);
    await createStatement(
        p1.pensionId, DateTime(2023, 1, 1), 4000, 500, 60, 7000);
    await createStatement(
        p2!.pensionId, DateTime(2020, 1, 1), 2000, 200, 20, 2000);
    await createStatement(
        p2.pensionId, DateTime(2021, 1, 1), 3000, 300, 30, 3000);
    await createStatement(
        p2.pensionId, DateTime(2022, 1, 1), 4000, 400, 40, 4000);
    await createStatement(
        p2.pensionId, DateTime(2023, 1, 1), 5000, 400, 30, 2000);
    await createStatement(
        p4!.pensionId, DateTime(2020, 1, 1), 1500, 150, 15, 1500);
    await createStatement(
        p4.pensionId, DateTime(2021, 1, 1), 2500, 250, 25, 2500);
    await createStatement(
        p4.pensionId, DateTime(2022, 1, 1), 3500, 350, 35, 3500);
    await createStatement(
        p4.pensionId, DateTime(2023, 1, 1), 4500, 450, 45, 4500);

    // create a state pension record
    await saveStatePension(1000);
  }

  // Clear all the data from the database
  Future<void> clearAllData() async {
    await (delete(statements)).go();
    await (delete(pensions)).go();

    // do not delete the state pension record, just reset it to 0
    await saveStatePension(0);
  }

  // Provider for the database service
  // Note: Declared here as Provider.  If the database connection was to change
  // at some point (for example the database connection is reset and
  // reinitialised after a backup / restore) we would need to declare this as a
  // StateProvider instead.
  static final Provider<DatabaseService> provider = Provider((ref) {
    final database = DatabaseService.withDefaultConnection();
    ref.onDispose(database.close);

    return database;
  });
}
