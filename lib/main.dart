import 'package:flutter/material.dart';
import 'package:pension_compare/service_locator.dart';

import 'package:pension_compare/route_config.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // initialise getIt
  setupServiceLocator();

  runApp(const PensionCompareApp());
}

class PensionCompareApp extends StatelessWidget {
  const PensionCompareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Pension Compare',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
      routerConfig: setupRouter(),
    );
  }
}
