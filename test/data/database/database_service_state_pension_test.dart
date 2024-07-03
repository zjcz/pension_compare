import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/constants/defaults.dart' as defaults;
import 'package:test/test.dart';
import 'package:matcher/matcher.dart' as match;

void main() {
  late DatabaseService database;

  setUp(() {
    final inMemory = DatabaseConnection(NativeDatabase.memory());
    database = DatabaseService(inMemory);
  });

  tearDown(() => database.close());

  group('Test state pension object', () {
    test('state pension object created at startup', () async {
      final entry = await database.getStatePension();

      expect(entry, match.isNotNull);
      expect(entry!.otherIncomeId, defaults.defaultStatePensionId);
      expect(entry.annualAmount, isZero);
    });

    test('read the state pension object after save', () async {
      double statePensionValue = 123.45;
      String notes = 'test notes';
      await database.saveStatePension(statePensionValue, notes);
      final entry = await database.getStatePension();

      expect(entry, match.isNotNull);
      expect(entry!.otherIncomeId, defaults.defaultStatePensionId);
      expect(entry.annualAmount, statePensionValue);
      expect(entry.notes, notes);
    });

    test('update the state pension object', () async {
      double statePensionValue1 = 100;
      String notes1 = 'test notes 1';
      double statePensionValue2 = 200;
      String notes2 = 'test notes 2';

      final saved1 = await database.saveStatePension(statePensionValue1, notes1);
      expect(saved1, match.isNotNull);
      expect(saved1!.otherIncomeId, defaults.defaultStatePensionId);
      expect(saved1.annualAmount, statePensionValue1);
      expect(saved1.notes, notes1);

      final saved2 = await database.saveStatePension(statePensionValue2, notes2);
      expect(saved2, match.isNotNull);
      expect(saved2!.otherIncomeId, defaults.defaultStatePensionId);
      expect(saved2.annualAmount, statePensionValue2);
      expect(saved2.notes, notes2);

      final entry = await database.getStatePension();
      expect(entry, match.isNotNull);
      expect(entry!.otherIncomeId, defaults.defaultStatePensionId);
      expect(entry.annualAmount, statePensionValue2);
      expect(entry.notes, notes2);
    });
  });
}
