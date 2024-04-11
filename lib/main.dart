import 'package:flutter/material.dart';
import 'package:pension_compare/screens/home_screen.dart';
import 'package:pension_compare/service_locator.dart';

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
    return MaterialApp(
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
      home: const HomeScreen(),
    );
  }
}
