import 'package:flutter/material.dart';
import 'package:pension_compare/app/home/views/loading_screen.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/app/pension/views/edit_pension_screen.dart';
import 'package:pension_compare/app/otherIncome/views/edit_state_pension_screen.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/app/statement/models/statement_model.dart';
import 'package:pension_compare/app/statement/views/edit_statement_screen.dart';
import 'package:pension_compare/app/home/views/home_screen.dart';
import 'package:pension_compare/app/pension/views/pension_overview_screen.dart';
import 'package:pension_compare/app/settings/views/settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/app/home/views/policy_viewer_screen.dart';
import 'package:pension_compare/app/home/views/welcome_screen.dart';

class RouteDefs {
  static const String home = '/';
  static const String welcome = '/welcome';
  static const String pensionOverview = '/pension_overview';
  static const String editPension = '/edit_pension';
  static const String editStatement = '/edit_statement';
  static const String editStatePension = '/edit_state_pension';
  static const String editSettings = '/edit_settings';
  static const String loading = '/loading';
  static const String policyViewer = '/policy_view';
}

// The route configuration.
GoRouter setupRouter({String? initialLocation, Object? initialExtra, List<NavigatorObserver>? observers}) {
  return GoRouter(
    initialLocation: initialLocation ?? RouteDefs.home,
    initialExtra: initialExtra,    
    observers: observers,
    routes: <RouteBase>[
      GoRoute(
          path: RouteDefs.home,
          name: 'home',
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
          routes: <RouteBase>[
            GoRoute(
              path: RouteDefs.welcome.substring(1), //strip leading /
              name: 'welcome',
              builder: (BuildContext context, GoRouterState state) {
                SettingsService? settingsService;
                if (state.extra != null) {
                  settingsService = state.extra! as SettingsService;
                }
                return WelcomeScreen(
                    settingsService: settingsService ?? SettingsService());
              },
            ),
            GoRoute(
              path:
                  '${RouteDefs.pensionOverview.substring(1)}/:pensionId', //strip leading /
              name: 'pensionOverview',
              builder: (BuildContext context, GoRouterState state) {
                return PensionOverviewScreen(
                    pensionId: int.parse(state.pathParameters['pensionId']!));
              },
            ),
            GoRoute(
              path: RouteDefs.editPension.substring(1), //strip leading /
              name: 'editPension',
              builder: (BuildContext context, GoRouterState state) {
                PensionModel? p;
                if (state.extra != null) {
                  p = state.extra! as PensionModel;
                }
                return EditPensionScreen(pension: p);
              },
            ),
            GoRoute(
              path: RouteDefs.editStatement.substring(1), //strip leading /
              name: 'editStatement',
              builder: (BuildContext context, GoRouterState state) {
                PensionModel? p;
                StatementModel? s;

                if (state.extra != null) {
                  if (state.extra is PensionModel) {
                    p = state.extra as PensionModel;
                  } else if (state.extra is StatementModel) {
                    s = state.extra as StatementModel;
                  } else if (state.extra is (PensionModel, StatementModel)) {
                    (p, s) = state.extra as (PensionModel, StatementModel);
                  }
                }

                return EditStatementScreen(parentPension: p, statement: s);
              },
            ),
            GoRoute(
              path: RouteDefs.editStatePension.substring(1), //strip leading /
              name: 'editStatePension',
              builder: (BuildContext context, GoRouterState state) {
                return const EditStatePensionScreen();
              },
            ),
            GoRoute(
              path: RouteDefs.editSettings.substring(1), //strip leading /
              name: 'editSettings',
              builder: (BuildContext context, GoRouterState state) {
                SettingsService? settingsService;
                if (state.extra != null) {
                  settingsService = state.extra! as SettingsService;
                }
                return SettingsScreen(
                    settingsService: settingsService ?? SettingsService());
              },
            ),
            GoRoute(
              path: RouteDefs.loading.substring(1), //strip leading /
              name: 'loading',
              builder: (BuildContext context, GoRouterState state) {
                SettingsService? settingsService;
                if (state.extra != null) {
                  settingsService = state.extra! as SettingsService;
                }
                return LoadingScreen(
                    settingsService: settingsService ?? SettingsService());
              },
            ),
            GoRoute(
              path: RouteDefs.policyViewer.substring(1), //strip leading /
              name: 'policyViewer',
              builder: (BuildContext context, GoRouterState state) {
                PolicyType? policyType;
                if (state.extra != null) {
                  policyType = state.extra! as PolicyType;
                }
                return PolicyViewerScreen(
                    policyType: policyType ?? PolicyType.termsAndConditions);
              },
            ),
          ]),
    ],
  );
}
