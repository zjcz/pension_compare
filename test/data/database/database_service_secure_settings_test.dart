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

  group('Test secure settings object', () {
    test('secure settings object created at startup', () async {
      final entry = await database.getSecureSettings();

      expect(entry, match.isNotNull);
      expect(entry.secureSettingsId, defaults.defaultSecureSettingsId);
      expect(entry.targetIncome, match.isNull);
    });

    test('read the secure settings object after save', () async {
      double targetIncomeValue = 123.45;
      DateTime retirementDate = DateTime(2050, 5, 6);
      await database.saveSecureSettings(targetIncomeValue, retirementDate);
      final entry = await database.getSecureSettings();

      expect(entry, match.isNotNull);
      expect(entry.secureSettingsId, defaults.defaultSecureSettingsId);
      expect(entry.targetIncome, targetIncomeValue);
      expect(entry.retirementDate, retirementDate);
    });

    test('update the secure settings object', () async {
      double targetIncomeValue1 = 123.45;
      DateTime retirementDate1 = DateTime(2020, 1, 2);
      double targetIncomeValue2 = 678.90;
      DateTime retirementDate2 = DateTime(2022, 3, 4);

      final saved1 = await database.saveSecureSettings(targetIncomeValue1, retirementDate1);
      expect(saved1, match.isNotNull);
      expect(saved1.secureSettingsId, defaults.defaultSecureSettingsId);
      expect(saved1.targetIncome, targetIncomeValue1);
      expect(saved1.retirementDate, retirementDate1);

      final saved2 = await database.saveSecureSettings(targetIncomeValue2, retirementDate2);
      expect(saved2, match.isNotNull);
      expect(saved2.secureSettingsId, defaults.defaultSecureSettingsId);
      expect(saved2.targetIncome, targetIncomeValue2);
      expect(saved2.retirementDate, retirementDate2);

      final entry = await database.getSecureSettings();
      expect(entry, match.isNotNull);
      expect(entry.secureSettingsId, defaults.defaultSecureSettingsId);
      expect(entry.targetIncome, targetIncomeValue2);
      expect(entry.retirementDate, retirementDate2);
    });
  });
}
