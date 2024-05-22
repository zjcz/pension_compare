import 'package:flutter/material.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/helpers/analytics_helper.dart';
import 'package:pension_compare/route_config.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/service_locator.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  Future<void> initialiseApp() async {
    bool welcomeScreenDismissed = false;

    Settings settings = await getIt<SettingsService>().getAllSettings();
    welcomeScreenDismissed = settings.welcomeScreenDismissed ?? false;

    // has the user opted in to analytics?
    if (settings.optIntoAnalyticsWarning) {
      getIt<AnalyticsHelper>().enableAnalytics(true);
    }

    // now load the welcome of the main home page.
    // We use pushReplacement so the user doesn't return to this screen when exiting the app
    if (!mounted) return;
    if (welcomeScreenDismissed) {
      context.go(RouteDefs.home);
    } else {
      context.go(RouteDefs.welcome);
    }
  }

  @override
  void initState() {
    super.initState();
    initialiseApp().then((_) => {});
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
