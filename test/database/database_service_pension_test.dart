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

  group('Test CRUD of pension objects', () {
    test('create a new pension object', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);

      final entry = await database.createPension(name, maturityDate);
      expect(entry, match.isNotNull);
      expect(entry!.name, name);
      expect(entry.maturityDate, maturityDate);
    });

    test('read a new pension object', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);

      final entry = await database.createPension(name, maturityDate);
      expect(entry, match.isNotNull);
      expect(entry!.name, name);
      expect(entry.maturityDate, maturityDate);

      final result = await database.getPension(entry.pensionId);
      expect(result, match.isNotNull);
      expect(result!.pensionId, entry.pensionId);
      expect(result.name, name);
      expect(result.maturityDate, maturityDate);
    });

    test('read all new pension objects', () async {
      String name1 = 'new pension 1';
      DateTime maturityDate1 = DateTime(2050, 1, 1);

      String name2 = 'new pension 2';
      DateTime maturityDate2 = DateTime(2050, 2, 2);

      String name3 = 'new pension 3';
      DateTime maturityDate3 = DateTime(2050, 3, 3);

      final entry1 = await database.createPension(name1, maturityDate1);
      final entry2 = await database.createPension(name2, maturityDate2);
      final entry3 = await database.createPension(name3, maturityDate3);

      final results = await database.getAllPensions();
      expect(results, match.isNotNull);
      expect(results.length, 3);
      expect(results[0].pensionId, entry1!.pensionId);
      expect(results[0].name, entry1.name);
      expect(results[0].maturityDate, entry1.maturityDate);
      expect(results[1].pensionId, entry2!.pensionId);
      expect(results[1].name, entry2.name);
      expect(results[1].maturityDate, entry2.maturityDate);
      expect(results[2].pensionId, entry3!.pensionId);
      expect(results[2].name, entry3.name);
      expect(results[2].maturityDate, entry3.maturityDate);
    });

    test('update a pension object', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String updatedName = 'new pension';
      DateTime updatedMaturityDate = DateTime(2050, 1, 1);

      final newEntry = await database.createPension(name, maturityDate);
      expect(newEntry, match.isNotNull);

      bool updated = await database.updatePension(
          newEntry!.pensionId, updatedName, updatedMaturityDate);

      expect(updated, isTrue);

      final updatedEntry = await database.getPension(newEntry.pensionId);
      expect(updatedEntry, match.isNotNull);
      expect(updatedEntry!.pensionId, newEntry.pensionId);
      expect(updatedEntry.name, updatedName);
      expect(updatedEntry.maturityDate, updatedMaturityDate);
    });

    test('delete a pension object', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);

      final entry = await database.createPension(name, maturityDate);

      final results = await database.getAllPensions();
      expect(results, match.isNotNull);
      expect(results.length, 1);

      final deleted = await database.deletePension(entry!.pensionId);
      expect(deleted, 1);

      final resultsAfterDelete = await database.getAllPensions();
      expect(resultsAfterDelete, match.isNotNull);
      expect(resultsAfterDelete.length, 0);
    });
  });

  group('Test pension summary', () {
    test('Pension summary returns pension with no statements', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);

      final entry = await database.createPension(name, maturityDate);

      final results = await database.getAllPensionsWithLatestStatement();
      expect(results, match.isNotNull);
      expect(results.length, 1);
      expect(results[0].pension, match.isNotNull);
      expect(results[0].latestStatement, match.isNull);
    });

    test('Pension summary returns pension and latest statements', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
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

      final pension = await database.createPension(name, maturityDate);
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

      final results = await database.getAllPensionsWithLatestStatement();
      expect(results, match.isNotNull);
      expect(results.length, 1);
      expect(results[0].pension, match.isNotNull);
      expect(results[0].latestStatement, match.isNotNull);

      expect(results[0].pension.pensionId, pension.pensionId);
      expect(results[0].pension.name, pension.name);
      expect(results[0].pension.maturityDate, pension.maturityDate);

      expect(results[0].latestStatement!.pension, pension.pensionId);
      expect(results[0].latestStatement!.statementDate, statementDate3);
      expect(results[0].latestStatement!.planValue, planValue3);
      expect(results[0].latestStatement!.projectedAnnualAmount,
          projectedAnnualAmount3);
      expect(results[0].latestStatement!.yearlyCharges, yearlyCharges3);
      expect(results[0].latestStatement!.transferValue, transferValue3);
    });
  });
}
