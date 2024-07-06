import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/app/home/views/home_screen.dart';
import 'package:pension_compare/app/passcode/controller/passcode_service.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/route_config.dart';
import 'package:pension_compare/service_locator.dart';

import 'enter_passcode_screen_test.mocks.dart';

Widget createEnterPasscodeScreen(PasscodeService mockPasscodeService,
    [SettingsService? mockSettingsService]) {
  getIt.registerSingleton<PasscodeService>(mockPasscodeService);
  if (mockSettingsService != null) {
    getIt.registerSingleton<SettingsService>(mockSettingsService);
  }

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return ProviderScope(
        child: MaterialApp.router(
            routerConfig: setupRouter(
      initialLocation: RouteDefs.passcodeEnter,
    )));
  });
}

@GenerateMocks([PasscodeService, SettingsService])
void main() {
  late MockPasscodeService mockPasscodeService;

  setUp(() async {
    mockPasscodeService = MockPasscodeService();

    // reset before each test to prevent errors with duplicate MockPasscodeService
    await getIt.reset();
  });

  group('Enter Passcode Screen', () {
    testWidgets('given new screen when loading screen then expect widgets',
        (WidgetTester tester) async {
      // Build the EnterPasscode widget
      await tester.pumpWidget(createEnterPasscodeScreen(mockPasscodeService));

      // Verify that the EnterPasscode widget renders correctly
      expect(find.text('Enter Passcode'), findsOneWidget);
      expect(find.text('Enter your passcode:'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.widgetWithText(TextButton, "Submit"), findsOneWidget);
    });

    testWidgets(
        'given passcode screen when entering valid passcode then load home screen',
        (WidgetTester tester) async {
      String validPasscode = '1234';
      when(mockPasscodeService.validatePasscode(validPasscode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.testPasscode(validPasscode))
          .thenAnswer((_) async => true);
      when(mockPasscodeService.setPasscode(validPasscode))
          .thenAnswer((_) => true);

      // required by homescreen
      MockSettingsService mockSettingsService = MockSettingsService();
      when(mockSettingsService.getAllSettings())
          .thenAnswer((_) async => const Settings(
                acceptTermsAndConditions: false,
                acceptFinancialAdviceWarning: false,
                welcomeScreenDismissed: true,
                optIntoAnalyticsWarning: false,
              ));

      // Build the EnterPasscode widget
      await tester.pumpWidget(
          createEnterPasscodeScreen(mockPasscodeService, mockSettingsService));
      await tester.pumpAndSettle();

      // Enter a passcode
      await tester.enterText(find.byType(TextField), validPasscode);

      // Tap the submit button
      await tester.tap(find.widgetWithText(TextButton, "Submit"));
      await tester.pumpAndSettle();

      // Verify that the passcode is set correctly
      verify(mockPasscodeService.setPasscode(validPasscode)).called(1);
      verify(mockPasscodeService.testPasscode(validPasscode)).called(1);
      verify(mockPasscodeService.validatePasscode(validPasscode)).called(1);
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets(
        'given passcode screen when entering incorrect passcode then show warning',
        (WidgetTester tester) async {
      String incorrectPasscode = '1234';
      when(mockPasscodeService.validatePasscode(incorrectPasscode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.testPasscode(incorrectPasscode))
          .thenAnswer((_) async => false);
      when(mockPasscodeService.setPasscode(incorrectPasscode))
          .thenAnswer((_) => false);

      // Build the EnterPasscode widget
      await tester.pumpWidget(createEnterPasscodeScreen(mockPasscodeService));
      await tester.pumpAndSettle();

      // Enter a passcode
      await tester.enterText(find.byType(TextField), incorrectPasscode);

      // Tap the submit button
      await tester.tap(find.widgetWithText(TextButton, "Submit"));
      await tester.pumpAndSettle();

      // Verify that the passcode is set correctly
      verify(mockPasscodeService.validatePasscode(incorrectPasscode)).called(1);
      verifyNever(mockPasscodeService.setPasscode(incorrectPasscode));
      verify(mockPasscodeService.testPasscode(incorrectPasscode)).called(1);
      expect(find.byType(HomeScreen), findsNothing);
      expect(
          find.text('Passcode incorrect. Please try again.'), findsOneWidget);
    });

    testWidgets(
        'given passcode screen when entering invalid passcode then show warning',
        (WidgetTester tester) async {
      String incorrectPasscode = 'abc';
      when(mockPasscodeService.validatePasscode(incorrectPasscode))
          .thenAnswer((_) => false);
      when(mockPasscodeService.testPasscode(incorrectPasscode))
          .thenAnswer((_) async => false);

      // Build the EnterPasscode widget
      await tester.pumpWidget(createEnterPasscodeScreen(mockPasscodeService));
      await tester.pumpAndSettle();

      // Enter a passcode
      await tester.enterText(find.byType(TextField), incorrectPasscode);

      // Tap the submit button
      await tester.tap(find.widgetWithText(TextButton, "Submit"));
      await tester.pumpAndSettle();

      // Verify that the passcode is set correctly
      verify(mockPasscodeService.validatePasscode(incorrectPasscode)).called(1);
      verifyNever(mockPasscodeService.setPasscode(incorrectPasscode));
      verifyNever(mockPasscodeService.testPasscode(incorrectPasscode));
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.text('Passcode is invalid'), findsOneWidget);
    });
  });
}
