import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:pension_compare/constants/defaults.dart';
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

  group('Test list of other incomes objects', () {    
    test('read all new pension objects', () async {
      double amount = 123.45;
      String notes = 'notes';

      await database.saveStatePension(amount, notes);

      final results = await database.getAllOtherIncomes().first;
      expect(results, match.isNotNull);
      expect(results.length, 1);
      expect(results[0].otherIncomeId, defaultStatePensionId);
      expect(results[0].name, defaultStatePensionName);
      expect(results[0].annualAmount, amount);
      expect(results[0].notes, notes);
    });

  });
}
