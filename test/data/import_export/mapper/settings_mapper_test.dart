import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/data/import_export/models/transfer_settings_model.dart';
import 'package:pension_compare/data/import_export/mapper/settings_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test settings transfer mapper', () {
    testWidgets('map settings to transfer object', (tester) async {
      bool acceptTermsAndConditions = true;
      bool acceptFinancialAdviceWarning = true;
      bool welcomeScreenDismissed = true;
      bool optIntoAnalyticsWarning = true;

      Settings settings = Settings(
          acceptTermsAndConditions: acceptTermsAndConditions,
          acceptFinancialAdviceWarning: acceptFinancialAdviceWarning,
          welcomeScreenDismissed: welcomeScreenDismissed,
          optIntoAnalyticsWarning: optIntoAnalyticsWarning);

      TransferSettingsModel settingsModel = SettingsMapper.toTransfer(settings);

      expect(settingsModel, isNotNull);
      expect(settingsModel.acceptTermsAndConditions, acceptTermsAndConditions);
      expect(settingsModel.acceptFinancialAdviceWarning, acceptFinancialAdviceWarning);
      expect(settingsModel.welcomeScreenDismissed, welcomeScreenDismissed);
      expect(settingsModel.optIntoAnalyticsWarning, optIntoAnalyticsWarning);
    });

    testWidgets('map transfer object to settings object', (tester) async {
      bool acceptTermsAndConditions = true;
      bool acceptFinancialAdviceWarning = true;
      bool welcomeScreenDismissed = true;
      bool optIntoAnalyticsWarning = true;

      TransferSettingsModel settingsModel = TransferSettingsModel(
          acceptTermsAndConditions: acceptTermsAndConditions,
          acceptFinancialAdviceWarning: acceptFinancialAdviceWarning,
          welcomeScreenDismissed: welcomeScreenDismissed,
          optIntoAnalyticsWarning: optIntoAnalyticsWarning);

      Settings settings = SettingsMapper.fromTransfer(settingsModel);

      expect(settings, isNotNull);
      expect(settings.acceptTermsAndConditions, acceptTermsAndConditions);
      expect(settings.acceptFinancialAdviceWarning, acceptFinancialAdviceWarning);
      expect(settings.welcomeScreenDismissed, welcomeScreenDismissed);
      expect(settings.optIntoAnalyticsWarning, optIntoAnalyticsWarning);
    });

    testWidgets('map to transfer and back again', (tester) async {
      bool acceptTermsAndConditions = true;
      bool acceptFinancialAdviceWarning = true;
      bool welcomeScreenDismissed = true;
      bool optIntoAnalyticsWarning = true;

      Settings settings = Settings(
          acceptTermsAndConditions: acceptTermsAndConditions,
          acceptFinancialAdviceWarning: acceptFinancialAdviceWarning,
          welcomeScreenDismissed: welcomeScreenDismissed,
          optIntoAnalyticsWarning: optIntoAnalyticsWarning
          );

      TransferSettingsModel settingsModel = SettingsMapper.toTransfer(settings);

      Settings resultSettings = SettingsMapper.fromTransfer(settingsModel);

      expect(resultSettings, isNotNull);
      expect(resultSettings.acceptTermsAndConditions, acceptTermsAndConditions);
      expect(resultSettings.acceptFinancialAdviceWarning, acceptFinancialAdviceWarning);
      expect(resultSettings.welcomeScreenDismissed, welcomeScreenDismissed);
      expect(resultSettings.optIntoAnalyticsWarning, optIntoAnalyticsWarning);
    });
  });
}
