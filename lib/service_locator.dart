import 'package:get_it/get_it.dart';
import 'package:pension_compare/app/passcode/controller/passcode_service.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/helpers/analytics_helper.dart';

// This is the global ServiceLocator
GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<SettingsService>(SettingsService());
  getIt.registerSingleton<AnalyticsHelper>(AnalyticsHelper());
  getIt.registerSingleton<PasscodeService>(PasscodeService());
}
