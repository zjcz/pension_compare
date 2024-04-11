import 'package:get_it/get_it.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:pension_compare/settings/settings_service.dart';

// This is the global ServiceLocator
GetIt getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<SettingsService>(SettingsService());
  getIt.registerSingleton<DatabaseService>(
      DatabaseService.withDefaultConnection());
}
