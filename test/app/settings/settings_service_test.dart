import 'package:shared_preferences/shared_preferences.dart';
import 'package:pension_compare/app/settings/settings_service.dart';
import 'package:pension_compare/app/settings/settings.dart';
import 'package:test/test.dart';
import 'package:matcher/matcher.dart' as match;

void main() {
  group('Test read/write settings', () {
    test('get the settings', () async {
      DateTime retirementDate = DateTime(2050, 2, 3);
      double targetIncome = 1234.56;

      SharedPreferences.setMockInitialValues({
        'retirementDate': retirementDate.toIso8601String(),
        'targetIncome': targetIncome
      });

      SettingsService settingsService = SettingsService();
      final settings = await settingsService.getSettings();
      expect(settings, match.isNotNull);
      expect(settings.retirementDate, retirementDate);
      expect(settings.targetIncome, targetIncome);
    });

    test('get the settings when not initialised', () async {
      SharedPreferences.setMockInitialValues({});

      SettingsService settingsService = SettingsService();
      final settings = await settingsService.getSettings();
      expect(settings, match.isNotNull);
      expect(settings.retirementDate, match.isNull);
      expect(settings.targetIncome, match.isNull);
    });

    test('save the settings', () async {
      DateTime retirementDate = DateTime(2050, 2, 3);
      double targetIncome = 1234.56;

      SharedPreferences.setMockInitialValues({});

      Settings settingsToSave =
          Settings(retirementDate: retirementDate, targetIncome: targetIncome);

      SettingsService settingsService = SettingsService();
      await settingsService.saveSettings(settingsToSave);

      final settings = await settingsService.getSettings();
      expect(settings, match.isNotNull);
      expect(settings.retirementDate, retirementDate);
      expect(settings.targetIncome, targetIncome);
    });

    test('save the null settings', () async {
      DateTime initialRetirementDate = DateTime(2050, 2, 3);
      double initialTargetIncome = 1234.56;
      DateTime? newRetirementDate;
      double? newTargetIncome;

      SharedPreferences.setMockInitialValues({
        'retirementDate': initialRetirementDate.toIso8601String(),
        'targetIncome': initialTargetIncome
      });

      Settings settingsToSave = Settings(
          retirementDate: newRetirementDate, targetIncome: newTargetIncome);

      SettingsService settingsService = SettingsService();
      await settingsService.saveSettings(settingsToSave);

      final settings = await settingsService.getSettings();
      expect(settings, match.isNotNull);
      expect(settings.retirementDate, isNull);
      expect(settings.targetIncome, isNull);
    });
  });
}
