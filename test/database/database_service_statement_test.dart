import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:test/test.dart';
import 'package:matcher/matcher.dart' as match;

void main() {
  late DatabaseService database;

  setUp(() {
    final inMemory = DatabaseConnection(NativeDatabase.memory());
    database = DatabaseService(inMemory);
  });

  tearDown(() => database.close());

  group('Test CRUD of statement objects', () {
    test('create a new statement object', () async {
      DateTime statementDate = DateTime(2024, 2, 3);
      double planValue = 123.45;
      double projectedAnnualAmount = 456.78;
      double? yearlyCharges = 78.90;
      double? transferValue = 90.12;

      final pension =
          await database.createPension('pension', DateTime(2050, 1, 1));

      final entry = await database.createStatement(pension!.id, statementDate,
          planValue, projectedAnnualAmount, yearlyCharges, transferValue);

      expect(entry, match.isNotNull);
      expect(entry!.pension, pension.id);
      expect(entry.statementDate, statementDate);
      expect(entry.planValue, planValue);
      expect(entry.projectedAnnualAmount, projectedAnnualAmount);
      expect(entry.yearlyCharges, yearlyCharges);
      expect(entry.transferValue, transferValue);
    });

    test('create a new statement object fails if parent does not exist',
        () async {
      int pensionId = 1;
      DateTime statementDate = DateTime(2024, 2, 3);
      double planValue = 123.45;
      double projectedAnnualAmount = 456.78;
      double? yearlyCharges = 78.90;
      double? transferValue = 90.12;

      final entry = database.createStatement(pensionId, statementDate,
          planValue, projectedAnnualAmount, yearlyCharges, transferValue);

      expectLater(entry, throwsA(isException));
    });

    test('read a new statement object', () async {
      DateTime statementDate = DateTime(2024, 2, 3);
      double planValue = 123.45;
      double projectedAnnualAmount = 456.78;
      double? yearlyCharges = 78.90;
      double? transferValue = 90.12;

      final pension =
          await database.createPension('pension', DateTime(2050, 1, 1));

      final entry = await database.createStatement(pension!.id, statementDate,
          planValue, projectedAnnualAmount, yearlyCharges, transferValue);

      expect(entry, match.isNotNull);
      expect(entry!.pension, pension.id);
      expect(entry.statementDate, statementDate);
      expect(entry.planValue, planValue);
      expect(entry.projectedAnnualAmount, projectedAnnualAmount);
      expect(entry.yearlyCharges, yearlyCharges);
      expect(entry.transferValue, transferValue);

      final result = await database.getStatement(entry.id);
      expect(result, match.isNotNull);
      expect(result!.id, entry.id);
      expect(result.pension, pension.id);
      expect(result.statementDate, statementDate);
      expect(result.planValue, planValue);
      expect(result.projectedAnnualAmount, projectedAnnualAmount);
      expect(result.yearlyCharges, yearlyCharges);
      expect(result.transferValue, transferValue);
    });

    test('read all new statement objects', () async {
      DateTime statementDate1 = DateTime(2024, 2, 3);
      double planValue1 = 123.45;
      double projectedAnnualAmount1 = 456.78;
      double? yearlyCharges1 = 78.90;
      double? transferValue1 = 90.12;
      DateTime statementDate2 = DateTime(2025, 4, 5);
      double planValue2 = 543.21;
      double projectedAnnualAmount2 = 876.54;
      double? yearlyCharges2 = 90.87;
      double? transferValue2 = 21.90;
      DateTime statementDate3 = DateTime(2026, 6, 7);
      double planValue3 = 987.65;
      double projectedAnnualAmount3 = 432.10;
      double? yearlyCharges3 = 65.43;
      double? transferValue3 = 12.34;

      final pension =
          await database.createPension('pension', DateTime(2050, 1, 1));

      final entry1 = await database.createStatement(pension!.id, statementDate1,
          planValue1, projectedAnnualAmount1, yearlyCharges1, transferValue1);
      final entry2 = await database.createStatement(pension.id, statementDate2,
          planValue2, projectedAnnualAmount2, yearlyCharges2, transferValue2);
      final entry3 = await database.createStatement(pension.id, statementDate3,
          planValue3, projectedAnnualAmount3, yearlyCharges3, transferValue3);

      final results = await database.getAllStatementsForPension(pension.id);
      expect(results, match.isNotNull);
      expect(results.length, 3);
      expect(results[0].id, entry1!.id);
      expect(results[0].pension, pension.id);
      expect(results[0].statementDate, statementDate1);
      expect(results[0].planValue, planValue1);
      expect(results[0].projectedAnnualAmount, projectedAnnualAmount1);
      expect(results[0].yearlyCharges, yearlyCharges1);
      expect(results[0].transferValue, transferValue1);
      expect(results[1].id, entry2!.id);
      expect(results[1].pension, pension.id);
      expect(results[1].statementDate, statementDate2);
      expect(results[1].planValue, planValue2);
      expect(results[1].projectedAnnualAmount, projectedAnnualAmount2);
      expect(results[1].yearlyCharges, yearlyCharges2);
      expect(results[1].transferValue, transferValue2);
      expect(results[2].id, entry3!.id);
      expect(results[2].pension, pension.id);
      expect(results[2].statementDate, statementDate3);
      expect(results[2].planValue, planValue3);
      expect(results[2].projectedAnnualAmount, projectedAnnualAmount3);
      expect(results[2].yearlyCharges, yearlyCharges3);
      expect(results[2].transferValue, transferValue3);
    });

    test('update a statement object', () async {
      DateTime statementDate = DateTime(2024, 2, 3);
      double planValue = 123.45;
      double projectedAnnualAmount = 456.78;
      double? yearlyCharges = 78.90;
      double? transferValue = 90.12;
      DateTime updatedStatementDate = DateTime(2025, 4, 5);
      double updatedPlanValue = 543.21;
      double updatedProjectedAnnualAmount = 876.54;
      double? updatedYearlyCharges = 90.87;
      double? updatedTransferValue = 21.90;
      final pension =
          await database.createPension('pension', DateTime(2050, 1, 1));

      final newEntry = await database.createStatement(
          pension!.id,
          statementDate,
          planValue,
          projectedAnnualAmount,
          yearlyCharges,
          transferValue);

      bool updated = await database.updateStatement(
          newEntry!.id,
          pension.id,
          updatedStatementDate,
          updatedPlanValue,
          updatedProjectedAnnualAmount,
          updatedYearlyCharges,
          updatedTransferValue);
      expect(updated, isTrue);

      final updatedEntry = await database.getStatement(newEntry.id);
      expect(updatedEntry, match.isNotNull);
      expect(updatedEntry!.id, newEntry.id);
      expect(updatedEntry.pension, pension.id);
      expect(updatedEntry.statementDate, updatedStatementDate);
      expect(updatedEntry.planValue, updatedPlanValue);
      expect(updatedEntry.projectedAnnualAmount, updatedProjectedAnnualAmount);
      expect(updatedEntry.yearlyCharges, updatedYearlyCharges);
      expect(updatedEntry.transferValue, updatedTransferValue);
    });

    test('delete a statement object', () async {
      DateTime statementDate = DateTime(2024, 2, 3);
      double planValue = 123.45;
      double projectedAnnualAmount = 456.78;
      double? yearlyCharges = 78.90;
      double? transferValue = 90.12;

      final pension =
          await database.createPension('pension', DateTime(2050, 1, 1));

      final entry = await database.createStatement(pension!.id, statementDate,
          planValue, projectedAnnualAmount, yearlyCharges, transferValue);

      final results = await database.getAllStatementsForPension(pension.id);
      expect(results, match.isNotNull);
      expect(results.length, 1);

      final deleted = await database.deleteStatement(entry!.id);
      expect(deleted, 1);

      final resultsAfterDelete =
          await database.getAllStatementsForPension(pension.id);
      expect(resultsAfterDelete, match.isNotNull);
      expect(resultsAfterDelete.length, 0);
    });

    test('delete a pension also deletes all statement objects', () async {
      DateTime statementDate = DateTime(2024, 2, 3);
      double planValue = 123.45;
      double projectedAnnualAmount = 456.78;
      double? yearlyCharges = 78.90;
      double? transferValue = 90.12;

      final pension =
          await database.createPension('pension', DateTime(2050, 1, 1));

      await database.createStatement(pension!.id, statementDate, planValue,
          projectedAnnualAmount, yearlyCharges, transferValue);
      await database.createStatement(pension.id, statementDate, planValue,
          projectedAnnualAmount, yearlyCharges, transferValue);

      final results = await database.getAllStatementsForPension(pension.id);
      expect(results, match.isNotNull);
      expect(results.length, 2);

      final deleted = await database.deletePension(pension.id);
      expect(deleted, 1);

      final resultsAfterDelete =
          await database.getAllStatementsForPension(pension.id);
      expect(resultsAfterDelete, match.isNotNull);
      expect(resultsAfterDelete.length, 0);
    });
  });
}
