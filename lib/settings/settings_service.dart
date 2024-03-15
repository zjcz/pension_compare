import 'package:pension_compare/settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  Future<Settings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return Settings(
      dateOfBirth: DateTime.tryParse(prefs.getString('dateOfBirth') ?? ''),
      plannedRetirementAge: prefs.getInt('plannedRetirementAge'),
      targetIncome: prefs.getDouble('targetIncome'),
    );
  }

  Future<void> saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        'dateOfBirth', settings.dateOfBirth?.toIso8601String() ?? '');
    await prefs.setInt(
        'plannedRetirementAge', settings.plannedRetirementAge ?? 0);
    await prefs.setDouble('targetIncome', settings.targetIncome ?? 0);
  }
}
