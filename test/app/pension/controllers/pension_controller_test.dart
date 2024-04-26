import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pension_compare/app/pension/controllers/pension_controller.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'pension_controller_test.mocks.dart';

@GenerateMocks([DatabaseService])
void main() {
  group('Test pension controller', () {
    testWidgets('get the records', (tester) async {
      int pensionId = 1;
      String pensionName = 'new pension';
      DateTime maturityDate = DateTime.now();
      final databaseService = MockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) => Stream.value([
            Pension(
                pensionId: pensionId,
                name: pensionName,
                maturityDate: maturityDate),
          ]));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);

      final pensionList =
          await container.read(pensionControllerProvider.future);

      expect(pensionList, isNotNull);
      expect(pensionList.length, 1);
      expect(pensionList[0].pensionId, pensionId);
      expect(pensionList[0].name, pensionName);
      expect(pensionList[0].maturityDate, maturityDate);
      verify(databaseService.getAllPensions()).called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('get the records, handle empty dataset', (tester) async {
      final databaseService = MockDatabaseService();
      when(databaseService.getAllPensions())
          .thenAnswer((_) => Stream.value([]));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);

      final pensionList =
          await container.read(pensionControllerProvider.future);

      expect(pensionList, isNotNull);
      expect(pensionList.length, 0);
      verify(databaseService.getAllPensions()).called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('add new pension', (tester) async {
      int pensionId = 1;
      String pensionName = 'new pension';
      DateTime maturityDate = DateTime.now();
      final databaseService = MockDatabaseService();
      when(databaseService.createPension(pensionName, maturityDate)).thenAnswer(
        (_) async => Pension(
            pensionId: pensionId,
            name: pensionName,
            maturityDate: maturityDate),
      );

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);
      final provider = container.read(pensionControllerProvider.notifier);
      PensionModel? savedPension =
          await provider.createPension(pensionName, maturityDate);

      expect(savedPension, isNotNull);
      expect(savedPension!.pensionId, pensionId);
      expect(savedPension.name, pensionName);
      expect(savedPension.maturityDate, maturityDate);
      verify(databaseService.createPension(pensionName, maturityDate))
          .called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('update existing pension', (tester) async {
      int pensionId = 1;
      String pensionName = 'existing pension';
      DateTime maturityDate = DateTime.now();
      final databaseService = MockDatabaseService();
      when(databaseService.updatePension(pensionId, pensionName, maturityDate))
          .thenAnswer((_) async => true);

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);
      final provider = container.read(pensionControllerProvider.notifier);
      bool result =
          await provider.updatePension(pensionId, pensionName, maturityDate);

      expect(result, isTrue);
      verify(databaseService.updatePension(
              pensionId, pensionName, maturityDate))
          .called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('delete existing pension', (tester) async {
      int pensionId = 1;
      final databaseService = MockDatabaseService();
      when(databaseService.deletePension(pensionId))
          .thenAnswer((_) async => pensionId);

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);
      final provider = container.read(pensionControllerProvider.notifier);
      int result = await provider.deletePension(pensionId);

      expect(result, pensionId);
      verify(databaseService.deletePension(pensionId)).called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('does pension name exist', (tester) async {
      int pensionId = 1;
      String name = 'pension name';
      final databaseService = MockDatabaseService();
      when(databaseService.doesPensionNameExist(pensionId, name))
          .thenAnswer((_) async => true);

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);
      final provider = container.read(pensionControllerProvider.notifier);
      bool result = await provider.doesPensionNameExist(pensionId, name);

      expect(result, isTrue);
      verify(databaseService.doesPensionNameExist(pensionId, name)).called(1);

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
