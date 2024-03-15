import 'package:shared_preferences/shared_preferences.dart';
import 'package:pension_compare/settings/settings_service.dart';
import 'package:pension_compare/settings/settings.dart';
import 'package:test/test.dart';
import 'package:matcher/matcher.dart' as match;

void main() {
  group('Test read/write settings', () {
    test('get the settings', () async {
      DateTime dob = DateTime(2000, 2, 3);
      int plannedRetirementAge = 67;
      double targetIncome = 1234.56;

      SharedPreferences.setMockInitialValues({
        'dateOfBirth': dob.toIso8601String(),
        'plannedRetirementAge': plannedRetirementAge,
        'targetIncome': targetIncome
      });

      SettingsService settingsService = SettingsService();
      final settings = await settingsService.getSettings();
      expect(settings, match.isNotNull);
      expect(settings.dateOfBirth, dob);
      expect(settings.plannedRetirementAge, plannedRetirementAge);
      expect(settings.targetIncome, targetIncome);
    });

    test('get the settings when not initialised', () async {
      SharedPreferences.setMockInitialValues({});

      SettingsService settingsService = SettingsService();
      final settings = await settingsService.getSettings();
      expect(settings, match.isNotNull);
      expect(settings.dateOfBirth, match.isNull);
      expect(settings.plannedRetirementAge, match.isNull);
      expect(settings.targetIncome, match.isNull);
    });

    test('save the settings', () async {
      DateTime dob = DateTime(2000, 2, 3);
      int plannedRetirementAge = 67;
      double targetIncome = 1234.56;

      SharedPreferences.setMockInitialValues({});

      Settings settingsToSave = Settings(
          dateOfBirth: dob,
          plannedRetirementAge: plannedRetirementAge,
          targetIncome: targetIncome);

      SettingsService settingsService = SettingsService();
      await settingsService.saveSettings(settingsToSave);

      final settings = await settingsService.getSettings();
      expect(settings, match.isNotNull);
      expect(settings.dateOfBirth, dob);
      expect(settings.plannedRetirementAge, plannedRetirementAge);
      expect(settings.targetIncome, targetIncome);
    });
  });
}
