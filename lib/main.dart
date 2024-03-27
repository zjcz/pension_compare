import 'package:flutter/material.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:pension_compare/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PensionCompareApp());
}

class PensionCompareApp extends StatelessWidget {
  const PensionCompareApp({super.key});

  @override
  Widget build(BuildContext context) {
    DatabaseService databaseService = DatabaseService.withDefaultConnection();

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
      home: HomeScreen(databaseService: databaseService),
    );
  }
}
