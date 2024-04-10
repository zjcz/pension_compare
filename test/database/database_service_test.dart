import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:pension_compare/helpers/date_helper.dart';
import 'package:test/test.dart';
import 'package:matcher/matcher.dart' as match;

void main() {
  late DatabaseService database;

  setUp(() {
    final inMemory = DatabaseConnection(NativeDatabase.memory());
    database = DatabaseService(inMemory);
  });

  tearDown(() => database.close());

  group('Test data cleardown functionality', () {
    test('running cleardown removes all pensions and statements', () async {
      final pension =
          await database.createPension('test pension', DateHelper.getToday());
      await database.createStatement(pension!.pensionId, DateTime(2021, 1, 1),
          1000.0, 2000.0, 3000.0, 4000.0);
      await database.createStatement(pension.pensionId, DateTime(2022, 1, 1),
          1000.0, 2000.0, 3000.0, 4000.0);
      await database.createStatement(pension.pensionId, DateTime(2023, 1, 1),
          1000.0, 2000.0, 3000.0, 4000.0);
      await database.saveStatePension(12345.0);

      await database.clearAllData();

      final pensions = await database.getAllPensions();
      final statements =
          await database.getAllStatementsForPension(pension.pensionId);
      final statePension = await database.getStatePension();

      expect(pensions, match.isEmpty);
      expect(statements, match.isEmpty);
      expect(statePension, match.isNotNull);
      expect(statePension!.annualAmount, 0.0);
    });
  });
}
