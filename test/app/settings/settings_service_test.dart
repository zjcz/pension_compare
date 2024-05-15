import 'package:pension_compare/app/settings/models/user_settings.dart';
import 'package:pension_compare/app/settings/models/welcome_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:test/test.dart';
import 'package:matcher/matcher.dart' as match;

void main() {
  group('Test read/write settings', () {
    test('get the settings', () async {
      DateTime retirementDate = DateTime(2050, 2, 3);
      double targetIncome = 1234.56;
      bool acceptTermsAndConditions = true;
      bool acceptFinancialAdviceWarning = true;
      bool welcomeScreenDismissed = true;

      SharedPreferences.setMockInitialValues({
        'retirementDate': retirementDate.toIso8601String(),
        'targetIncome': targetIncome,
        'acceptTermsAndConditions': acceptTermsAndConditions,
        'acceptFinancialAdviceWarning': acceptFinancialAdviceWarning,
        'welcomeScreenDismissed': welcomeScreenDismissed
      });

      SettingsService settingsService = SettingsService();
      final settings = await settingsService.getAllSettings();
      expect(settings, match.isNotNull);
      expect(settings.retirementDate, retirementDate);
      expect(settings.targetIncome, targetIncome);
      expect(settings.acceptTermsAndConditions, acceptTermsAndConditions);
      expect(
          settings.acceptFinancialAdviceWarning, acceptFinancialAdviceWarning);
      expect(settings.welcomeScreenDismissed, welcomeScreenDismissed);
    });

    test('get the settings when not initialised', () async {
      SharedPreferences.setMockInitialValues({});

      SettingsService settingsService = SettingsService();
      final settings = await settingsService.getAllSettings();
      expect(settings, match.isNotNull);
      expect(settings.retirementDate, match.isNull);
      expect(settings.targetIncome, match.isNull);
      expect(settings.acceptTermsAndConditions, match.isNull);
      expect(settings.acceptFinancialAdviceWarning, match.isNull);
      expect(settings.welcomeScreenDismissed, match.isNull);
    });

    test('save the settings', () async {
      DateTime retirementDate = DateTime(2050, 2, 3);
      double targetIncome = 1234.56;
      bool acceptTermsAndConditions = true;
      bool acceptFinancialAdviceWarning = true;
      bool welcomeScreenDismissed = true;

      SharedPreferences.setMockInitialValues({});

      Settings settingsToSave = Settings(
          retirementDate: retirementDate,
          targetIncome: targetIncome,
          acceptTermsAndConditions: acceptTermsAndConditions,
          acceptFinancialAdviceWarning: acceptFinancialAdviceWarning,
          welcomeScreenDismissed: welcomeScreenDismissed);

      SettingsService settingsService = SettingsService();
      await settingsService.saveAllSettings(settingsToSave);

      final settings = await settingsService.getAllSettings();
      expect(settings, match.isNotNull);
      expect(settings.retirementDate, retirementDate);
      expect(settings.targetIncome, targetIncome);
      expect(settings.acceptTermsAndConditions, acceptTermsAndConditions);
      expect(
          settings.acceptFinancialAdviceWarning, acceptFinancialAdviceWarning);
      expect(settings.welcomeScreenDismissed, welcomeScreenDismissed);
    });

    test('save the user settings does lose welcome settings', () async {
      DateTime retirementDate = DateTime(2050, 2, 3);
      double targetIncome = 1234.56;
      bool acceptTermsAndConditions = true;
      bool acceptFinancialAdviceWarning = true;
      bool welcomeScreenDismissed = true;
      DateTime newRetirementDate = DateTime(2055, 8, 16);
      double newTargetIncome = 98765.43;

      SharedPreferences.setMockInitialValues({
        'retirementDate': retirementDate.toIso8601String(),
        'targetIncome': targetIncome,
        'acceptTermsAndConditions': acceptTermsAndConditions,
        'acceptFinancialAdviceWarning': acceptFinancialAdviceWarning,
        'welcomeScreenDismissed': welcomeScreenDismissed
      });

      UserSettings settingsToSave = UserSettings(
          retirementDate: newRetirementDate,
          targetIncome: newTargetIncome);

      SettingsService settingsService = SettingsService();
      await settingsService.saveUserSettings(settingsToSave);

      final settings = await settingsService.getAllSettings();
      expect(settings, match.isNotNull);
      expect(settings.retirementDate, newRetirementDate);
      expect(settings.targetIncome, newTargetIncome);
      expect(settings.acceptTermsAndConditions, acceptTermsAndConditions);
      expect(
          settings.acceptFinancialAdviceWarning, acceptFinancialAdviceWarning);
      expect(settings.welcomeScreenDismissed, welcomeScreenDismissed);
    });


    test('save the welcome settings does lose user settings', () async {
      DateTime retirementDate = DateTime(2050, 2, 3);
      double targetIncome = 1234.56;
      bool acceptTermsAndConditions = false;
      bool acceptFinancialAdviceWarning = false;
      bool welcomeScreenDismissed = false;
      bool newAcceptTermsAndConditions = true;
      bool newAcceptFinancialAdviceWarning = true;
      bool newWelcomeScreenDismissed = true;

      SharedPreferences.setMockInitialValues({
        'retirementDate': retirementDate.toIso8601String(),
        'targetIncome': targetIncome,
        'acceptTermsAndConditions': acceptTermsAndConditions,
        'acceptFinancialAdviceWarning': acceptFinancialAdviceWarning,
        'welcomeScreenDismissed': welcomeScreenDismissed
      });

      WelcomeSettings settingsToSave = WelcomeSettings(
          acceptTermsAndConditions: newAcceptTermsAndConditions,
          acceptFinancialAdviceWarning: newAcceptFinancialAdviceWarning,
          welcomeScreenDismissed: newWelcomeScreenDismissed);

      SettingsService settingsService = SettingsService();
      await settingsService.saveWelcomeSettings(settingsToSave);

      final settings = await settingsService.getAllSettings();
      expect(settings, match.isNotNull);
      expect(settings.retirementDate, retirementDate);
      expect(settings.targetIncome, targetIncome);
      expect(settings.acceptTermsAndConditions, newAcceptTermsAndConditions);
      expect(
          settings.acceptFinancialAdviceWarning, newAcceptFinancialAdviceWarning);
      expect(settings.welcomeScreenDismissed, newWelcomeScreenDismissed);
    });

    test('save the null settings', () async {
      DateTime initialRetirementDate = DateTime(2050, 2, 3);
      double initialTargetIncome = 1234.56;
      bool initialAcceptTermsAndConditions = true;
      bool initialAcceptFinancialAdviceWarning = true;
      bool initialWelcomeScreenDismissed = true;

      DateTime? newRetirementDate;
      double? newTargetIncome;
      bool? newAcceptTermsAndConditions;
      bool? newAcceptFinancialAdviceWarning;
      bool? newWelcomeScreenDismissed;

      SharedPreferences.setMockInitialValues({
        'retirementDate': initialRetirementDate.toIso8601String(),
        'targetIncome': initialTargetIncome,
        'acceptTermsAndConditions': initialAcceptTermsAndConditions,
        'acceptFinancialAdviceWarning': initialAcceptFinancialAdviceWarning,
        'welcomeScreenDismissed': initialWelcomeScreenDismissed
      });

      Settings settingsToSave = Settings(
          retirementDate: newRetirementDate,
          targetIncome: newTargetIncome,
          acceptTermsAndConditions: newAcceptTermsAndConditions,
          acceptFinancialAdviceWarning: newAcceptFinancialAdviceWarning,
          welcomeScreenDismissed: newWelcomeScreenDismissed);

      SettingsService settingsService = SettingsService();
      await settingsService.saveAllSettings(settingsToSave);

      final settings = await settingsService.getAllSettings();
      expect(settings, match.isNotNull);
      expect(settings.retirementDate, isNull);
      expect(settings.targetIncome, isNull);
      expect(settings.acceptTermsAndConditions, isNull);
      expect(settings.acceptFinancialAdviceWarning, isNull);
      expect(settings.welcomeScreenDismissed, isNull);
    });
  });
}
