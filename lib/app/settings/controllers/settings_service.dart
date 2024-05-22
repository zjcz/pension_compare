import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/app/settings/models/user_settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  final String _keyRetirementDate = 'retirementDate';
  final String _keyTargetIncome = 'targetIncome';
  final String _keyAcceptTermsAndConditions = 'acceptTermsAndConditions';
  final String _keyAcceptFinancialAdviceWarning =
      'acceptFinancialAdviceWarning';
  final String _keyWelcomeScreenDismissed = 'welcomeScreenDismissed';
  final String _keyOptIntoAnalyticsWarning = 'optIntoAnalyticsWarning';

  Future<Settings> getAllSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return Settings(
      retirementDate:
          DateTime.tryParse(prefs.getString(_keyRetirementDate) ?? ''),
      targetIncome: prefs.getDouble(_keyTargetIncome),
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

    if (settings.welcomeScreenDismissed != null) {
      await prefs.setBool(
          _keyWelcomeScreenDismissed, settings.welcomeScreenDismissed ?? false);
    } else {
      await prefs.remove(_keyWelcomeScreenDismissed);
    }

    await saveUserSettings(
        UserSettings(
            retirementDate: settings.retirementDate,
            targetIncome: settings.targetIncome,
            optIntoAnalyticsWarning: settings.optIntoAnalyticsWarning),
        prefs);
  }

  Future<void> saveUserSettings(UserSettings settings,
      [SharedPreferences? sharedPreferences]) async {
    final prefs = sharedPreferences ?? await SharedPreferences.getInstance();

    await prefs.setString(
        _keyRetirementDate, settings.retirementDate?.toIso8601String() ?? '');
    if (settings.targetIncome != null) {
      await prefs.setDouble(_keyTargetIncome, settings.targetIncome ?? 0);
    } else {
      await prefs.remove(_keyTargetIncome);
    }
    await prefs.setBool(
        _keyOptIntoAnalyticsWarning, settings.optIntoAnalyticsWarning);
  }
}
