import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pension_compare/constants/defaults.dart' as defaults;
import 'package:pension_compare/app/settings/controllers/secure_settings_controller.dart';
import 'package:pension_compare/app/settings/models/secure_settings_model.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'secure_settings_controller_test.mocks.dart';

@GenerateMocks([DatabaseService])
void main() {
  group('Test secure settings controller', () {
    testWidgets('get the records', (tester) async {
      double targetAmount = 123.45;
      DateTime retirementDate = DateTime(2022, 12, 31);

      final databaseService = MockDatabaseService();
      when(databaseService.getSecureSettings()).thenAnswer(
        (_) => Stream.value(
          SecureSettings(
              secureSettingsId: defaults.defaultSecureSettingsId,
              targetIncome: targetAmount,
              retirementDate: retirementDate),
        ),
      );

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);

      final secureSettings =
          await container.read(secureSettingsControllerProvider.future);

      expect(secureSettings.targetIncome, targetAmount);
      expect(secureSettings.retirementDate, retirementDate);
      verify(databaseService.getSecureSettings()).called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });

    testWidgets('save settings', (tester) async {
      double targetAmount = 123.45;
      DateTime retirementDate = DateTime(2022, 12, 31);

      final databaseService = MockDatabaseService();
      when(databaseService.saveSecureSettings(targetAmount, retirementDate))
          .thenAnswer(
        (_) async => SecureSettings(
            secureSettingsId: defaults.defaultSecureSettingsId,
            targetIncome: targetAmount,
            retirementDate: retirementDate),
      );

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);
      final provider =
          container.read(secureSettingsControllerProvider.notifier);
      SecureSettingsModel savedSettings =
          await provider.saveSecureSettings(targetAmount, retirementDate);

      expect(savedSettings.targetIncome, targetAmount);
      expect(savedSettings.retirementDate, retirementDate);
      verify(databaseService.saveSecureSettings(targetAmount, retirementDate))
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
