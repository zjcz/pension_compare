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

  group('Test state pension object', () {
    test('state pension object created at startup', () async {
      final entry = await database.getStatePension();

      expect(entry, match.isNotNull);
      expect(entry!.id, 1);
      expect(entry.projectedAnnualAmount, isZero);
    });

    test('read the state pension object after save', () async {
      double statePensionValue = 123.45;

      await database.saveStatePension(statePensionValue);
      final entry = await database.getStatePension();

      expect(entry, match.isNotNull);
      expect(entry!.id, 1);
      expect(entry.projectedAnnualAmount, statePensionValue);
    });

    test('update the state pension object', () async {
      double statePensionValue1 = 100;
      double statePensionValue2 = 200;

      final saved1 = await database.saveStatePension(statePensionValue1);
      expect(saved1, match.isNotNull);
      expect(saved1!.id, 1);
      expect(saved1.projectedAnnualAmount, statePensionValue1);

      final saved2 = await database.saveStatePension(statePensionValue2);
      expect(saved2, match.isNotNull);
      expect(saved2!.id, 1);
      expect(saved2.projectedAnnualAmount, statePensionValue2);

      final entry = await database.getStatePension();
      expect(entry, match.isNotNull);
      expect(entry!.id, 1);
      expect(entry.projectedAnnualAmount, statePensionValue2);
    });
  });
}
