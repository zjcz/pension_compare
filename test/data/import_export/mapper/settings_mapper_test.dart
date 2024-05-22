import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/data/import_export/models/transfer_settings_model.dart';
import 'package:pension_compare/data/import_export/mapper/settings_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test settings transfer mapper', () {
    testWidgets('map settings to transfer object', (tester) async {
      DateTime retirementDate = DateTime.now();
      double targetIncome = 123.45;
      bool acceptTermsAndConditions = true;
      bool acceptFinancialAdviceWarning = true;
      bool welcomeScreenDismissed = true;
      bool optIntoAnalyticsWarning = true;

      Settings settings = Settings(
          retirementDate: retirementDate,
          targetIncome: targetIncome,
          acceptTermsAndConditions: acceptTermsAndConditions,
          acceptFinancialAdviceWarning: acceptFinancialAdviceWarning,
          welcomeScreenDismissed: welcomeScreenDismissed,
          optIntoAnalyticsWarning: optIntoAnalyticsWarning);

      TransferSettingsModel settingsModel = SettingsMapper.toTransfer(settings);

      expect(settingsModel, isNotNull);
      expect(settingsModel.retirementDate, retirementDate);
      expect(settingsModel.targetIncome, targetIncome);
    });

    testWidgets('map transfer object to settings object', (tester) async {
      DateTime retirementDate = DateTime.now();
      double targetIncome = 123.45;
      bool acceptTermsAndConditions = true;
      bool acceptFinancialAdviceWarning = true;
      bool welcomeScreenDismissed = true;
      bool optIntoAnalyticsWarning = true;

      TransferSettingsModel settings = TransferSettingsModel(
          retirementDate: retirementDate,
          targetIncome: targetIncome,
          acceptTermsAndConditions: acceptTermsAndConditions,
          acceptFinancialAdviceWarning: acceptFinancialAdviceWarning,
          welcomeScreenDismissed: welcomeScreenDismissed,
          optIntoAnalyticsWarning: optIntoAnalyticsWarning);

      Settings settingsModel = SettingsMapper.fromTransfer(settings);

      expect(settingsModel, isNotNull);
      expect(settingsModel.retirementDate, retirementDate);
      expect(settingsModel.targetIncome, targetIncome);
    });

    testWidgets('map to transfer and back again', (tester) async {
      DateTime retirementDate = DateTime.now();
      double targetIncome = 123.45;
      bool acceptTermsAndConditions = true;
      bool acceptFinancialAdviceWarning = true;
      bool welcomeScreenDismissed = true;
      bool optIntoAnalyticsWarning = true;

      Settings settings = Settings(
          retirementDate: retirementDate,
          targetIncome: targetIncome,
          acceptTermsAndConditions: acceptTermsAndConditions,
          acceptFinancialAdviceWarning: acceptFinancialAdviceWarning,
          welcomeScreenDismissed: welcomeScreenDismissed,
          optIntoAnalyticsWarning: optIntoAnalyticsWarning
          );

      TransferSettingsModel settingsModel = SettingsMapper.toTransfer(settings);

      Settings resultSettings = SettingsMapper.fromTransfer(settingsModel);

      expect(resultSettings, isNotNull);
      expect(resultSettings.retirementDate, settings.retirementDate);
      expect(resultSettings.targetIncome, settings.targetIncome);
    });
  });
}
