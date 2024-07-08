import 'package:pension_compare/constants/defaults.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/data/import_export/mapper/secure_settings_mapper.dart';
import 'package:pension_compare/data/import_export/models/transfer_secure_settings_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test secure settings transfer mapper', () {
    testWidgets('map secure settings to transfer object', (tester) async {
      DateTime retirementDate = DateTime.now();
      double targetIncome = 123.45;

      SecureSettings settings = SecureSettings(
        secureSettingsId: defaultSecureSettingsId,
        retirementDate: retirementDate,
        targetIncome: targetIncome,
      );

      TransferSecureSettingsModel settingsModel =
          SecureSettingsMapper.toTransfer(settings);

      expect(settingsModel, isNotNull);
      expect(settingsModel.retirementDate, retirementDate);
      expect(settingsModel.targetIncome, targetIncome);
    });

    testWidgets('map transfer object to settings object', (tester) async {
      DateTime retirementDate = DateTime.now();
      double targetIncome = 123.45;

      TransferSecureSettingsModel settingsModel = TransferSecureSettingsModel(
          retirementDate: retirementDate, targetIncome: targetIncome);

      SecureSettings settings =
          SecureSettingsMapper.fromTransfer(settingsModel);

      expect(settings, isNotNull);
      expect(settings.retirementDate, retirementDate);
      expect(settings.targetIncome, targetIncome);
    });

    testWidgets('map to transfer and back again', (tester) async {
      DateTime retirementDate = DateTime.now();
      double targetIncome = 123.45;

      SecureSettings settings = SecureSettings(
          secureSettingsId: defaultSecureSettingsId,
          retirementDate: retirementDate,
          targetIncome: targetIncome);

      TransferSecureSettingsModel settingsModel =
          SecureSettingsMapper.toTransfer(settings);

      SecureSettings resultSettings =
          SecureSettingsMapper.fromTransfer(settingsModel);

      expect(resultSettings, isNotNull);
      expect(resultSettings.retirementDate, settings.retirementDate);
      expect(resultSettings.targetIncome, settings.targetIncome);
    });
  });
}
