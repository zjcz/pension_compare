import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/app/home/views/home_screen.dart';
import 'package:pension_compare/app/home/views/welcome_screen.dart';
import 'package:pension_compare/app/passcode/views/set_passcode.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/helpers/analytics_helper.dart';
import 'package:pension_compare/route_config.dart';
import 'package:pension_compare/service_locator.dart';

import 'welcome_screen_test.mocks.dart';

Widget createScreen(
    MockDatabaseService db,
    MockSettingsService mockSettingsService,
    MockAnalyticsHelper mockAnalyticsHelper) {
  getIt.registerSingleton<SettingsService>(mockSettingsService);
  getIt.registerSingleton<AnalyticsHelper>(mockAnalyticsHelper);

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return ProviderScope(
        overrides: [
          DatabaseService.provider.overrideWithValue(db),
        ],
        child: MaterialApp.router(
            routerConfig: setupRouter(
          initialLocation: RouteDefs.welcome,
        )));
  });
}

@GenerateMocks([SettingsService, DatabaseService, AnalyticsHelper])
void main() {
  late MockSettingsService mockSettingsService;
  late MockAnalyticsHelper mockAnalyticsHelper;

  setUp(() {
    mockSettingsService = MockSettingsService();
    mockAnalyticsHelper = MockAnalyticsHelper();

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
    // reset before each test to prevent errors with duplicate DatabaseService
    await getIt.reset();
  });

  group('WelcomeScreen', () {
    testWidgets('renders welcome text', (WidgetTester tester) async {
      await tester.pumpWidget(createScreen(
          MockDatabaseService(), mockSettingsService, mockAnalyticsHelper));

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('to Pension Compare App'), findsOneWidget);
    });

    testWidgets(
        'tapping continue button without accepting terms does not save data and does not navigate to home screen',
        (WidgetTester tester) async {
      const saveSettings = Settings(
        retirementDate: null,
        targetIncome: null,
        acceptTermsAndConditions: true,
        acceptFinancialAdviceWarning: true,
        welcomeScreenDismissed: true,
        optIntoAnalyticsWarning: false,
      );
      when(mockSettingsService.saveAllSettings(saveSettings))
          .thenAnswer((_) async => true);
      when(mockAnalyticsHelper.enableAnalytics(true))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createScreen(
          MockDatabaseService(), mockSettingsService, mockAnalyticsHelper));

      // Tap the continue button without accepting terms
      await tester.tap(find.byKey(WelcomeScreen.welcomeContinueKey));
      await tester.pumpAndSettle();

      // Verify nothing happens
      verifyNever(mockSettingsService.saveAllSettings(saveSettings));
      verifyNever(mockAnalyticsHelper.enableAnalytics(true));
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets(
        'tapping continue button without accepting financial advice warning does not save data and does not navigate to home screen',
        (WidgetTester tester) async {
      const saveSettings = Settings(
        retirementDate: null,
        targetIncome: null,
        acceptTermsAndConditions: true,
        acceptFinancialAdviceWarning: true,
        welcomeScreenDismissed: true,
        optIntoAnalyticsWarning: false,
      );
      when(mockSettingsService.saveAllSettings(saveSettings))
          .thenAnswer((_) async => true);
      when(mockAnalyticsHelper.enableAnalytics(true))
          .thenAnswer((_) async => {});
      await tester.pumpWidget(createScreen(
          MockDatabaseService(), mockSettingsService, mockAnalyticsHelper));

      // accept terms and conditions but not financial advice
      await tester
          .tap(find.byKey(WelcomeScreen.welcomeAcceptTermsAndConditionsKey));
      await tester.pumpAndSettle();

      // Tap the continue button without accepting terms
      await tester.tap(find.byKey(WelcomeScreen.welcomeContinueKey));
      await tester.pumpAndSettle();

      // Verify nothing happens
      verifyNever(mockSettingsService.saveAllSettings(saveSettings));
      verifyNever(mockAnalyticsHelper.enableAnalytics(true));
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets(
        'tapping continue button without accepting terms and conditions does not save data and does not navigate to home screen',
        (WidgetTester tester) async {
      const saveSettings = Settings(
        retirementDate: null,
        targetIncome: null,
        acceptTermsAndConditions: true,
        acceptFinancialAdviceWarning: true,
        welcomeScreenDismissed: true,
        optIntoAnalyticsWarning: false,
      );
      when(mockSettingsService.saveAllSettings(saveSettings))
          .thenAnswer((_) async => true);

      when(mockAnalyticsHelper.enableAnalytics(true))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createScreen(
          MockDatabaseService(), mockSettingsService, mockAnalyticsHelper));

      // accept financial advice warning but not terms and conditions
      await tester.tap(
          find.byKey(WelcomeScreen.welcomeAcceptFinanicalAdviceWarningKey));
      await tester.pumpAndSettle();

      // Tap the continue button without accepting terms
      await tester.tap(find.byKey(WelcomeScreen.welcomeContinueKey));
      await tester.pumpAndSettle();

      // Verify nothing happens
      verifyNever(mockSettingsService.saveAllSettings(saveSettings));
      verifyNever(mockAnalyticsHelper.enableAnalytics(true));
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets(
        'tapping continue button after accepting terms and conditions and financial advice warning saves data and navigates to set passcode screen',
        (WidgetTester tester) async {
      const saveSettings = Settings(
        retirementDate: null,
        targetIncome: null,
        acceptTermsAndConditions: true,
        acceptFinancialAdviceWarning: true,
        welcomeScreenDismissed: true,
        optIntoAnalyticsWarning: false,
      );
      when(mockSettingsService.saveAllSettings(saveSettings))
          .thenAnswer((_) async => true);
      when(mockAnalyticsHelper.enableAnalytics(true))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createScreen(
          MockDatabaseService(), mockSettingsService, mockAnalyticsHelper));

      // accept financial advice warning and terms and conditions
      await tester
          .tap(find.byKey(WelcomeScreen.welcomeAcceptTermsAndConditionsKey));
      await tester.pumpAndSettle();

      await tester.tap(
          find.byKey(WelcomeScreen.welcomeAcceptFinanicalAdviceWarningKey));
      await tester.pumpAndSettle();

      // Tap the continue button without accepting terms
      final continueButtonFinder = find.byKey(WelcomeScreen.welcomeContinueKey);
      final scrollableFinder = find.byType(Scrollable).last;
      await tester.scrollUntilVisible(continueButtonFinder, 10,
          scrollable: scrollableFinder);
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();

      // Verify what happens
      verify(mockSettingsService.saveAllSettings(saveSettings)).called(1);
      verifyNever(mockAnalyticsHelper
          .enableAnalytics(true)); // not set so shouldn't call
      expect(find.byType(SetPasscodeScreen), findsOneWidget);
      expect(find.byType(WelcomeScreen), findsNothing);
    });

    testWidgets(
        'tapping continue button after opting into analytics calls enableAnalytics',
        (WidgetTester tester) async {
      const saveSettings = Settings(
        retirementDate: null,
        targetIncome: null,
        acceptTermsAndConditions: true,
        acceptFinancialAdviceWarning: true,
        welcomeScreenDismissed: true,
        optIntoAnalyticsWarning: true,
      );
      when(mockSettingsService.saveAllSettings(saveSettings))
          .thenAnswer((_) async => true);
      when(mockAnalyticsHelper.enableAnalytics(true))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createScreen(
          MockDatabaseService(), mockSettingsService, mockAnalyticsHelper));

      // accept financial advice warning and terms and conditions
      await tester
          .tap(find.byKey(WelcomeScreen.welcomeAcceptTermsAndConditionsKey));
      await tester.pumpAndSettle();

      await tester.tap(
          find.byKey(WelcomeScreen.welcomeAcceptFinanicalAdviceWarningKey));
      await tester.pumpAndSettle();

      final optIntoAnalyticsFinder = find.byKey(
          Key('${WelcomeScreen.welcomeOptIntoAnalyticsKey.toString()}_switch'));
      final scrollableFinder = find.byType(Scrollable).last;
      await tester.scrollUntilVisible(optIntoAnalyticsFinder, 10,
          scrollable: scrollableFinder);
      await tester.tap(optIntoAnalyticsFinder);
      await tester.pumpAndSettle();

      // Tap the continue button without accepting terms
      final continueButtonFinder = find.byKey(WelcomeScreen.welcomeContinueKey);
      await tester.scrollUntilVisible(continueButtonFinder, 10,
          scrollable: scrollableFinder);
      await tester.tap(continueButtonFinder);
      await tester.pumpAndSettle();

      // Verify what happens
      verify(mockSettingsService.saveAllSettings(saveSettings)).called(1);
      verify(mockAnalyticsHelper.enableAnalytics(true)).called(1);
      expect(find.byType(SetPasscodeScreen), findsOneWidget);
      expect(find.byType(WelcomeScreen), findsNothing);
    });
  });
}
