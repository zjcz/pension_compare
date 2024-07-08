import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/app/home/views/home_screen.dart';
import 'package:pension_compare/app/passcode/controller/passcode_service.dart';
import 'package:pension_compare/app/passcode/views/change_passcode_screen.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/route_config.dart';
import 'package:pension_compare/service_locator.dart';

import 'change_passcode_screen_test.mocks.dart';

Widget createChangePasscodeScreen(SettingsService mockSettingsService,
    PasscodeService mockPasscodeService, DatabaseService mockDatabaseService) {
  getIt.registerSingleton<SettingsService>(mockSettingsService);
  getIt.registerSingleton<PasscodeService>(mockPasscodeService);

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return ProviderScope(
        child: MaterialApp.router(
            routerConfig: setupRouter(
      initialLocation: RouteDefs.passcodeChange,
      initialExtra: mockDatabaseService,
      testing: true,
    )));
  });
}

@GenerateMocks([SettingsService, PasscodeService, DatabaseService])
void main() {
  late MockPasscodeService mockPasscodeService;
  late MockSettingsService mockSettingsService;
  late MockDatabaseService mockDatabaseService;

  setUp(() async {
    mockPasscodeService = MockPasscodeService();
    mockSettingsService = MockSettingsService();
    mockDatabaseService = MockDatabaseService();

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

  group('Change Passcode Screen', () {
    testWidgets('given new screen when loading screen then expect widgets',
        (WidgetTester tester) async {
      // Build the SetPasscode widget
      await tester.pumpWidget(createChangePasscodeScreen(
          mockSettingsService, mockPasscodeService, mockDatabaseService));

      // Verify that the SetPasscode widget renders correctly
      expect(find.byType(ChangePasscodeScreen), findsOneWidget);
      expect(find.text('Change Passcode'), findsOneWidget);
      expect(find.text('Enter your existing passcode:'), findsOneWidget);
      expect(
          find.text('Enter your new 4 to 10 digit passcode:'), findsOneWidget);
      expect(find.text('Repeat your new passcode:'), findsOneWidget);
      expect(find.byType(TextField), findsExactly(3));
      expect(find.byKey(ChangePasscodeScreen.existingPasscodeTextField),
          findsOneWidget);
      expect(find.byKey(ChangePasscodeScreen.newPasscodeTextField),
          findsOneWidget);
      expect(find.byKey(ChangePasscodeScreen.repeatPasscodeTextField),
          findsOneWidget);
      expect(find.widgetWithText(TextButton, "Continue"), findsOneWidget);
    });

    testWidgets(
        'given passcode screen when setting valid passcode then close screen',
        (WidgetTester tester) async {
      String existingPasscode = '1234';
      String newPasscode = '5678';
      when(mockPasscodeService.validatePasscode(existingPasscode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.validatePasscode(newPasscode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.testPasscode(existingPasscode))
          .thenAnswer((_) async => true);
      when(mockPasscodeService.changePasscode(newPasscode, mockDatabaseService))
          .thenReturn(true);

      // Build the SetPasscode widget
      await tester.pumpWidget(createChangePasscodeScreen(
          mockSettingsService, mockPasscodeService, mockDatabaseService));

      // Enter passcodes
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.existingPasscodeTextField),
          existingPasscode);
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.newPasscodeTextField), newPasscode);
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.repeatPasscodeTextField),
          newPasscode);
      await tester.pumpAndSettle();

      // Tap the submit button
      await tester.tap(find.widgetWithText(TextButton, "Continue"));
      await tester.pumpAndSettle();

      // Verify that the passcode is set correctly
      verify(mockPasscodeService.validatePasscode(existingPasscode));
      verify(mockPasscodeService.validatePasscode(newPasscode));
      verify(mockPasscodeService.testPasscode(existingPasscode)).called(1);
      verify(mockPasscodeService.changePasscode(
              newPasscode, mockDatabaseService))
          .called(1);
      expect(find.byType(ChangePasscodeScreen), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets(
        'given passcode screen when entering incorrect existing passcodes then show warning',
        (WidgetTester tester) async {
      String existingPasscode = '1234';
      String newPasscode = '5678';
      when(mockPasscodeService.validatePasscode(existingPasscode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.validatePasscode(newPasscode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.validatePasscode(newPasscode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.testPasscode(existingPasscode))
          .thenAnswer((_) async => false);
      when(mockPasscodeService.changePasscode(newPasscode, mockDatabaseService))
          .thenAnswer((_) => false);

      // Build the SetPasscode widget
      await tester.pumpWidget(createChangePasscodeScreen(
          mockSettingsService, mockPasscodeService, mockDatabaseService));

      // Enter passcodes
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.existingPasscodeTextField),
          existingPasscode);
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.newPasscodeTextField), newPasscode);
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.repeatPasscodeTextField),
          newPasscode);

      // Tap the submit button
      await tester.tap(find.widgetWithText(TextButton, "Continue"));
      await tester.pumpAndSettle();

      // Verify that the passcode is set correctly
      verify(mockPasscodeService.validatePasscode(existingPasscode));
      verify(mockPasscodeService.validatePasscode(newPasscode));
      verify(mockPasscodeService.testPasscode(existingPasscode)).called(1);
      verifyNever(
          mockPasscodeService.changePasscode(newPasscode, mockDatabaseService));
      expect(find.byType(ChangePasscodeScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.text('Existing passcode incorrect. Please try again.'),
          findsOneWidget);
    });

    testWidgets(
        'given passcode screen when entering different new passcodes then show warning',
        (WidgetTester tester) async {
      String existingPasscode = '1234';
      String newPasscode = '1111';
      String repeatPasscode = '2222';
      when(mockPasscodeService.validatePasscode(existingPasscode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.validatePasscode(newPasscode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.validatePasscode(repeatPasscode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.testPasscode(existingPasscode))
          .thenAnswer((_) async => true);
      when(mockPasscodeService.changePasscode(newPasscode,
              mockDatabaseService))
          .thenAnswer((_) => false);

      // Build the SetPasscode widget
      await tester.pumpWidget(createChangePasscodeScreen(
          mockSettingsService, mockPasscodeService, mockDatabaseService));

      // Enter passcodes
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.existingPasscodeTextField),
          existingPasscode);
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.newPasscodeTextField), newPasscode);
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.repeatPasscodeTextField),
          repeatPasscode);

      // Tap the submit button
      await tester.tap(find.widgetWithText(TextButton, "Continue"));
      await tester.pumpAndSettle();

      // Verify that the passcode is set correctly
      verify(mockPasscodeService.validatePasscode(existingPasscode));
      verify(mockPasscodeService.validatePasscode(newPasscode));
      verify(mockPasscodeService.validatePasscode(repeatPasscode));
      verifyNever(mockPasscodeService.testPasscode(existingPasscode));
      verifyNever(mockPasscodeService.changePasscode(newPasscode,
          mockDatabaseService));
      expect(find.byType(ChangePasscodeScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.text('New passcodes do not match'), findsOneWidget);
    });

    testWidgets(
        'given passcode screen when setting invalid new passcode then show warning',
        (WidgetTester tester) async {
      String existingPasscode = '1234';
      String invalidPasscode = '1'; // min length is 4
      when(mockPasscodeService.validatePasscode(existingPasscode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.validatePasscode(invalidPasscode))
          .thenAnswer((_) => false);
      when(mockPasscodeService.testPasscode(existingPasscode))
          .thenAnswer((_) async => true);
      when(mockPasscodeService.changePasscode(invalidPasscode,
              mockDatabaseService))
          .thenAnswer((_) => false);

      // Build the SetPasscode widget
      await tester.pumpWidget(createChangePasscodeScreen(
          mockSettingsService, mockPasscodeService, mockDatabaseService));

      // Enter passcodes
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.existingPasscodeTextField),
          existingPasscode);
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.newPasscodeTextField),
          invalidPasscode);
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.repeatPasscodeTextField),
          invalidPasscode);

      // Tap the submit button
      await tester.tap(find.widgetWithText(TextButton, "Continue"));
      await tester.pumpAndSettle();

      // Verify that the passcode is set correctly
      verify(mockPasscodeService.validatePasscode(existingPasscode));
      verify(mockPasscodeService.validatePasscode(invalidPasscode));
      verifyNever(mockPasscodeService.testPasscode(existingPasscode));
      verifyNever(mockPasscodeService.changePasscode(invalidPasscode,
          mockDatabaseService));
      expect(find.byType(ChangePasscodeScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.text('New passcode is invalid'), findsOneWidget);
    });
  });

  group('Change Passcode Screen - Invalid character handling', () {
    testWidgets(
        'given change passcode screen when entering invalid characters in existing passcode field then expect warning message',
        (WidgetTester tester) async {
      String existingPasscode = '123a';
      String newPasscode = '1111';
      String repeatPasscode = '1111';
      when(mockPasscodeService.validatePasscode(existingPasscode))
          .thenAnswer((_) => false);
      when(mockPasscodeService.validatePasscode(newPasscode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.changePasscode(newPasscode,
              mockDatabaseService))
          .thenAnswer((_) => false);

      // Build the SetPasscode widget
      await tester.pumpWidget(createChangePasscodeScreen(
          mockSettingsService, mockPasscodeService, mockDatabaseService));

      // Enter passcodes
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.existingPasscodeTextField),
          existingPasscode);
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.newPasscodeTextField), newPasscode);
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.repeatPasscodeTextField),
          repeatPasscode);

      // Tap the submit button
      await tester.tap(find.widgetWithText(TextButton, "Continue"));
      await tester.pumpAndSettle();

      // Verify that the passcode is set correctly
      verify(mockPasscodeService.validatePasscode(existingPasscode));
      verify(mockPasscodeService.validatePasscode(newPasscode));
      verifyNever(mockPasscodeService.changePasscode(newPasscode,
           mockDatabaseService));
      expect(find.byType(ChangePasscodeScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.text('Existing passcode is invalid'), findsOneWidget);
    });

    testWidgets(
        'given change passcode screen when entering invalid characters in new passcode field then expect warning message',
        (WidgetTester tester) async {
      String existingPasscode = '1234';
      String newPasscode = '111a';
      String repeatPasscode = '1111';
      when(mockPasscodeService.validatePasscode(existingPasscode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.validatePasscode(newPasscode))
          .thenAnswer((_) => false);
      when(mockPasscodeService.validatePasscode(repeatPasscode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.testPasscode(existingPasscode))
          .thenAnswer((_) async => false);
      when(mockPasscodeService.changePasscode(newPasscode,
              mockDatabaseService))
          .thenAnswer((_) => false);

      // Build the SetPasscode widget
      await tester.pumpWidget(createChangePasscodeScreen(
          mockSettingsService, mockPasscodeService, mockDatabaseService));

      // Enter passcodes
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.existingPasscodeTextField),
          existingPasscode);
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.newPasscodeTextField), newPasscode);
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.repeatPasscodeTextField),
          repeatPasscode);

      // Tap the submit button
      await tester.tap(find.widgetWithText(TextButton, "Continue"));
      await tester.pumpAndSettle();

      // Verify that the passcode is set correctly
      verify(mockPasscodeService.validatePasscode(existingPasscode));
      verify(mockPasscodeService.validatePasscode(newPasscode));
      //verify(mockPasscodeService.validatePasscode(repeatPasscode));
      verifyNever(mockPasscodeService.testPasscode(existingPasscode));
      verifyNever(mockPasscodeService.changePasscode(newPasscode,
          mockDatabaseService));
      expect(find.byType(ChangePasscodeScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.text('New passcode is invalid'), findsOneWidget);
    });

    testWidgets(
        'given change passcode screen when entering invalid characters in repeat passcode field then expect warning message',
        (WidgetTester tester) async {
      // Note - verify on the repeat field is only triggered if it matches the new passcode field
      String existingPasscode = '1234';
      String newPasscode = '111a';
      String repeatPasscode = '111a';
      when(mockPasscodeService.validatePasscode(existingPasscode))
          .thenAnswer((_) => true);
      when(mockPasscodeService.validatePasscode(newPasscode))
          .thenAnswer((_) => false);
      when(mockPasscodeService.validatePasscode(repeatPasscode))
          .thenAnswer((_) => false);
      when(mockPasscodeService.testPasscode(existingPasscode))
          .thenAnswer((_) async => false);
      when(mockPasscodeService.changePasscode(newPasscode,
              mockDatabaseService))
          .thenAnswer((_) => false);

      // Build the SetPasscode widget
      await tester.pumpWidget(createChangePasscodeScreen(
          mockSettingsService, mockPasscodeService, mockDatabaseService));

      // Enter passcodes
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.existingPasscodeTextField),
          existingPasscode);
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.newPasscodeTextField), newPasscode);
      await tester.enterText(
          find.byKey(ChangePasscodeScreen.repeatPasscodeTextField),
          repeatPasscode);

      // Tap the submit button
      await tester.tap(find.widgetWithText(TextButton, "Continue"));
      await tester.pumpAndSettle();

      // Verify that the passcode is set correctly
      verify(mockPasscodeService.validatePasscode(existingPasscode));
      verify(mockPasscodeService.validatePasscode(newPasscode));
      verifyNever(mockPasscodeService.testPasscode(existingPasscode));
      verifyNever(mockPasscodeService.changePasscode(newPasscode,
          mockDatabaseService));
      expect(find.byType(ChangePasscodeScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.text('Repeat passcode is invalid'), findsOneWidget);
    });
  });
}
