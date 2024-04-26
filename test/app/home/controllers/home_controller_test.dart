import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pension_compare/app/home/controllers/home_controller.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/data/database/tables/pensions_with_latest_statement.dart';

import 'home_controller_test.mocks.dart';

@GenerateMocks([DatabaseService])
void main() {
  group('Test home controller', () {
    testWidgets('get the records', (tester) async {
      int pensionId = 1;
      String pensionName = 'new pension';
      final databaseService = MockDatabaseService();
      when(databaseService.getAllPensionsWithLatestStatement())
          .thenAnswer((_) => Stream.value([
                PensionWithLatestStatement(
                    Pension(
                        pensionId: pensionId,
                        name: pensionName,
                        maturityDate: DateTime.now()),
                    null)
              ]));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);

      final pensionList = await container.read(homeControllerProvider.future);

      expect(pensionList, isNotNull);
      expect(pensionList.length, 1);
      expect(pensionList[0].pension, isNotNull);
      expect(pensionList[0].pension.pensionId, pensionId);
      expect(pensionList[0].pension.name, pensionName);
      verify(databaseService.getAllPensionsWithLatestStatement()).called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('populate test data', (tester) async {
      final databaseService = MockDatabaseService();
      when(databaseService.populateTestData())
          .thenAnswer((_) => Future.value());

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);
      final provider = container.read(homeControllerProvider.notifier);
      await provider.populateTestData();

      verify(databaseService.populateTestData()).called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('test clear all data', (tester) async {
      final databaseService = MockDatabaseService();
      when(databaseService.clearAllData()).thenAnswer((_) => Future.value());

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);
      final provider = container.read(homeControllerProvider.notifier);
      await provider.clearAllData();

      verify(databaseService.clearAllData()).called(1);

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
