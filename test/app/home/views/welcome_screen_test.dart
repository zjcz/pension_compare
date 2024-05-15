import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/app/home/views/home_screen.dart';
import 'package:pension_compare/app/home/views/welcome_screen.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/app/settings/models/welcome_settings.dart';
import 'package:pension_compare/app/settings/views/widgets/restore_password_bottomsheet.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/route_config.dart';

import 'welcome_screen_test.mocks.dart';

Widget createScreen(
    MockDatabaseService db, MockSettingsService mockSettingsService) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return ProviderScope(
        overrides: [
          DatabaseService.provider.overrideWithValue(db),
        ],
        child: MaterialApp.router(
            routerConfig: setupRouter(
          initialLocation: RouteDefs.welcome,
          initialExtra: mockSettingsService,
        )));
  });
}

@GenerateMocks([SettingsService, DatabaseService])
void main() {
  late MockSettingsService mockSettingsService;

  setUp(() {
    mockSettingsService = MockSettingsService();
  });

  group('WelcomeScreen', () {
    testWidgets('renders welcome text', (WidgetTester tester) async {
      await tester
          .pumpWidget(createScreen(MockDatabaseService(), mockSettingsService));

      expect(find.text('Welcome'), findsOneWidget);
      expect(find.text('to Pension Compare App'), findsOneWidget);
    });

    testWidgets(
        'tapping continue button without accepting terms does not save data and does not navigate to home screen',
        (WidgetTester tester) async {
      const saveWelcomeSettings = WelcomeSettings(
        acceptTermsAndConditions: true,
        acceptFinancialAdviceWarning: true,
        welcomeScreenDismissed: true,
      );
      when(mockSettingsService.saveWelcomeSettings(saveWelcomeSettings))
          .thenAnswer((_) async => true);

      await tester
          .pumpWidget(createScreen(MockDatabaseService(), mockSettingsService));

      // Tap the continue button without accepting terms
      await tester.tap(find.byKey(WelcomeScreen.welcomeContinueKey));
      await tester.pumpAndSettle();

      // Verify nothing happens
      verifyNever(mockSettingsService.saveWelcomeSettings(saveWelcomeSettings));
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets(
        'tapping continue button without accepting financial advice warning does not save data and does not navigate to home screen',
        (WidgetTester tester) async {
      const saveWelcomeSettings = WelcomeSettings(
        acceptTermsAndConditions: true,
        acceptFinancialAdviceWarning: true,
        welcomeScreenDismissed: true,
      );
      when(mockSettingsService.saveWelcomeSettings(saveWelcomeSettings))
          .thenAnswer((_) async => true);

      await tester
          .pumpWidget(createScreen(MockDatabaseService(), mockSettingsService));

      // accept terms and conditions but not financial advice
      await tester
          .tap(find.byKey(WelcomeScreen.welcomeAcceptTermsAndConditionsKey));
      await tester.pumpAndSettle();

      // Tap the continue button without accepting terms
      await tester.tap(find.byKey(WelcomeScreen.welcomeContinueKey));
      await tester.pumpAndSettle();

      // Verify nothing happens
      verifyNever(mockSettingsService.saveWelcomeSettings(saveWelcomeSettings));
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets(
        'tapping continue button without accepting terms and conditions does not save data and does not navigate to home screen',
        (WidgetTester tester) async {
      const saveWelcomeSettings = WelcomeSettings(
        acceptTermsAndConditions: true,
        acceptFinancialAdviceWarning: true,
        welcomeScreenDismissed: true,
      );
      when(mockSettingsService.saveWelcomeSettings(saveWelcomeSettings))
          .thenAnswer((_) async => true);

      await tester
          .pumpWidget(createScreen(MockDatabaseService(), mockSettingsService));

      // accept financial advice warning but not terms and conditions
      await tester.tap(
          find.byKey(WelcomeScreen.welcomeAcceptFinanicalAdviceWarningKey));
      await tester.pumpAndSettle();

      // Tap the continue button without accepting terms
      await tester.tap(find.byKey(WelcomeScreen.welcomeContinueKey));
      await tester.pumpAndSettle();

      // Verify nothing happens
      verifyNever(mockSettingsService.saveWelcomeSettings(saveWelcomeSettings));
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.byType(WelcomeScreen), findsOneWidget);
    });

    testWidgets(
        'tapping continue button after accepting terms and conditions and financial advice warning saves data and navigates to home screen',
        (WidgetTester tester) async {
      const saveWelcomeSettings = WelcomeSettings(
        acceptTermsAndConditions: true,
        acceptFinancialAdviceWarning: true,
        welcomeScreenDismissed: true,
      );
      when(mockSettingsService.saveWelcomeSettings(saveWelcomeSettings))
          .thenAnswer((_) async => true);

      await tester
          .pumpWidget(createScreen(MockDatabaseService(), mockSettingsService));

      // accept financial advice warning and terms and conditions
      await tester
          .tap(find.byKey(WelcomeScreen.welcomeAcceptTermsAndConditionsKey));

      await tester.tap(
          find.byKey(WelcomeScreen.welcomeAcceptFinanicalAdviceWarningKey));
      await tester.pumpAndSettle();

      // Tap the continue button without accepting terms
      await tester.tap(find.byKey(WelcomeScreen.welcomeContinueKey));
      await tester.pumpAndSettle();

      // Verify nothing happens
      verify(mockSettingsService.saveWelcomeSettings(saveWelcomeSettings))
          .called(1);
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(WelcomeScreen), findsNothing);
    });

    testWidgets('tapping restore button shows restore password bottom sheet',
        (WidgetTester tester) async {
      await tester
          .pumpWidget(createScreen(MockDatabaseService(), mockSettingsService));

      // Tap the restore button
      final buttonFinder = find.byKey(WelcomeScreen.welcomeRestoreKey);
      final scrollableFinder = find.byType(Scrollable).last;
      await tester.scrollUntilVisible(buttonFinder, 10,
          scrollable: scrollableFinder);
      await tester.tap(find.byKey(WelcomeScreen.welcomeRestoreKey));
      await tester.pumpAndSettle();

      // Verify that the restore password bottom sheet is shown
      expect(find.byType(RestorePasswordBottomsheet), findsOneWidget);
    });
  });
}
