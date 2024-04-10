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

      final entry = await database.createStatement(
          pension!.pensionId,
          statementDate,
          planValue,
          projectedAnnualAmount,
          yearlyCharges,
          transferValue);

      expect(entry, match.isNotNull);
      expect(entry!.pension, pension.pensionId);
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

      final entry = await database.createStatement(
          pension!.pensionId,
          statementDate,
          planValue,
          projectedAnnualAmount,
          yearlyCharges,
          transferValue);

      expect(entry, match.isNotNull);
      expect(entry!.pension, pension.pensionId);
      expect(entry.statementDate, statementDate);
      expect(entry.planValue, planValue);
      expect(entry.projectedAnnualAmount, projectedAnnualAmount);
      expect(entry.yearlyCharges, yearlyCharges);
      expect(entry.transferValue, transferValue);

      final result = await database.getStatement(entry.statementId);
      expect(result, match.isNotNull);
      expect(result!.statementId, entry.statementId);
      expect(result.pension, pension.pensionId);
      expect(result.statementDate, statementDate);
      expect(result.planValue, planValue);
      expect(result.projectedAnnualAmount, projectedAnnualAmount);
      expect(result.yearlyCharges, yearlyCharges);
      expect(result.transferValue, transferValue);
    });

    test(
        'Saving a new statement object removes time component from statement date',
        () async {
      DateTime statementDate = DateTime(2024, 2, 3, 12, 34, 56, 78);
      double planValue = 123.45;
      double projectedAnnualAmount = 456.78;
      double? yearlyCharges = 78.90;
      double? transferValue = 90.12;

      final pension =
          await database.createPension('pension', DateTime(2050, 1, 1));

      final entry = await database.createStatement(
          pension!.pensionId,
          statementDate,
          planValue,
          projectedAnnualAmount,
          yearlyCharges,
          transferValue);

      expect(entry, match.isNotNull);
      expect(entry!.statementDate.year, statementDate.year);
      expect(entry.statementDate.month, statementDate.month);
      expect(entry.statementDate.day, statementDate.day);
      expect(entry.statementDate.hour, 0);
      expect(entry.statementDate.minute, 0);
      expect(entry.statementDate.second, 0);
      expect(entry.statementDate.millisecond, 0);
      expect(entry.statementDate.microsecond, 0);

      final result = await database.getStatement(entry.statementId);
      expect(result, match.isNotNull);
      expect(result!.statementDate.year, statementDate.year);
      expect(result.statementDate.month, statementDate.month);
      expect(result.statementDate.day, statementDate.day);
      expect(result.statementDate.hour, 0);
      expect(result.statementDate.minute, 0);
      expect(result.statementDate.second, 0);
      expect(result.statementDate.millisecond, 0);
      expect(result.statementDate.microsecond, 0);
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

      final entry1 = await database.createStatement(
          pension!.pensionId,
          statementDate1,
          planValue1,
          projectedAnnualAmount1,
          yearlyCharges1,
          transferValue1);
      final entry2 = await database.createStatement(
          pension.pensionId,
          statementDate2,
          planValue2,
          projectedAnnualAmount2,
          yearlyCharges2,
          transferValue2);
      final entry3 = await database.createStatement(
          pension.pensionId,
          statementDate3,
          planValue3,
          projectedAnnualAmount3,
          yearlyCharges3,
          transferValue3);

      final results =
          await database.getAllStatementsForPension(pension.pensionId);
      expect(results, match.isNotNull);
      expect(results.length, 3);
      expect(results[0].statementId, entry1!.statementId);
      expect(results[0].pension, pension.pensionId);
      expect(results[0].statementDate, statementDate1);
      expect(results[0].planValue, planValue1);
      expect(results[0].projectedAnnualAmount, projectedAnnualAmount1);
      expect(results[0].yearlyCharges, yearlyCharges1);
      expect(results[0].transferValue, transferValue1);
      expect(results[1].statementId, entry2!.statementId);
      expect(results[1].pension, pension.pensionId);
      expect(results[1].statementDate, statementDate2);
      expect(results[1].planValue, planValue2);
      expect(results[1].projectedAnnualAmount, projectedAnnualAmount2);
      expect(results[1].yearlyCharges, yearlyCharges2);
      expect(results[1].transferValue, transferValue2);
      expect(results[2].statementId, entry3!.statementId);
      expect(results[2].pension, pension.pensionId);
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
          pension!.pensionId,
          statementDate,
          planValue,
          projectedAnnualAmount,
          yearlyCharges,
          transferValue);

      bool updated = await database.updateStatement(
          newEntry!.statementId,
          pension.pensionId,
          updatedStatementDate,
          updatedPlanValue,
          updatedProjectedAnnualAmount,
          updatedYearlyCharges,
          updatedTransferValue);
      expect(updated, isTrue);

      final updatedEntry = await database.getStatement(newEntry.statementId);
      expect(updatedEntry, match.isNotNull);
      expect(updatedEntry!.statementId, newEntry.statementId);
      expect(updatedEntry.pension, pension.pensionId);
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

      final entry = await database.createStatement(
          pension!.pensionId,
          statementDate,
          planValue,
          projectedAnnualAmount,
          yearlyCharges,
          transferValue);

      final results =
          await database.getAllStatementsForPension(pension.pensionId);
      expect(results, match.isNotNull);
      expect(results.length, 1);

      final deleted = await database.deleteStatement(entry!.statementId);
      expect(deleted, 1);

      final resultsAfterDelete =
          await database.getAllStatementsForPension(pension.pensionId);
      expect(resultsAfterDelete, match.isNotNull);
      expect(resultsAfterDelete.length, 0);
    });

    test('delete a pension also deletes all statement objects', () async {
      DateTime statementDate1 = DateTime(2023, 1, 1);
      DateTime statementDate2 = DateTime(2024, 1, 1);
      double planValue = 123.45;
      double projectedAnnualAmount = 456.78;
      double? yearlyCharges = 78.90;
      double? transferValue = 90.12;

      final pension =
          await database.createPension('pension', DateTime(2050, 1, 1));

      await database.createStatement(pension!.pensionId, statementDate1,
          planValue, projectedAnnualAmount, yearlyCharges, transferValue);
      await database.createStatement(pension.pensionId, statementDate2,
          planValue, projectedAnnualAmount, yearlyCharges, transferValue);

      final results =
          await database.getAllStatementsForPension(pension.pensionId);
      expect(results, match.isNotNull);
      expect(results.length, 2);

      final deleted = await database.deletePension(pension.pensionId);
      expect(deleted, 1);

      final resultsAfterDelete =
          await database.getAllStatementsForPension(pension.pensionId);
      expect(resultsAfterDelete, match.isNotNull);
      expect(resultsAfterDelete.length, 0);
    });
  });

  group('Test pension / statement date combination is unique', () {
    test('Create fails if statement date already in use', () async {
      DateTime statementDate = DateTime(2024, 2, 3);
      double planValue = 123.45;
      double projectedAnnualAmount = 456.78;
      double? yearlyCharges = 78.90;
      double? transferValue = 90.12;

      final pension =
          await database.createPension('pension', DateTime(2050, 1, 1));

      await database.createStatement(pension!.pensionId, statementDate,
          planValue, projectedAnnualAmount, yearlyCharges, transferValue);
      await expectLater(
          database.createStatement(pension.pensionId, statementDate, planValue,
              projectedAnnualAmount, yearlyCharges, transferValue),
          throwsA(isException));
    });

    test('Create succeeds if statement date already in use but record deleted',
        () async {
      DateTime statementDate = DateTime(2024, 2, 3);
      double planValue = 123.45;
      double projectedAnnualAmount = 456.78;
      double? yearlyCharges = 78.90;
      double? transferValue = 90.12;

      final pension =
          await database.createPension('pension', DateTime(2050, 1, 1));

      Statement? s1 = await database.createStatement(
          pension!.pensionId,
          statementDate,
          planValue,
          projectedAnnualAmount,
          yearlyCharges,
          transferValue);
      await database.deleteStatement(s1!.statementId);
      await expectLater(
          database.createStatement(pension.pensionId, statementDate, planValue,
              projectedAnnualAmount, yearlyCharges, transferValue),
          completes);
    });

    test('Create succeeds if statement date already in use on another pension',
        () async {
      DateTime statementDate = DateTime(2024, 2, 3);
      double planValue = 123.45;
      double projectedAnnualAmount = 456.78;
      double? yearlyCharges = 78.90;
      double? transferValue = 90.12;

      final pension1 =
          await database.createPension('pension 1', DateTime(2050, 1, 1));
      final pension2 =
          await database.createPension('pension 2', DateTime(2050, 1, 1));
      await database.createStatement(pension1!.pensionId, statementDate,
          planValue, projectedAnnualAmount, yearlyCharges, transferValue);
      await expectLater(
          database.createStatement(pension2!.pensionId, statementDate,
              planValue, projectedAnnualAmount, yearlyCharges, transferValue),
          completes);
    });

    test('Test if statement date already used in an empty table', () async {
      int pensionId = 1;
      DateTime statementDate = DateTime(2024, 2, 3);

      bool response =
          await database.doesStatementDateExist(null, pensionId, statementDate);

      expect(response, isFalse);
    });

    test('Test if statement date already used in populated table', () async {
      DateTime statementDate = DateTime(2024, 2, 3);
      double planValue = 123.45;
      double projectedAnnualAmount = 456.78;
      double? yearlyCharges = 78.90;
      double? transferValue = 90.12;

      final pension1 =
          await database.createPension('pension 1', DateTime(2050, 1, 1));
      await database.createStatement(pension1!.pensionId, statementDate,
          planValue, projectedAnnualAmount, yearlyCharges, transferValue);

      bool response = await database.doesStatementDateExist(
          null, pension1.pensionId, statementDate);

      expect(response, isTrue);
    });

    test('Test if statement date already used for this record', () async {
      DateTime statementDate = DateTime(2024, 2, 3);
      double planValue = 123.45;
      double projectedAnnualAmount = 456.78;
      double? yearlyCharges = 78.90;
      double? transferValue = 90.12;

      final pension1 =
          await database.createPension('pension 1', DateTime(2050, 1, 1));
      final statement1 = await database.createStatement(
          pension1!.pensionId,
          statementDate,
          planValue,
          projectedAnnualAmount,
          yearlyCharges,
          transferValue);

      bool response = await database.doesStatementDateExist(
          statement1!.statementId, pension1.pensionId, statementDate);

      expect(response, isFalse);
    });

    test('Test if statement date already used for another record', () async {
      DateTime statementDate1 = DateTime(2023, 1, 1);
      DateTime statementDate2 = DateTime(2024, 1, 1);
      DateTime statementDate2Updated = DateTime(2023, 1, 1);
      double planValue = 123.45;
      double projectedAnnualAmount = 456.78;
      double? yearlyCharges = 78.90;
      double? transferValue = 90.12;

      Pension? pension1 =
          await database.createPension('pension 1', DateTime(2050, 1, 1));
      await database.createStatement(pension1!.pensionId, statementDate1,
          planValue, projectedAnnualAmount, yearlyCharges, transferValue);
      final statement2 = await database.createStatement(
          pension1.pensionId,
          statementDate2,
          planValue,
          projectedAnnualAmount,
          yearlyCharges,
          transferValue);

      bool response = await database.doesStatementDateExist(
          statement2!.statementId, pension1.pensionId, statementDate2Updated);

      expect(response, isTrue);
    });

    test('Test if statement date is already used with deleted record',
        () async {
      DateTime statementDate = DateTime(2024, 2, 3);
      double planValue = 123.45;
      double projectedAnnualAmount = 456.78;
      double? yearlyCharges = 78.90;
      double? transferValue = 90.12;

      final pension =
          await database.createPension('pension', DateTime(2050, 1, 1));

      Statement? s1 = await database.createStatement(
          pension!.pensionId,
          statementDate,
          planValue,
          projectedAnnualAmount,
          yearlyCharges,
          transferValue);
      await database.deleteStatement(s1!.statementId);

      bool response = await database.doesStatementDateExist(
          null, pension.pensionId, statementDate);

      expect(response, isFalse);
    });

    test(
        'Test the time component is ignored when checking statement date exists',
        () async {
      DateTime statementDate = DateTime(2024, 2, 3, 12, 34, 56, 78);
      DateTime statementDate2 = DateTime(2024, 2, 3, 18, 23, 45, 67);
      double planValue = 123.45;
      double projectedAnnualAmount = 456.78;
      double? yearlyCharges = 78.90;
      double? transferValue = 90.12;

      final pension =
          await database.createPension('pension', DateTime(2050, 1, 1));

      await database.createStatement(pension!.pensionId, statementDate,
          planValue, projectedAnnualAmount, yearlyCharges, transferValue);

      bool response = await database.doesStatementDateExist(
          null, pension.pensionId, statementDate2);

      expect(response, isTrue);
    });
  });
}
