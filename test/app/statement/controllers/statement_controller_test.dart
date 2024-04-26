import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pension_compare/app/statement/controllers/statement_controller.dart';
import 'package:pension_compare/app/statement/models/statement_model.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'statement_controller_test.mocks.dart';

@GenerateMocks([DatabaseService])
void main() {
  group('Test statement controller', () {
    testWidgets('get the records', (tester) async {
      int pensionId = 1;
      int statementId = 5;
      DateTime statementDate = DateTime.now();
      double planValue = 123.45;
      double projectedAnnualAmount = 678.90;
      double yearlyCharges = 987.65;
      double transferValue = 432.10;

      final databaseService = MockDatabaseService();
      when(databaseService.getAllStatementsForPension(pensionId))
          .thenAnswer((_) => Stream.value([
                Statement(
                  statementId: statementId,
                  pension: pensionId,
                  statementDate: statementDate,
                  planValue: planValue,
                  projectedAnnualAmount: projectedAnnualAmount,
                  yearlyCharges: yearlyCharges,
                  transferValue: transferValue,
                ),
              ]));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);

      final statementList =
          await container.read(statementControllerProvider(pensionId).future);

      expect(statementList, isNotNull);
      expect(statementList.length, 1);
      expect(statementList[0].statementId, statementId);
      expect(statementList[0].pension, pensionId);
      expect(statementList[0].statementDate, statementDate);
      expect(statementList[0].planValue, planValue);
      expect(statementList[0].projectedAnnualAmount, projectedAnnualAmount);
      expect(statementList[0].yearlyCharges, yearlyCharges);
      expect(statementList[0].transferValue, transferValue);
      verify(databaseService.getAllStatementsForPension(pensionId)).called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('get the records, handle empty dataset', (tester) async {
      int pensionId = 1;
      final databaseService = MockDatabaseService();
      when(databaseService.getAllStatementsForPension(pensionId))
          .thenAnswer((_) => Stream.value([]));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);

      final statementList =
          await container.read(statementControllerProvider(pensionId).future);

      expect(statementList, isNotNull);
      expect(statementList.length, 0);
      verify(databaseService.getAllStatementsForPension(pensionId)).called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('add new statement', (tester) async {
      int pensionId = 1;
      int statementId = 5;
      DateTime statementDate = DateTime.now();
      double planValue = 123.45;
      double projectedAnnualAmount = 678.90;
      double yearlyCharges = 987.65;
      double transferValue = 432.10;
      final databaseService = MockDatabaseService();
      when(databaseService.createStatement(pensionId, statementDate, planValue,
              projectedAnnualAmount, yearlyCharges, transferValue))
          .thenAnswer(
        (_) async => Statement(
          statementId: statementId,
          pension: pensionId,
          statementDate: statementDate,
          planValue: planValue,
          projectedAnnualAmount: projectedAnnualAmount,
          yearlyCharges: yearlyCharges,
          transferValue: transferValue,
        ),
      );

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);
      final provider =
          container.read(statementControllerProvider(pensionId).notifier);
      StatementModel? savedStatement = await provider.createStatement(
          pensionId,
          statementDate,
          planValue,
          projectedAnnualAmount,
          yearlyCharges,
          transferValue);

      expect(savedStatement, isNotNull);
      expect(savedStatement!.statementId, statementId);
      expect(savedStatement.pension, pensionId);
      expect(savedStatement.statementDate, statementDate);
      expect(savedStatement.planValue, planValue);
      expect(savedStatement.projectedAnnualAmount, projectedAnnualAmount);
      expect(savedStatement.yearlyCharges, yearlyCharges);
      expect(savedStatement.transferValue, transferValue);
      verify(databaseService.createStatement(pensionId, statementDate,
              planValue, projectedAnnualAmount, yearlyCharges, transferValue))
          .called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('update existing statement', (tester) async {
      int pensionId = 1;
      int statementId = 5;
      DateTime statementDate = DateTime.now();
      double planValue = 123.45;
      double projectedAnnualAmount = 678.90;
      double yearlyCharges = 987.65;
      double transferValue = 432.10;
      final databaseService = MockDatabaseService();
      when(databaseService.updateStatement(
              statementId,
              pensionId,
              statementDate,
              planValue,
              projectedAnnualAmount,
              yearlyCharges,
              transferValue))
          .thenAnswer((_) async => true);

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);
      final provider =
          container.read(statementControllerProvider(pensionId).notifier);
      bool result = await provider.updateStatement(
          statementId,
          pensionId,
          statementDate,
          planValue,
          projectedAnnualAmount,
          yearlyCharges,
          transferValue);

      expect(result, isTrue);
      verify(databaseService.updateStatement(
              statementId,
              pensionId,
              statementDate,
              planValue,
              projectedAnnualAmount,
              yearlyCharges,
              transferValue))
          .called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('delete existing statement', (tester) async {
      int pensionId = 1;
      int statementId = 5;

      final databaseService = MockDatabaseService();
      when(databaseService.deleteStatement(statementId))
          .thenAnswer((_) async => statementId);

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);
      final provider =
          container.read(statementControllerProvider(pensionId).notifier);
      int result = await provider.deleteStatement(statementId);

      expect(result, statementId);
      verify(databaseService.deleteStatement(statementId)).called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('does statement date exist', (tester) async {
      int statementId = 1;
      int pensionId = 5;
      DateTime statementDate = DateTime.now();
      final databaseService = MockDatabaseService();
      when(databaseService.doesStatementDateExist(
              statementId, pensionId, statementDate))
          .thenAnswer((_) async => true);

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);
      final provider =
          container.read(statementControllerProvider(pensionId).notifier);
      bool result = await provider.doesStatementDateExist(
          statementId, pensionId, statementDate);

      expect(result, isTrue);
      verify(databaseService.doesStatementDateExist(
              statementId, pensionId, statementDate))
          .called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });
  });
}

/// A testing utility which creates a [ProviderContainer] and automatically
/// disposes it at the end of the test.
/// Taken from https://riverpod.dev/docs/essentials/testing
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Create a ProviderContainer, and optionally allow specifying parameters.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // When the test ends, dispose the container.
  addTearDown(container.dispose);

  return container;
}
