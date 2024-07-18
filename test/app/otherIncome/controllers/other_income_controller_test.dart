import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pension_compare/app/otherIncome/controllers/other_income_controller.dart';
import 'package:pension_compare/app/otherIncome/models/other_income_model.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'other_income_controller_test.mocks.dart';

@GenerateMocks([DatabaseService])
void main() {
  group('Test other income controller', () {
    testWidgets('get the records', (tester) async {
      int otherIncomeId = 1;
      String name = 'state pension';
      double amount = 123.45;
      final databaseService = MockDatabaseService();
      when(databaseService.getAllOtherIncomes()).thenAnswer((_) => Stream.value(
          [OtherIncome(
              otherIncomeId: otherIncomeId, name: name, annualAmount: amount)]));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);

      final otherIncomeList =
          await container.read(otherIncomeControllerProvider.future);

      expect(otherIncomeList, isNotNull);
      expect(otherIncomeList.length, 1);
      expect(otherIncomeList[0].otherIncomeId, otherIncomeId);
      expect(otherIncomeList[0].name, name);
      expect(otherIncomeList[0].annualAmount, amount);
      verify(databaseService.getAllOtherIncomes()).called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('get the records, handle empty dataset', (tester) async {
      // unlikely to happen as there will always be one record for state pension, but just in case
      final databaseService = MockDatabaseService();
      when(databaseService.getAllOtherIncomes())
          .thenAnswer((_) => Stream.value([]));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);

      final otherIncomeList =
          await container.read(otherIncomeControllerProvider.future);

      expect(otherIncomeList, isNotNull);
      expect(otherIncomeList.length, 0);
      verify(databaseService.getAllOtherIncomes()).called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('get state pension record', (tester) async {
      int otherIncomeId = 1;
      String name = 'state pension';
      double amount = 123.45;
      final databaseService = MockDatabaseService();
      when(databaseService.getStatePension()).thenAnswer((_) async =>
          (OtherIncome(
              otherIncomeId: otherIncomeId, name: name, annualAmount: amount)));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);

      final provider = container.read(otherIncomeControllerProvider.notifier);
      OtherIncomeModel? otherIncome = await provider.getStatePension();

      expect(otherIncome, isNotNull);
      expect(otherIncome!.otherIncomeId, isNotNull);
      expect(otherIncome.name, name);
      expect(otherIncome.annualAmount, amount);
      verify(databaseService.getStatePension()).called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('get state pension records, handle null', (tester) async {
      final databaseService = MockDatabaseService();
      when(databaseService.getStatePension()).thenAnswer((_) async => (null));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);

      final provider = container.read(otherIncomeControllerProvider.notifier);
      OtherIncomeModel? otherIncome = await provider.getStatePension();

      expect(otherIncome, isNull);
      verify(databaseService.getStatePension()).called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('save state pension records', (tester) async {
      double amount = 123.45;
      final databaseService = MockDatabaseService();
      when(databaseService.saveStatePension(amount, null))
          .thenAnswer((_) async => (null));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);

      final provider = container.read(otherIncomeControllerProvider.notifier);
      await provider.updateStatePension(amount);

      verify(databaseService.saveStatePension(amount, null)).called(1);

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
