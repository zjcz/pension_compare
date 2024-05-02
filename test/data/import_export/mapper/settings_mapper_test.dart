import 'package:pension_compare/app/settings/settings.dart';
import 'package:pension_compare/data/import_export/models/transfer_settings_model.dart';
import 'package:pension_compare/data/import_export/mapper/settings_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test settings transfer mapper', () {
    testWidgets('map settings to transfer object', (tester) async {
      DateTime retirementDate = DateTime.now();
      double targetIncome = 123.45;
      Settings settings =
          Settings(retirementDate: retirementDate, targetIncome: targetIncome);

      TransferSettingsModel settingsModel = SettingsMapper.toTransfer(settings);

      expect(settingsModel, isNotNull);
      expect(settingsModel.retirementDate, retirementDate);
      expect(settingsModel.targetIncome, targetIncome);
    });

    testWidgets('map transfer object to settings object', (tester) async {
      DateTime retirementDate = DateTime.now();
      double targetIncome = 123.45;
      TransferSettingsModel settings = TransferSettingsModel(
          retirementDate: retirementDate, targetIncome: targetIncome);

      Settings settingsModel = SettingsMapper.fromTransfer(settings);

      expect(settingsModel, isNotNull);
      expect(settingsModel.retirementDate, retirementDate);
      expect(settingsModel.targetIncome, targetIncome);
    });

    testWidgets('map to transfer and back again', (tester) async {
      DateTime retirementDate = DateTime.now();
      double targetIncome = 123.45;
      Settings settings =
          Settings(retirementDate: retirementDate, targetIncome: targetIncome);

      TransferSettingsModel settingsModel = SettingsMapper.toTransfer(settings);

      Settings resultSettings = SettingsMapper.fromTransfer(settingsModel);

      expect(resultSettings, isNotNull);
      expect(resultSettings.retirementDate, settings.retirementDate);
      expect(resultSettings.targetIncome, settings.targetIncome);
    });
  });
}
