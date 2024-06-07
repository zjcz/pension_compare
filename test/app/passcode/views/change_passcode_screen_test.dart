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

Widget createChangePasscodeScreen(
    SettingsService mockSettingsService, PasscodeService mockPasscodeService, DatabaseService mockDatabaseService) {
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
              retirementDate: null,
              targetIncome: null,
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
      await tester.pumpWidget(
          createChangePasscodeScreen(mockSettingsService, mockPasscodeService, mockDatabaseService));

      // Verify that the SetPasscode widget renders correctly
      expect(find.byType(ChangePasscodeScreen), findsOneWidget);
      expect(find.text('Change Passcode'), findsOneWidget);
      expect(
          find.text('Enter your existing 6-digit passcode:'), findsOneWidget);
      expect(find.text('Enter your new 6-digit passcode:'), findsOneWidget);
      expect(find.text('Repeat your new 6-digit passcode:'), findsOneWidget);
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
          .thenAnswer((_) async => true);
      when(mockPasscodeService.setPasscode(newPasscode, databaseService: mockDatabaseService)).thenReturn(true);

      // Build the SetPasscode widget
      await tester.pumpWidget(
          createChangePasscodeScreen(mockSettingsService, mockPasscodeService, mockDatabaseService));

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
      verify(mockPasscodeService.validatePasscode(existingPasscode)).called(1);
      verify(mockPasscodeService.setPasscode(newPasscode, databaseService: mockDatabaseService)).called(1);
      expect(find.byType(ChangePasscodeScreen), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
    });


    testWidgets(
        'given passcode screen when entering invalid existing passcodes then show warning',
        (WidgetTester tester) async {
      String existingPasscode = '1234';
      String newPasscode = '5678';
      String repeatPasscode = '5678';
      when(mockPasscodeService.validatePasscode(existingPasscode))
          .thenAnswer((_) async => false);
      when(mockPasscodeService.setPasscode(newPasscode, databaseService: mockDatabaseService))
          .thenAnswer((_) => false);

      // Build the SetPasscode widget
      await tester.pumpWidget(
          createChangePasscodeScreen(mockSettingsService, mockPasscodeService, mockDatabaseService));

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
      verify(mockPasscodeService.validatePasscode(existingPasscode)).called(1);
      verifyNever(mockPasscodeService.setPasscode(newPasscode, databaseService: mockDatabaseService));
      expect(find.byType(ChangePasscodeScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.text('Existing passcode incorrect. Please try again.'), findsOneWidget);
    });

    testWidgets(
        'given passcode screen when entering different new passcodes then show warning',
        (WidgetTester tester) async {
      String existingPasscode = '1234';
      String newPasscode = '1111';
      String repeatPasscode = '2222';
      when(mockPasscodeService.validatePasscode(existingPasscode))
          .thenAnswer((_) async => true);
      when(mockPasscodeService.setPasscode(newPasscode, databaseService: mockDatabaseService))
          .thenAnswer((_) => false);

      // Build the SetPasscode widget
      await tester.pumpWidget(
          createChangePasscodeScreen(mockSettingsService, mockPasscodeService, mockDatabaseService));

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
      verifyNever(mockPasscodeService.validatePasscode(existingPasscode));
      verifyNever(mockPasscodeService.setPasscode(newPasscode, databaseService: mockDatabaseService));
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
          .thenAnswer((_) async => true);
      when(mockPasscodeService.setPasscode(invalidPasscode, databaseService: mockDatabaseService))
          .thenAnswer((_) => false);

      // Build the SetPasscode widget
      await tester.pumpWidget(
          createChangePasscodeScreen(mockSettingsService, mockPasscodeService, mockDatabaseService));

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
      verify(mockPasscodeService.validatePasscode(existingPasscode)).called(1);
      verify(mockPasscodeService.setPasscode(invalidPasscode, databaseService: mockDatabaseService)).called(1);
      expect(find.byType(ChangePasscodeScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
      expect(
          find.text('New passcode incorrect. Please try again.'), findsOneWidget);
    });
  });
}
