import 'package:flutter/material.dart';
import 'package:pension_compare/app/home/views/about_screen.dart';
import 'package:pension_compare/app/home/views/loading_screen.dart';
import 'package:pension_compare/app/passcode/views/change_passcode_screen.dart';
import 'package:pension_compare/app/passcode/views/enter_passcode_screen.dart';
import 'package:pension_compare/app/passcode/views/set_passcode_screen.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/app/pension/views/edit_pension_screen.dart';
import 'package:pension_compare/app/otherIncome/views/edit_state_pension_screen.dart';
import 'package:pension_compare/app/pension/views/pension_report_screen.dart';
import 'package:pension_compare/app/statement/models/statement_model.dart';
import 'package:pension_compare/app/statement/views/edit_statement_screen.dart';
import 'package:pension_compare/app/home/views/home_screen.dart';
import 'package:pension_compare/app/pension/views/pension_overview_screen.dart';
import 'package:pension_compare/app/settings/views/settings_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:pension_compare/app/home/views/policy_viewer_screen.dart';
import 'package:pension_compare/app/home/views/welcome_screen.dart';
import 'package:pension_compare/data/database/database_service.dart';

class RouteDefs {
  static const String home = '/home';
  static const String welcome = '/welcome';
  static const String pensionOverview = '/home/pension_overview';
  static const String pensionProgress = '/home/pension_progress';
  static const String editPension = '/home/edit_pension';
  static const String editStatement = '/home/edit_statement';
  static const String editStatePension = '/home/edit_state_pension';
  static const String editSettings = '/home/edit_settings';
  static const String aboutScreen = '/home/about_screen';
  static const String loading = '/';
  static const String policyViewer = '/policy_view';
  static const String passcodeSet = '/welcome/setpasscode';
  static const String passcodeEnter = '/enterpasscode';
  static const String passcodeChange = '/home/changepasscode';

  static String getPageName(String pageName, {String? parentPage}) {
    return pageName.replaceAll(parentPage ?? '', '').substring(1);
  }
}

// The route configuration.
GoRouter setupRouter(
    {String? initialLocation,
    Object? initialExtra,
    List<NavigatorObserver>? observers,
    bool testing = false}) {
  return GoRouter(
    initialLocation: initialLocation ?? RouteDefs.loading,
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
              path:
                  '${RouteDefs.getPageName(RouteDefs.pensionOverview, parentPage: RouteDefs.home)}/:pensionId',
              name: 'pensionOverview',
              builder: (BuildContext context, GoRouterState state) {
                return PensionOverviewScreen(
                    pensionId: int.parse(state.pathParameters['pensionId']!));
              },
            ),
            GoRoute(
              path: RouteDefs.getPageName(RouteDefs.editPension,
                  parentPage: RouteDefs.home),
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
              path: RouteDefs.getPageName(RouteDefs.editStatement,
                  parentPage: RouteDefs.home),
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
              path: RouteDefs.getPageName(RouteDefs.editStatePension,
                  parentPage: RouteDefs.home),
              name: 'editStatePension',
              builder: (BuildContext context, GoRouterState state) {
                return const EditStatePensionScreen();
              },
            ),
            GoRoute(
              path: RouteDefs.getPageName(RouteDefs.editSettings,
                  parentPage: RouteDefs.home),
              name: 'editSettings',
              builder: (BuildContext context, GoRouterState state) {
                return const SettingsScreen();
              },
            ),
            GoRoute(
              path: RouteDefs.getPageName(RouteDefs.aboutScreen,
                  parentPage: RouteDefs.home),
              name: 'aboutScreen',
              builder: (BuildContext context, GoRouterState state) {
                return const AboutScreen();
              },
            ),
            GoRoute(
              path: RouteDefs.getPageName(RouteDefs.passcodeChange,
                  parentPage: RouteDefs.home),
              name: 'changePasscode',
              builder: (BuildContext context, GoRouterState state) {
                DatabaseService? databaseService;
                if (state.extra != null) {
                  databaseService = state.extra! as DatabaseService;
                }
                return ChangePasscodeScreen(databaseService: databaseService!);
              },
            ),
            GoRoute(
              path: RouteDefs.getPageName(RouteDefs.pensionProgress,
                  parentPage: RouteDefs.home),
              name: 'pensionProgress',
              builder: (BuildContext context, GoRouterState state) {
                return const PensionReportScreen();
              },
            ),
          ]),
      GoRoute(
          path: RouteDefs.loading,
          name: 'loading',
          builder: (BuildContext context, GoRouterState state) {
            return LoadingScreen(testing: testing);
          },
          routes: <RouteBase>[
            GoRoute(
              path: RouteDefs.getPageName(RouteDefs.policyViewer),
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
      GoRoute(
        path: RouteDefs.passcodeEnter,
        name: 'enterPasscode',
        builder: (BuildContext context, GoRouterState state) {
          return const EnterPasscodeScreen();
        },
      ),
      GoRoute(
          path: RouteDefs.welcome,
          name: 'welcome',
          builder: (BuildContext context, GoRouterState state) {
            return const WelcomeScreen();
          },
          routes: <RouteBase>[
            GoRoute(
              path: RouteDefs.getPageName(RouteDefs.passcodeSet,
                  parentPage: RouteDefs.welcome),
              name: 'setPasscode',
              builder: (BuildContext context, GoRouterState state) {
                return const SetPasscodeScreen();
              },
            ),
          ]),
    ],
  );
}
