import 'package:shared_preferences/shared_preferences.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:test/test.dart';
import 'package:matcher/matcher.dart' as match;

void main() {
  group('Test read/write settings', () {
    test('get the settings', () async {
      bool acceptTermsAndConditions = true;
      bool acceptFinancialAdviceWarning = true;
      bool welcomeScreenDismissed = true;
      bool optIntoAnalyticsWarning = true;

      SharedPreferences.setMockInitialValues({
        'acceptTermsAndConditions': acceptTermsAndConditions,
        'acceptFinancialAdviceWarning': acceptFinancialAdviceWarning,
        'welcomeScreenDismissed': welcomeScreenDismissed,
        'optIntoAnalyticsWarning': optIntoAnalyticsWarning
      });

      SettingsService settingsService = SettingsService();
      final settings = await settingsService.getAllSettings();
      expect(settings, match.isNotNull);
      expect(settings.acceptTermsAndConditions, acceptTermsAndConditions);
      expect(
          settings.acceptFinancialAdviceWarning, acceptFinancialAdviceWarning);
      expect(settings.welcomeScreenDismissed, welcomeScreenDismissed);
      expect(settings.optIntoAnalyticsWarning, optIntoAnalyticsWarning);
    });

    test('get the settings when not initialised', () async {
      SharedPreferences.setMockInitialValues({});

      SettingsService settingsService = SettingsService();
      final settings = await settingsService.getAllSettings();
      expect(settings, match.isNotNull);
      expect(settings.acceptTermsAndConditions, match.isNull);
      expect(settings.acceptFinancialAdviceWarning, match.isNull);
      expect(settings.welcomeScreenDismissed, match.isNull);
      expect(settings.optIntoAnalyticsWarning, isFalse);
    });

    test('save the settings', () async {
      bool acceptTermsAndConditions = true;
      bool acceptFinancialAdviceWarning = true;
      bool welcomeScreenDismissed = true;
      bool optIntoAnalyticsWarning = true;

      SharedPreferences.setMockInitialValues({});

      Settings settingsToSave = Settings(
          acceptTermsAndConditions: acceptTermsAndConditions,
          acceptFinancialAdviceWarning: acceptFinancialAdviceWarning,
          welcomeScreenDismissed: welcomeScreenDismissed,
          optIntoAnalyticsWarning: optIntoAnalyticsWarning);

      SettingsService settingsService = SettingsService();
      await settingsService.saveAllSettings(settingsToSave);

      final settings = await settingsService.getAllSettings();
      expect(settings, match.isNotNull);
      expect(settings.acceptTermsAndConditions, acceptTermsAndConditions);
      expect(
          settings.acceptFinancialAdviceWarning, acceptFinancialAdviceWarning);
      expect(settings.welcomeScreenDismissed, welcomeScreenDismissed);
      expect(optIntoAnalyticsWarning, optIntoAnalyticsWarning);
    });

    test('save the analytics settings does lose welcome settings', () async {
      bool acceptTermsAndConditions = true;
      bool acceptFinancialAdviceWarning = true;
      bool welcomeScreenDismissed = true;
      bool optIntoAnalyticsWarning = true;
      bool newOptIntoAnalyticsWarning = false;

      SharedPreferences.setMockInitialValues({
        'acceptTermsAndConditions': acceptTermsAndConditions,
        'acceptFinancialAdviceWarning': acceptFinancialAdviceWarning,
        'welcomeScreenDismissed': welcomeScreenDismissed,
        'optIntoAnalyticsWarning': optIntoAnalyticsWarning
      });

      SettingsService settingsService = SettingsService();
      await settingsService.saveAnalyticsSettings(newOptIntoAnalyticsWarning);

      final settings = await settingsService.getAllSettings();
      expect(settings, match.isNotNull);
      expect(settings.acceptTermsAndConditions, acceptTermsAndConditions);
      expect(
          settings.acceptFinancialAdviceWarning, acceptFinancialAdviceWarning);
      expect(settings.welcomeScreenDismissed, welcomeScreenDismissed);
      expect(settings.optIntoAnalyticsWarning, newOptIntoAnalyticsWarning);
    });


    test('save the welcome screen dismissed settings does lose welcome settings', () async {
      bool acceptTermsAndConditions = true;
      bool acceptFinancialAdviceWarning = true;
      bool welcomeScreenDismissed = false;
      bool optIntoAnalyticsWarning = true;
      bool newWelcomeScreenDismissed = true;

      SharedPreferences.setMockInitialValues({
        'acceptTermsAndConditions': acceptTermsAndConditions,
        'acceptFinancialAdviceWarning': acceptFinancialAdviceWarning,
        'welcomeScreenDismissed': welcomeScreenDismissed,
        'optIntoAnalyticsWarning': optIntoAnalyticsWarning
      });

      SettingsService settingsService = SettingsService();
      await settingsService.saveWelcomeScreenDismissed(newWelcomeScreenDismissed);

      final settings = await settingsService.getAllSettings();
      expect(settings, match.isNotNull);
      expect(settings.acceptTermsAndConditions, acceptTermsAndConditions);
      expect(
          settings.acceptFinancialAdviceWarning, acceptFinancialAdviceWarning);
      expect(settings.welcomeScreenDismissed, newWelcomeScreenDismissed);
      expect(settings.optIntoAnalyticsWarning, optIntoAnalyticsWarning);
    });

    test('save the null settings', () async {
      bool initialAcceptTermsAndConditions = true;
      bool initialAcceptFinancialAdviceWarning = true;
      bool initialWelcomeScreenDismissed = true;
      bool initialOptIntoAnalyticsWarning = true;

      bool? newAcceptTermsAndConditions;
      bool? newAcceptFinancialAdviceWarning;
      bool? newWelcomeScreenDismissed;
      bool newOptIntoAnalyticsWarning = false; // cannot be null

      SharedPreferences.setMockInitialValues({
        'acceptTermsAndConditions': initialAcceptTermsAndConditions,
        'acceptFinancialAdviceWarning': initialAcceptFinancialAdviceWarning,
        'welcomeScreenDismissed': initialWelcomeScreenDismissed,
        'optIntoAnalyticsWarning': initialOptIntoAnalyticsWarning
      });

      Settings settingsToSave = Settings(
          acceptTermsAndConditions: newAcceptTermsAndConditions,
          acceptFinancialAdviceWarning: newAcceptFinancialAdviceWarning,
          welcomeScreenDismissed: newWelcomeScreenDismissed,
          optIntoAnalyticsWarning: newOptIntoAnalyticsWarning);

      SettingsService settingsService = SettingsService();
      await settingsService.saveAllSettings(settingsToSave);

      final settings = await settingsService.getAllSettings();
      expect(settings, match.isNotNull);
      expect(settings.acceptTermsAndConditions, isNull);
      expect(settings.acceptFinancialAdviceWarning, isNull);
      expect(settings.welcomeScreenDismissed, isNull);
      expect(settings.optIntoAnalyticsWarning, isFalse);
    });
  });
}
