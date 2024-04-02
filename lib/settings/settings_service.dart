import 'package:pension_compare/settings/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  Future<Settings> getSettings() async {
    final prefs = await SharedPreferences.getInstance();

    return Settings(
      retirementDate:
          DateTime.tryParse(prefs.getString('retirementDate') ?? ''),
      targetIncome: prefs.getDouble('targetIncome'),
    );
  }

  Future<void> saveSettings(Settings settings) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
        'retirementDate', settings.retirementDate?.toIso8601String() ?? '');
    if (settings.targetIncome != null) {
      await prefs.setDouble('targetIncome', settings.targetIncome ?? 0);
    } else {
      await prefs.remove('targetIncome');
    }
  }
}
