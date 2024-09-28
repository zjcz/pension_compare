import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/app/home/views/home_screen.dart';
import 'package:pension_compare/app/passcode/controller/passcode_service.dart';
import 'package:pension_compare/app/passcode/views/set_passcode_screen.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/route_config.dart';
import 'package:pension_compare/service_locator.dart';

import 'set_passcode_screen_test.mocks.dart';

Widget createSetPasscodeScreen(
    SettingsService mockSettingsService, PasscodeService mockPasscodeService) {
  getIt.registerSingleton<SettingsService>(mockSettingsService);
  getIt.registerSingleton<PasscodeService>(mockPasscodeService);

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return ProviderScope(
        child: MaterialApp.router(
            routerConfig: setupRouter(
      initialLocation: RouteDefs.passcodeSet,
      testing: true,
    )));
  });
}

@GenerateMocks([SettingsService, PasscodeService])
void main() {
  late MockPasscodeService mockPasscodeService;
  late MockSettingsService mockSettingsService;

  setUp(() async {
    mockPasscodeService = MockPasscodeService();
    mockSettingsService = MockSettingsService();

    when(mockSettingsService.getAllSettings())
        .thenAnswer((_) async => const Settings(
              acceptTermsAndConditions: false,
              acceptFinancialAdviceWarning: false,
              welcomeScreenDismissed: true,
              optIntoAnalyticsWarning: false,
            ));

    // reset before each test to prevent errors with duplicate MockPasscodeService
    await getIt.reset();
  });

  group('Set Passcode Screen', () {
    testWidgets('given new screen when loading screen then expect widgets',
        (WidgetTester tester) async {
      // Build the SetPasscode widget
      await tester.pumpWidget(
          createSetPasscodeScreen(mockSettingsService, mockPasscodeService));

      // Verify that the SetPasscode widget renders correctly
      expect(find.byType(SetPasscodeScreen), findsOneWidget);
      expect(find.text('Set a Password'), findsOneWidget);
      expect(find.text('Enter password:'), findsOneWidget);
      expect(find.text('Repeat password:'), findsOneWidget);
      expect(find.byType(TextField), findsExactly(2));
      expect(find.byKey(SetPasscodeScreen.passcodeTextField), findsOneWidget);
      expect(find.byKey(SetPasscodeScreen.repeatPasscodeTextField),
          findsOneWidget);
      expect(find.widgetWithText(TextButton, "Continue"), findsOneWidget);
    });

    testWidgets(
        'given passcode screen when setting valid passcode then load home screen',
        (WidgetTester tester) async {
      String validPasscode = '123abcABC!';
      when(mockPasscodeService.validatePasscode(validPasscode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.setPasscode(validPasscode)).thenReturn(true);
      when(mockSettingsService.saveWelcomeScreenDismissed(true))
          .thenAnswer((_) async => Future<void>.value(null));

      // Build the SetPasscode widget
      await tester.pumpWidget(
          createSetPasscodeScreen(mockSettingsService, mockPasscodeService));

      // Enter passcodes
      await tester.enterText(
          find.byKey(SetPasscodeScreen.passcodeTextField), validPasscode);
      await tester.enterText(
          find.byKey(SetPasscodeScreen.repeatPasscodeTextField), validPasscode);

      // Tap the submit button
      await tester.tap(find.widgetWithText(TextButton, "Continue"));
      await tester.pumpAndSettle();

      // Verify that the passcode is set correctly
      verify(mockPasscodeService.setPasscode(validPasscode)).called(1);
      verify(mockPasscodeService.validatePasscode(validPasscode));
      verify(mockSettingsService.saveWelcomeScreenDismissed(true));
      expect(find.byType(SetPasscodeScreen), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets(
        'given passcode screen when entering different passcodes then show warning',
        (WidgetTester tester) async {
      String passcode = '12345678';
      String repeatPasscode = '87654321';
      when(mockPasscodeService.validatePasscode(passcode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.validatePasscode(repeatPasscode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.setPasscode(passcode)).thenAnswer((_) => false);

      // Build the SetPasscode widget
      await tester.pumpWidget(
          createSetPasscodeScreen(mockSettingsService, mockPasscodeService));

      // Enter passcodes
      await tester.enterText(
          find.byKey(SetPasscodeScreen.passcodeTextField), passcode);
      await tester.enterText(
          find.byKey(SetPasscodeScreen.repeatPasscodeTextField),
          repeatPasscode);

      // Tap the submit button
      await tester.tap(find.widgetWithText(TextButton, "Continue"));
      await tester.pumpAndSettle();

      // Verify that the passcode is set correctly
      verifyNever(mockPasscodeService.setPasscode(passcode));
      verify(mockPasscodeService.validatePasscode(passcode));
      verify(mockPasscodeService.validatePasscode(repeatPasscode));
      expect(find.byType(SetPasscodeScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.text('Passwords do not match'), findsOneWidget);
    });

    testWidgets(
        'given passcode screen when setting invalid passcode then show warning',
        (WidgetTester tester) async {
      String invalidPasscode = '1'; // min length is 4
      when(mockPasscodeService.validatePasscode(invalidPasscode))
          .thenAnswer((_) => false);
      when(mockPasscodeService.setPasscode(invalidPasscode))
          .thenAnswer((_) => false);

      // Build the SetPasscode widget
      await tester.pumpWidget(
          createSetPasscodeScreen(mockSettingsService, mockPasscodeService));

      // Enter passcodes
      await tester.enterText(
          find.byKey(SetPasscodeScreen.passcodeTextField), invalidPasscode);
      await tester.enterText(
          find.byKey(SetPasscodeScreen.repeatPasscodeTextField),
          invalidPasscode);

      // Tap the submit button
      await tester.tap(find.widgetWithText(TextButton, "Continue"));
      await tester.pumpAndSettle();

      // Verify that the passcode is set correctly
      verify(mockPasscodeService.validatePasscode(invalidPasscode));
      verifyNever(mockPasscodeService.setPasscode(invalidPasscode));
      expect(find.byType(SetPasscodeScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.text('Password is invalid'), findsOneWidget);
      expect(find.text('Repeat password is invalid'), findsOneWidget);
    });
  });
}
