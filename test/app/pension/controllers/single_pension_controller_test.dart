import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pension_compare/app/pension/controllers/single_pension_controller.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'single_pension_controller_test.mocks.dart';

@GenerateMocks([DatabaseService])
void main() {
  group('Test single pension controller', () {
    testWidgets('get the records', (tester) async {
      int pensionId = 1;
      String pensionName = 'new pension';
      DateTime maturityDate = DateTime.now();
      final databaseService = MockDatabaseService();
      when(databaseService.watchPension(pensionId))
          .thenAnswer((_) => Stream.value(
                Pension(
                    pensionId: pensionId,
                    name: pensionName,
                    maturityDate: maturityDate),
              ));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);

      final pension = await container
          .read(singlePensionControllerProvider(pensionId).future);

      expect(pension, isNotNull);
      expect(pension!.pensionId, pensionId);
      expect(pension.name, pensionName);
      expect(pension.maturityDate, maturityDate);
      verify(databaseService.watchPension(pensionId)).called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('get the records, handle empty dataset', (tester) async {
      int pensionId = 1;
      final databaseService = MockDatabaseService();
      when(databaseService.watchPension(pensionId))
          .thenAnswer((_) => Stream.value(null));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);

      final pension = await container
          .read(singlePensionControllerProvider(pensionId).future);

      expect(pension, isNull);
      verify(databaseService.watchPension(pensionId)).called(1);

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
