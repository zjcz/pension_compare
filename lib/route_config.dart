import 'package:flutter/material.dart';
import 'package:pension_compare/screens/edit_pension_screen.dart';
import 'package:pension_compare/screens/edit_state_pension_screen.dart';
import 'package:pension_compare/screens/edit_statement_screen.dart';
import 'package:pension_compare/screens/home_screen.dart';
import 'package:pension_compare/screens/pension_overview_screen.dart';
import 'package:pension_compare/screens/settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/database/database_service.dart';

class RouteDefs {
  static const String home = '/';
  static const String pensionOverview = '/pension_overview';
  static const String editPension = '/edit_pension';
  static const String editStatement = '/edit_statement';
  static const String editStatePension = '/edit_state_pension';
  static const String editSettings = '/edit_settings';
}

// The route configuration.
GoRouter setupRouter({String? initialLocation, Object? initialExtra}) {
  return GoRouter(
    initialLocation: initialLocation ?? RouteDefs.home,
    initialExtra: initialExtra,
    routes: <RouteBase>[
      GoRoute(
          path: RouteDefs.home,
          builder: (BuildContext context, GoRouterState state) {
            return const HomeScreen();
          },
          routes: <RouteBase>[
            GoRoute(
              path: RouteDefs.pensionOverview.substring(1), //strip leading /
              builder: (BuildContext context, GoRouterState state) {
                Pension p = state.extra! as Pension;
                return PensionOverviewScreen(pension: p);
              },
            ),
            GoRoute(
              path: RouteDefs.editPension.substring(1), //strip leading /
              builder: (BuildContext context, GoRouterState state) {
                Pension? p;
                if (state.extra != null) {
                  p = state.extra! as Pension;
                }
                return EditPensionScreen(pension: p);
              },
            ),
            GoRoute(
              path: RouteDefs.editStatement.substring(1), //strip leading /
              builder: (BuildContext context, GoRouterState state) {
                Pension? p;
                Statement? s;

                if (state.extra != null) {
                  if (state.extra is Pension) {
                    p = state.extra as Pension;
                  } else if (state.extra is Statement) {
                    s = state.extra as Statement;
                  } else if (state.extra is (Pension, Statement)) {
                    (p, s) = state.extra as (Pension, Statement);
                  }
                }

                return EditStatementScreen(parentPension: p, statement: s);
              },
            ),
            GoRoute(
              path: RouteDefs.editStatePension.substring(1), //strip leading /
              builder: (BuildContext context, GoRouterState state) {
                return const EditStatePensionScreen();
              },
            ),
            GoRoute(
              path: RouteDefs.editSettings.substring(1), //strip leading /
              builder: (BuildContext context, GoRouterState state) {
                return const SettingsScreen();
              },
            )
          ]),
    ],
  );
}
