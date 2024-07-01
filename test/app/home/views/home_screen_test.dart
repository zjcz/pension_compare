import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:pension_compare/app/pension/views/edit_pension_screen.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/constants/chart_color_constants.dart';
import 'package:pension_compare/data/database/tables/pensions_with_statement.dart';
import 'package:pension_compare/app/home/views/home_screen.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/route_config.dart';
import 'package:pension_compare/service_locator.dart';

import 'home_screen_test.mocks.dart';

Widget createHomeScreen(
    DatabaseService db, MockSettingsService mockSettingsService) {
  getIt.registerSingleton<SettingsService>(mockSettingsService);
  getIt.registerSingleton<ChartColorConstants>(ChartColorConstants());

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return ProviderScope(
        overrides: [
          DatabaseService.provider.overrideWithValue(db),
        ],
        child: MaterialApp.router(
            routerConfig: setupRouter(
          initialLocation: RouteDefs.home,
        )));
  });
}

@GenerateMocks([SettingsService, DatabaseService])
void main() {
  late MockSettingsService mockSettingsService;

  setUp(() {
    mockSettingsService = MockSettingsService();

    when(mockSettingsService.getAllSettings())
        .thenAnswer((_) async => const Settings(
              retirementDate: null,
              targetIncome: null,
              acceptTermsAndConditions: false,
              acceptFinancialAdviceWarning: false,
              welcomeScreenDismissed: false,
              optIntoAnalyticsWarning: false,
            ));
  });

  setUp(() async {
    // reset before each test to prevent errors with duplicate service
    await getIt.reset();
  });

  group('Test displaying the home screen', () {
    testWidgets('show the home screen with no pension records', (tester) async {
      final databaseService = MockDatabaseService();
      when(databaseService.getAllPensionsWithLatestStatement())
          .thenAnswer((_) => Stream.value([]));
      when(databaseService.getYearlyPensionSummary())
          .thenAnswer((_) => Stream.value([]));
      await tester
          .pumpWidget(createHomeScreen(databaseService, mockSettingsService));
      await tester.pumpAndSettle();

      expect(find.text("Pension Compare"), findsOneWidget);

      expect(
          find.text("No pensions found.  Click + to add one"), findsOneWidget);
    });

    testWidgets('show the home screen with a single pension record',
        (tester) async {
      int pensionId = 1;
      String pensionName = 'new pension';
      final databaseService = MockDatabaseService();
      when(databaseService.getYearlyPensionSummary())
          .thenAnswer((_) => Stream.value([]));
      when(databaseService.getAllPensionsWithLatestStatement())
          .thenAnswer((_) => Stream.value([
                PensionWithStatement(
                    Pension(
                        pensionId: pensionId,
                        name: pensionName,
                        maturityDate: DateTime.now()),
                    null)
              ]));
      await tester
          .pumpWidget(createHomeScreen(databaseService, mockSettingsService));
      await tester.pumpAndSettle();

      expect(find.text("Pension Compare"), findsOneWidget);

      expect(find.widgetWithText(DataTable, pensionName), findsOneWidget);
    });

    testWidgets('tapping + button navigates to the edit pension screen',
        (tester) async {
      final databaseService = MockDatabaseService();
      when(databaseService.getAllPensionsWithLatestStatement())
          .thenAnswer((_) => Stream.value([]));
      await tester
          .pumpWidget(createHomeScreen(databaseService, mockSettingsService));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.byType(EditPensionScreen), findsOneWidget);
    });
  });
}
