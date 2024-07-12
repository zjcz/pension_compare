import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:pension_compare/data/database/database_service.dart';
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
      String notes = 'notes';

      final entry = await database.createPension(name, maturityDate, notes);
      expect(entry, match.isNotNull);
      expect(entry!.name, name);
      expect(entry.maturityDate, maturityDate);
      expect(entry.notes, notes);
    });

    test('read a new pension object', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String notes = 'notes';

      final entry = await database.createPension(name, maturityDate, notes);
      expect(entry, match.isNotNull);
      expect(entry!.name, name);
      expect(entry.maturityDate, maturityDate);
      expect(entry.notes, notes);

      final result = await database.getPension(entry.pensionId);
      expect(result, match.isNotNull);
      expect(result!.pensionId, entry.pensionId);
      expect(result.name, name);
      expect(result.maturityDate, maturityDate);
      expect(result.notes, notes);
    });

    test('watch returns a new pension object', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String notes = 'notes';

      final entry = await database.createPension(name, maturityDate, notes);
      expect(entry, match.isNotNull);
      expect(entry!.name, name);
      expect(entry.maturityDate, maturityDate);
      expect(entry.notes, notes);

      final result = database.watchPension(entry.pensionId);
      expect(result, match.isNotNull);
      final pensionRecord = await result.first;
      expect(pensionRecord, match.isNotNull);
      expect(pensionRecord!.pensionId, entry.pensionId);
      expect(pensionRecord.name, name);
      expect(pensionRecord.maturityDate, maturityDate);
      expect(pensionRecord.notes, notes);
    });

    test('read all new pension objects', () async {
      String name1 = 'new pension 1';
      DateTime maturityDate1 = DateTime(2050, 1, 1);
      String notes1 = 'notes 1';
      String name2 = 'new pension 2';
      DateTime maturityDate2 = DateTime(2050, 2, 2);
      String notes2 = 'notes 2';
      String name3 = 'new pension 3';
      DateTime maturityDate3 = DateTime(2050, 3, 3);
      String notes3 = 'notes 3';

      final entry1 = await database.createPension(name1, maturityDate1, notes1);
      final entry2 = await database.createPension(name2, maturityDate2, notes2);
      final entry3 = await database.createPension(name3, maturityDate3, notes3);

      final results = await database.getAllPensions().first;
      expect(results, match.isNotNull);
      expect(results.length, 3);
      expect(results[0].pensionId, entry1!.pensionId);
      expect(results[0].name, entry1.name);
      expect(results[0].maturityDate, entry1.maturityDate);
      expect(results[0].notes, entry1.notes);
      expect(results[1].pensionId, entry2!.pensionId);
      expect(results[1].name, entry2.name);
      expect(results[1].maturityDate, entry2.maturityDate);
      expect(results[1].notes, entry2.notes);
      expect(results[2].pensionId, entry3!.pensionId);
      expect(results[2].name, entry3.name);
      expect(results[2].maturityDate, entry3.maturityDate);
      expect(results[2].notes, entry3.notes);
    });

    test('update a pension object', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String notes = 'notes';
      String updatedName = 'new pension';
      DateTime updatedMaturityDate = DateTime(2050, 1, 1);
      String updatedNotes = 'updated notes';

      final newEntry = await database.createPension(name, maturityDate, notes);
      expect(newEntry, match.isNotNull);

      int updatedCount = await database.updatePension(
          newEntry!.pensionId, updatedName, updatedMaturityDate, updatedNotes);

      expect(updatedCount, 1);

      final updatedEntry = await database.getPension(newEntry.pensionId);
      expect(updatedEntry, match.isNotNull);
      expect(updatedEntry!.pensionId, newEntry.pensionId);
      expect(updatedEntry.name, updatedName);
      expect(updatedEntry.maturityDate, updatedMaturityDate);
      expect(updatedEntry.notes, updatedNotes);
    });

    test('update a pension object does not change status', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String notes = 'notes';
      String updatedName = 'new pension';
      DateTime updatedMaturityDate = DateTime(2050, 1, 1);
      String updatedNotes = 'updated notes';

      final newEntry = await database.createPension(name, maturityDate, notes);
      expect(newEntry, match.isNotNull);

      int updatedCount = await database.updatePension(
          newEntry!.pensionId, updatedName, updatedMaturityDate, updatedNotes);

      expect(updatedCount, 1);

      final updatedEntry = await database.getPension(newEntry.pensionId);
      expect(updatedEntry, match.isNotNull);
      expect(updatedEntry!.status, newEntry.status);
      expect(updatedEntry.statusDate, newEntry.statusDate);
    });

    test('update a pension object only changes intended record', () async {
      String name1 = 'new pension 1';
      DateTime maturityDate1 = DateTime(2050, 1, 1);
      String notes1 = 'notes 1';
      String name2 = 'new pension 2';
      DateTime maturityDate2 = DateTime(2050, 2, 2);
      String notes2 = 'notes 2';
      String name3 = 'new pension 3';
      DateTime maturityDate3 = DateTime(2050, 3, 3);
      String notes3 = 'notes 3';
      String updatedName = 'new pension';
      DateTime updatedMaturityDate = DateTime(2050, 1, 1);
      String updatedNotes = 'updated notes';

      final newEntry1 = await database.createPension(name1, maturityDate1, notes1);
      final newEntry2 = await database.createPension(name2, maturityDate2, notes2);
      final newEntry3 = await database.createPension(name3, maturityDate3, notes3);

      int updatedCount = await database.updatePension(
          newEntry2!.pensionId, updatedName, updatedMaturityDate, updatedNotes);

      expect(updatedCount, 1);

      final notChangedEntry1 = await database.getPension(newEntry1!.pensionId);
      final notChangedEntry3 = await database.getPension(newEntry3!.pensionId);      
      expect(notChangedEntry1, match.isNotNull);
      expect(notChangedEntry3, match.isNotNull);
      expect(notChangedEntry1, newEntry1);
      expect(notChangedEntry3, newEntry3);
    });

    test('delete a pension object', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String notes = 'notes';

      final entry = await database.createPension(name, maturityDate, notes);

      final results = await database.getAllPensions().first;
      expect(results, match.isNotNull);
      expect(results.length, 1);

      final deleted = await database.deletePension(entry!.pensionId);
      expect(deleted, 1);

      final resultsAfterDelete = await database.getAllPensions().first;
      expect(resultsAfterDelete, match.isNotNull);
      expect(resultsAfterDelete.length, 0);
    });
  });

  group('Test pension summary', () {
    test('Pension summary returns pension with no statements', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String notes = 'notes';

      await database.createPension(name, maturityDate, notes);

      final results = await database.getAllPensionsWithLatestStatement().first;
      expect(results, match.isNotNull);
      expect(results.length, 1);
      expect(results[0].pension, match.isNotNull);
      expect(results[0].statement, match.isNull);
    });

    test('Pension summary returns pension and latest statements', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String notes = 'notes';
      DateTime statementDate1 = DateTime(2024, 2, 3);
      double planValue1 = 123.45;
      double projectedAnnualAmount1 = 456.78;
      double? yearlyCharges1 = 78.90;
      double? transferValue1 = 90.12;
      double? amountPaidIn1 = 34.56;
      String statementNotes1 = 'statement notes 1';
      DateTime statementDate2 = DateTime(2025, 4, 5);
      double planValue2 = 543.21;
      double projectedAnnualAmount2 = 876.54;
      double? yearlyCharges2 = 90.87;
      double? transferValue2 = 21.90;
      double? amountPaidIn2 = 12.34;
      String statementNotes2 = 'statement notes 2';
      DateTime statementDate3 = DateTime(2026, 6, 7);
      double planValue3 = 987.65;
      double projectedAnnualAmount3 = 432.10;
      double? yearlyCharges3 = 65.43;
      double? transferValue3 = 12.34;
      double? amountPaidIn3 = 56.78;
      String statementNotes3 = 'statement notes 3';
      final pension = await database.createPension(name, maturityDate, notes);
      await database.createStatement(
          pension!.pensionId,
          statementDate1,
          planValue1,
          projectedAnnualAmount1,
          yearlyCharges1,
          transferValue1,
          amountPaidIn1,
          statementNotes1);
      await database.createStatement(
          pension.pensionId,
          statementDate2,
          planValue2,
          projectedAnnualAmount2,
          yearlyCharges2,
          transferValue2,
          amountPaidIn2,
          statementNotes2);
      await database.createStatement(
          pension.pensionId,
          statementDate3,
          planValue3,
          projectedAnnualAmount3,
          yearlyCharges3,
          transferValue3,
          amountPaidIn3,
          statementNotes3);

      final results = await database.getAllPensionsWithLatestStatement().first;
      expect(results, match.isNotNull);
      expect(results.length, 1);
      expect(results[0].pension, match.isNotNull);
      expect(results[0].statement, match.isNotNull);

      expect(results[0].pension.pensionId, pension.pensionId);
      expect(results[0].pension.name, pension.name);
      expect(results[0].pension.maturityDate, pension.maturityDate);
      expect(results[0].pension.notes, pension.notes);

      expect(results[0].statement!.pension, pension.pensionId);
      expect(results[0].statement!.statementDate, statementDate3);
      expect(results[0].statement!.planValue, planValue3);
      expect(
          results[0].statement!.projectedAnnualAmount, projectedAnnualAmount3);
      expect(results[0].statement!.yearlyCharges, yearlyCharges3);
      expect(results[0].statement!.transferValue, transferValue3);
      expect(results[0].statement!.amountPaidIn, amountPaidIn3);
      expect(results[0].statement!.statementNotes, statementNotes3);
    });
  });

  group('Test yearly pension summary', () {
    test(
        'Given no pensions When running Yearly Pension Summary Then expect no data ',
        () async {
      final results = await database.getYearlyPensionSummary().first;
      expect(results, match.isNotNull);
      expect(results.length, 0);
    });

    test(
        'Given no statements When running Yearly Pension Summary Then expect no data ',
        () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String notes = 'notes';

      await database.createPension(name, maturityDate, notes);

      final results = await database.getYearlyPensionSummary().first;
      expect(results, match.isNotNull);
      expect(results.length, 0);
    });

    test(
        'Given pension and statement data When running Yearly Pension Summary Then expect data ',
        () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String notes = 'notes';
      DateTime statementDate1 = DateTime(2024, 2, 3);
      double planValue1 = 123.45;
      double projectedAnnualAmount1 = 456.78;
      double? yearlyCharges1 = 78.90;
      double? transferValue1 = 90.12;
      double? amountPaidIn1 = 34.56;
      String statementNotes1 = 'statement notes 1';
      DateTime statementDate2 = DateTime(2025, 4, 5);
      double planValue2 = 543.21;
      double projectedAnnualAmount2 = 876.54;
      double? yearlyCharges2 = 90.87;
      double? transferValue2 = 21.90;
      double? amountPaidIn2 = 12.34;
      String statementNotes2 = 'statement notes 2';
      DateTime statementDate3 = DateTime(2026, 6, 7);
      double planValue3 = 987.65;
      double projectedAnnualAmount3 = 432.10;
      double? yearlyCharges3 = 65.43;
      double? transferValue3 = 12.34;
      double? amountPaidIn3 = 56.78;
      String statementNotes3 = 'statement notes 3';

      final pension = await database.createPension(name, maturityDate, notes);
      final statement1 = await database.createStatement(
          pension!.pensionId,
          statementDate1,
          planValue1,
          projectedAnnualAmount1,
          yearlyCharges1,
          transferValue1,
          amountPaidIn1,
          statementNotes1);
      final statement2 = await database.createStatement(
          pension.pensionId,
          statementDate2,
          planValue2,
          projectedAnnualAmount2,
          yearlyCharges2,
          transferValue2,
          amountPaidIn2,
          statementNotes2);
      final statement3 = await database.createStatement(
          pension.pensionId,
          statementDate3,
          planValue3,
          projectedAnnualAmount3,
          yearlyCharges3,
          transferValue3,
          amountPaidIn3,
          statementNotes3);

      final results = await database.getYearlyPensionSummary().first;
      expect(results, match.isNotNull);
      expect(results.length, 3);
      expect(results[0].year, statementDate1.year);
      expect(results[1].year, statementDate2.year);
      expect(results[2].year, statementDate3.year);

      expect(results[0].pensionWithStatement, match.isNotNull);
      expect(results[0].pensionWithStatement.length, 1);
      expect(results[0].pensionWithStatement.first.pension, pension);
      expect(results[0].pensionWithStatement.first.statement, statement1!);

      expect(results[1].pensionWithStatement, match.isNotNull);
      expect(results[1].pensionWithStatement.length, 1);
      expect(results[1].pensionWithStatement.first.pension, pension);
      expect(results[1].pensionWithStatement.first.statement, statement2!);

      expect(results[2].pensionWithStatement, match.isNotNull);
      expect(results[2].pensionWithStatement.length, 1);
      expect(results[2].pensionWithStatement.first.pension, pension);
      expect(results[2].pensionWithStatement.first.statement, statement3!);
    });

    test(
        'Given pension with multiple statement in the same year When running Yearly Pension Summary Then expect latest statement ',
        () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String notes = 'notes';
      DateTime statementDate1 = DateTime(2024, 1, 1);
      double planValue1 = 123.45;
      double projectedAnnualAmount1 = 456.78;
      double? yearlyCharges1 = 78.90;
      double? transferValue1 = 90.12;
      double? amountPaidIn1 = 34.56;
      String statementNotes1 = 'statement notes 1';
      DateTime statementDate2 = DateTime(2024, 2, 2);
      double planValue2 = 543.21;
      double projectedAnnualAmount2 = 876.54;
      double? yearlyCharges2 = 90.87;
      double? transferValue2 = 21.90;
      double? amountPaidIn2 = 12.34;
      String statementNotes2 = 'statement notes 2';

      final pension = await database.createPension(name, maturityDate, notes);
      await database.createStatement(
          pension!.pensionId,
          statementDate1,
          planValue1,
          projectedAnnualAmount1,
          yearlyCharges1,
          transferValue1,
          amountPaidIn1,
          statementNotes1);
      final statement2 = await database.createStatement(
          pension.pensionId,
          statementDate2,
          planValue2,
          projectedAnnualAmount2,
          yearlyCharges2,
          transferValue2,
          amountPaidIn2,
          statementNotes2);

      final results = await database.getYearlyPensionSummary().first;
      expect(results, match.isNotNull);
      expect(results.length, 1);
      expect(results[0].year, statementDate1.year);

      expect(results[0].pensionWithStatement, match.isNotNull);
      expect(results[0].pensionWithStatement.length, 1);
      expect(results[0].pensionWithStatement.first.pension, pension);
      expect(results[0].pensionWithStatement.first.statement, statement2!);
    });
  });

  group('Test pension name is unique', () {
    test('Create fails if name already in use', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String notes = 'notes';

      await database.createPension(name, maturityDate, notes);
      await expectLater(database.createPension(name, maturityDate, notes),
          throwsA(isException));
    });

    test('Create succeeds if name already in use but record deleted', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String notes = 'notes';

      Pension? p1 = await database.createPension(name, maturityDate, notes);
      await database.deletePension(p1!.pensionId);
      expectLater(database.createPension(name, maturityDate, notes), completes);
    });

    // Sqlite UNIQUE(<column> COLLATE NOCASE) is not supported by Drift
    // test('Create fails if name already in use in different case', () async {
    //   String name = 'new pension';
    //   DateTime maturityDate = DateTime(2050, 1, 1);

    //   await database.createPension(name.toUpperCase(), maturityDate);
    //   await expectLater(
    //       database.createPension(name.toLowerCase(), maturityDate),
    //       throwsA(isException));
    // });

    test('Test if name already used in an empty table', () async {
      String name = 'new pension';
      bool response = await database.doesPensionNameExist(null, name);

      expect(response, isFalse);
    });

    test('Test if name already used in populated table', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String notes = 'notes';

      await database.createPension(name, maturityDate, notes);
      bool response = await database.doesPensionNameExist(null, name);

      expect(response, isTrue);
    });

    test('Test if name already used for this record', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String notes = 'notes';

      Pension? p1 = await database.createPension(name, maturityDate, notes);
      bool response = await database.doesPensionNameExist(p1!.pensionId, name);

      expect(response, isFalse);
    });

    test('Test if name already used for another record', () async {
      String name1 = 'new pension 1';
      String name2 = 'new pension 2';
      String name2updated = 'new pension 1';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String notes = 'notes';

      await database.createPension(name1, maturityDate, notes);
      Pension? p2 = await database.createPension(name2, maturityDate, notes);
      bool response =
          await database.doesPensionNameExist(p2!.pensionId, name2updated);

      expect(response, isTrue);
    });

    test('Test if name already used with deleted record', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String notes = 'notes';

      Pension? p1 = await database.createPension(name, maturityDate, notes);
      await database.deletePension(p1!.pensionId);
      bool response = await database.doesPensionNameExist(null, name);

      expect(response, isFalse);
    });

    test('Test if name in different case already used ', () async {
      String name = 'new pension';
      DateTime maturityDate = DateTime(2050, 1, 1);
      String notes = 'notes';

      await database.createPension(name.toUpperCase(), maturityDate, notes);
      bool response =
          await database.doesPensionNameExist(null, name.toLowerCase());

      expect(response, isTrue);
    });
  });
}
