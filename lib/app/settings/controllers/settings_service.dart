import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  final String _keyAcceptTermsAndConditions = 'acceptTermsAndConditions';
  final String _keyAcceptFinancialAdviceWarning =
      'acceptFinancialAdviceWarning';
  final String _keyWelcomeScreenDismissed = 'welcomeScreenDismissed';
  final String _keyOptIntoAnalyticsWarning = 'optIntoAnalyticsWarning';

  Future<Settings> getAllSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return Settings(
      acceptTermsAndConditions: prefs.getBool(_keyAcceptTermsAndConditions),
      acceptFinancialAdviceWarning:
          prefs.getBool(_keyAcceptFinancialAdviceWarning),
      welcomeScreenDismissed: prefs.getBool(_keyWelcomeScreenDismissed),
      optIntoAnalyticsWarning:
          prefs.getBool(_keyOptIntoAnalyticsWarning) ?? false,
    );
  }

  Future<void> saveAllSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();

    if (settings.acceptTermsAndConditions != null) {
      await prefs.setBool(_keyAcceptTermsAndConditions,
          settings.acceptTermsAndConditions ?? false);
    } else {
      await prefs.remove(_keyAcceptTermsAndConditions);
    }

    if (settings.acceptFinancialAdviceWarning != null) {
      await prefs.setBool(_keyAcceptFinancialAdviceWarning,
          settings.acceptFinancialAdviceWarning ?? false);
    } else {
      await prefs.remove(_keyAcceptFinancialAdviceWarning);
    }

    await saveWelcomeScreenDismissed(settings.welcomeScreenDismissed, prefs);
    await saveAnalyticsSettings(settings.optIntoAnalyticsWarning, prefs);
  }

  Future<void> saveWelcomeScreenDismissed(bool? welcomeScreenDismissed,
      [SharedPreferences? sharedPreferences]) async {
    final prefs = sharedPreferences ?? await SharedPreferences.getInstance();

    if (welcomeScreenDismissed != null) {
      await prefs.setBool(_keyWelcomeScreenDismissed, welcomeScreenDismissed);
    } else {
      await prefs.remove(_keyWelcomeScreenDismissed);
    }
  }

  Future<void> saveAnalyticsSettings(bool optIntoAnalyticsWarning,
      [SharedPreferences? sharedPreferences]) async {
    final prefs = sharedPreferences ?? await SharedPreferences.getInstance();

    await prefs.setBool(_keyOptIntoAnalyticsWarning, optIntoAnalyticsWarning);
  }
}
