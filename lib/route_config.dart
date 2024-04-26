import 'package:flutter/material.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/app/pension/views/edit_pension_screen.dart';
import 'package:pension_compare/app/otherIncome/views/edit_state_pension_screen.dart';
import 'package:pension_compare/app/settings/settings_service.dart';
import 'package:pension_compare/app/statement/models/statement_model.dart';
import 'package:pension_compare/app/statement/views/edit_statement_screen.dart';
import 'package:pension_compare/app/home/views/home_screen.dart';
import 'package:pension_compare/app/pension/views/pension_overview_screen.dart';
import 'package:pension_compare/app/settings/views/settings_screen.dart';
import 'package:go_router/go_router.dart';

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
                PensionModel p = state.extra! as PensionModel;
                return PensionOverviewScreen(pension: p);
              },
            ),
            GoRoute(
              path: RouteDefs.editPension.substring(1), //strip leading /
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
              builder: (BuildContext context, GoRouterState state) {
                return const EditStatePensionScreen();
              },
            ),
            GoRoute(
              path: RouteDefs.editSettings.substring(1), //strip leading /
              builder: (BuildContext context, GoRouterState state) {
                SettingsService? settingsService;
                if (state.extra != null) {
                  settingsService = state.extra! as SettingsService;
                }
                return SettingsScreen(
                    settingsService: settingsService ?? SettingsService());
              },
            )
          ]),
    ],
  );
}
