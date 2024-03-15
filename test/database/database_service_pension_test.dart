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

      final result = await database.getPension(entry.id);
      expect(result, match.isNotNull);
      expect(result!.id, entry.id);
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
      expect(results[0].id, entry1!.id);
      expect(results[0].name, entry1.name);
      expect(results[0].maturityDate, entry1.maturityDate);
      expect(results[1].id, entry2!.id);
      expect(results[1].name, entry2.name);
      expect(results[1].maturityDate, entry2.maturityDate);
      expect(results[2].id, entry3!.id);
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
          newEntry!.id, updatedName, updatedMaturityDate);

      expect(updated, isTrue);

      final updatedEntry = await database.getPension(newEntry.id);
      expect(updatedEntry, match.isNotNull);
      expect(updatedEntry!.id, newEntry.id);
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

      final deleted = await database.deletePension(entry!.id);
      expect(deleted, 1);

      final resultsAfterDelete = await database.getAllPensions();
      expect(resultsAfterDelete, match.isNotNull);
      expect(resultsAfterDelete.length, 0);
    });
  });
}
