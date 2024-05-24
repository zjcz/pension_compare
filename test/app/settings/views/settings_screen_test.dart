import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:pension_compare/app/settings/models/user_settings.dart';
import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/app/settings/views/widgets/edit_settings_widget.dart';
import 'package:pension_compare/helpers/analytics_helper.dart';
import 'package:pension_compare/helpers/date_helper.dart';
import 'package:pension_compare/helpers/currency_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/app/home/views/home_screen.dart';
import 'package:pension_compare/route_config.dart';
import 'package:pension_compare/service_locator.dart';

import 'settings_screen_test.mocks.dart';

Widget createSettingsScreen(SettingsService settingsService,
    DatabaseService databaseService, AnalyticsHelper mockAnalyticsHelper) {
  getIt.registerSingleton<SettingsService>(settingsService);
  getIt.registerSingleton<AnalyticsHelper>(mockAnalyticsHelper);

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return ProviderScope(
        overrides: [
          DatabaseService.provider.overrideWithValue(databaseService),
        ],
        child: MaterialApp.router(
          routerConfig: setupRouter(initialLocation: RouteDefs.editSettings),
        ));
  });
}

DatabaseService createMockDatabaseService() {
  DatabaseService ds = MockDatabaseService();
  // setup any mocks required by all tests
  return ds;
}

@GenerateMocks([SettingsService, DatabaseService, AnalyticsHelper])
void main() {
  setUp(() async {
    // reset before each test to prevent errors with duplicate DatabaseService
    await getIt.reset();
  });

  group('Test editing of settings', () {
    testWidgets('show the settings screen with no existing settings',
        (tester) async {
      final settingsService = MockSettingsService();
      when(settingsService.getAllSettings()).thenAnswer((_) async =>
          const Settings(
              retirementDate: null,
              targetIncome: null,
              acceptTermsAndConditions: null,
              acceptFinancialAdviceWarning: null,
              welcomeScreenDismissed: null,
              optIntoAnalyticsWarning: false));
      final mockAnalyticsHelper = MockAnalyticsHelper();
      when(mockAnalyticsHelper.enableAnalytics(false))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createSettingsScreen(
          settingsService, createMockDatabaseService(), mockAnalyticsHelper));
      await tester.pumpAndSettle();

      expect(find.text("Settings"), findsOneWidget);

      expect(find.bySemanticsLabel('Planned Retirement Date'), findsOneWidget);
      expect(find.bySemanticsLabel('Target Monthly Income'), findsOneWidget);

      expect(find.text("This is the date you plan to retire."), findsOneWidget);
      expect(
          find.text(
              "This is the amount you plan to receive as a monthly income when you retire.  If you are unsure you can leave this blank for now."),
          findsOneWidget);

      expect(
          find.byKey(EditSettingsWidget.editSettingRetirementDateKey), findsOneWidget);
      expect(find.byKey(EditSettingsWidget.editSettingTargetIncomeKey), findsOneWidget);

      expect(find.widgetWithText(TextButton, "Save"), findsOneWidget);
      expect(find.widgetWithText(TextButton, "Delete All"), findsOneWidget);

      verify(settingsService.getAllSettings()).called(1);
    });

    testWidgets('show the settings screen with existing settings',
        (tester) async {
      DateTime retirementDate = DateHelper.getToday();
      double targetValue = 12345.0;
      bool acceptTermsAndConditions = true;
      bool acceptFinancialAdviceWarning = true;
      bool welcomeScreenDismissed = true;
      bool optIntoAnalyticsWarning = true;

      final settingsService = MockSettingsService();
      when(settingsService.getAllSettings()).thenAnswer((_) async => Settings(
          retirementDate: retirementDate,
          targetIncome: targetValue,
          acceptTermsAndConditions: acceptTermsAndConditions,
          acceptFinancialAdviceWarning: acceptFinancialAdviceWarning,
          welcomeScreenDismissed: welcomeScreenDismissed,
          optIntoAnalyticsWarning: optIntoAnalyticsWarning));
      final mockAnalyticsHelper = MockAnalyticsHelper();
      when(mockAnalyticsHelper.enableAnalytics(false))
          .thenAnswer((_) async => {});

      // Build your app and trigger a frame
      await tester.pumpWidget(createSettingsScreen(
          settingsService, createMockDatabaseService(), mockAnalyticsHelper));
      await tester.pumpAndSettle();

      expect(find.text(DateHelper.formatDate(retirementDate)), findsOneWidget);
      expect(find.text(CurrencyHelper.formatCurrency(targetValue)),
          findsOneWidget);

      verify(settingsService.getAllSettings()).called(1);
    });

    testWidgets('Set date of date picker', (WidgetTester tester) async {
      final settingsService = MockSettingsService();
      when(settingsService.getAllSettings()).thenAnswer((_) async =>
          const Settings(
              retirementDate: null,
              targetIncome: null,
              acceptTermsAndConditions: null,
              acceptFinancialAdviceWarning: null,
              welcomeScreenDismissed: null,
              optIntoAnalyticsWarning: false));
      final mockAnalyticsHelper = MockAnalyticsHelper();
      when(mockAnalyticsHelper.enableAnalytics(false))
          .thenAnswer((_) async => {});

      // Build your app and trigger a frame
      await tester.pumpWidget(createSettingsScreen(
          settingsService, createMockDatabaseService(), mockAnalyticsHelper));
      await tester.pumpAndSettle();

      // Find the TextFormField by key
      final fieldFinder = find.byKey(EditSettingsWidget.editSettingRetirementDateKey);

      // Check that the TextFormField exists
      expect(fieldFinder, findsOneWidget);

      // Tap on the TextFormField to open the date picker
      await tester.tap(fieldFinder);
      await tester.pumpAndSettle();

      // Find the date picker
      final datePickerFinder = find.byType(DatePickerDialog);

      // Check that the date picker is displayed
      expect(datePickerFinder, findsOneWidget);

      // Set the date to today, and tap OK
      final DateTime newDate = DateHelper.getToday();
      await tester.tap(find.text(newDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      expect(find.text(DateHelper.formatDate(newDate)), findsOneWidget);
    });
  });

  group('Test interaction of settings screen', () {
    testWidgets('save settings with no previous settings', (tester) async {
      DateTime retirementDate = DateHelper.getToday();
      double targetValue = 12345.0;
      bool optIntoAnalyticsWarning = true;

      final settingsService = MockSettingsService();
      when(settingsService.getAllSettings()).thenAnswer((_) async =>
          const Settings(
              retirementDate: null,
              targetIncome: null,
              acceptTermsAndConditions: null,
              acceptFinancialAdviceWarning: null,
              welcomeScreenDismissed: null,
              optIntoAnalyticsWarning: false));
      when(settingsService.saveUserSettings(UserSettings(
              retirementDate: retirementDate,
              targetIncome: targetValue,
              optIntoAnalyticsWarning: optIntoAnalyticsWarning)))
          .thenAnswer((_) async => true);
      final mockAnalyticsHelper = MockAnalyticsHelper();
      when(mockAnalyticsHelper.enableAnalytics(false))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createSettingsScreen(
          settingsService, createMockDatabaseService(), mockAnalyticsHelper));
      await tester.pumpAndSettle();

      // Set the date of the date picker
      await tester.tap(find.byKey(EditSettingsWidget.editSettingRetirementDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(retirementDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(EditSettingsWidget.editSettingTargetIncomeKey),
          targetValue.toString());

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));

      verify(settingsService.getAllSettings()).called(1);
      verify(settingsService.saveUserSettings(UserSettings(
              retirementDate: retirementDate,
              targetIncome: targetValue,
              optIntoAnalyticsWarning: optIntoAnalyticsWarning)))
          .called(1);
    });

    testWidgets('update existing settings', (tester) async {
      DateTime originalRetirementDate = DateTime(2025, 1, 10);
      double originalTargetValue = 12345.0;
      bool originalAcceptTermsAndConditions = true;
      bool originalAcceptFinancialAdviceWarning = true;
      bool originalWelcomeScreenDismissed = true;
      bool originalOptIntoAnalyticsWarning = true;
      DateTime newRetirementDate = DateTime(2025, 1, 20);
      double newTargetValue = 98765.43;
      bool newOptIntoAnalyticsWarning = false;

      final settingsService = MockSettingsService();
      when(settingsService.getAllSettings()).thenAnswer((_) async => Settings(
          retirementDate: originalRetirementDate,
          targetIncome: originalTargetValue,
          acceptTermsAndConditions: originalAcceptTermsAndConditions,
          acceptFinancialAdviceWarning: originalAcceptFinancialAdviceWarning,
          welcomeScreenDismissed: originalWelcomeScreenDismissed,
          optIntoAnalyticsWarning: originalOptIntoAnalyticsWarning));
      when(settingsService.saveUserSettings(UserSettings(
              retirementDate: newRetirementDate,
              targetIncome: newTargetValue,
              optIntoAnalyticsWarning: newOptIntoAnalyticsWarning)))
          .thenAnswer((_) async => true);
      final mockAnalyticsHelper = MockAnalyticsHelper();
      when(mockAnalyticsHelper.enableAnalytics(false))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createSettingsScreen(
          settingsService, createMockDatabaseService(), mockAnalyticsHelper));
      await tester.pumpAndSettle();

      // Set the date of the date picker
      await tester.tap(find.byKey(EditSettingsWidget.editSettingRetirementDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(newRetirementDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Enter values into the TextFormFields
      await tester.enterText(find.byKey(EditSettingsWidget.editSettingTargetIncomeKey),
          newTargetValue.toString());

      //tap the opt into analytics switch
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));

      verify(settingsService.getAllSettings()).called(1);
      verify(settingsService.saveUserSettings(UserSettings(
              retirementDate: newRetirementDate,
              targetIncome: newTargetValue,
              optIntoAnalyticsWarning: newOptIntoAnalyticsWarning)))
          .called(1);
    });

    testWidgets('navigate back to home screen after save', (tester) async {
      DateTime originalRetirementDate = DateTime(2025, 1, 10);
      double originalTargetValue = 12345.0;
      bool originalAcceptTermsAndConditions = true;
      bool originalAcceptFinancialAdviceWarning = true;
      bool originalWelcomeScreenDismissed = true;
      bool originalOptIntoAnalyticsWarning = true;
      double newTargetValue = 98765.43;

      final settingsService = MockSettingsService();
      when(settingsService.getAllSettings()).thenAnswer((_) async => Settings(
          retirementDate: originalRetirementDate,
          targetIncome: originalTargetValue,
          acceptTermsAndConditions: originalAcceptTermsAndConditions,
          acceptFinancialAdviceWarning: originalAcceptFinancialAdviceWarning,
          welcomeScreenDismissed: originalWelcomeScreenDismissed,
          optIntoAnalyticsWarning: originalOptIntoAnalyticsWarning));
      when(settingsService.saveUserSettings(UserSettings(
              retirementDate: originalRetirementDate,
              targetIncome: newTargetValue,
              optIntoAnalyticsWarning: originalOptIntoAnalyticsWarning)))
          .thenAnswer((_) async => true);
      final mockAnalyticsHelper = MockAnalyticsHelper();
      when(mockAnalyticsHelper.enableAnalytics(false))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createSettingsScreen(
          settingsService, createMockDatabaseService(), mockAnalyticsHelper));
      await tester.pumpAndSettle();

      // Enter values into the TextFormFields
      await tester.enterText(find.byKey(EditSettingsWidget.editSettingTargetIncomeKey),
          newTargetValue.toString());

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      // should navigate back to home screen
      expect(find.byType(HomeScreen), findsOneWidget);

      verify(settingsService.getAllSettings()).called(1);
      verify(settingsService.saveUserSettings(UserSettings(
              retirementDate: originalRetirementDate,
              targetIncome: newTargetValue,
              optIntoAnalyticsWarning: originalOptIntoAnalyticsWarning)))
          .called(1);
    });
  });

  group('Test validation of settings screen', () {
    testWidgets('validation should allow empty values to remain',
        (tester) async {
      final settingsService = MockSettingsService();
      when(settingsService.getAllSettings()).thenAnswer((_) async =>
          const Settings(
              retirementDate: null,
              targetIncome: null,
              acceptTermsAndConditions: null,
              acceptFinancialAdviceWarning: null,
              welcomeScreenDismissed: null,
              optIntoAnalyticsWarning: false));
      when(settingsService.saveUserSettings(const UserSettings(
              retirementDate: null,
              targetIncome: null,
              optIntoAnalyticsWarning: false)))
          .thenAnswer((_) async => true);
      final mockAnalyticsHelper = MockAnalyticsHelper();
      when(mockAnalyticsHelper.enableAnalytics(false))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createSettingsScreen(
          settingsService, createMockDatabaseService(), mockAnalyticsHelper));
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      verify(settingsService.getAllSettings()).called(1);
      verify(settingsService.saveUserSettings(const UserSettings(
              retirementDate: null,
              targetIncome: null,
              optIntoAnalyticsWarning: false)))
          .called(1);
    });

    testWidgets('validation should allow empty values to be entered',
        (tester) async {
      double targetValue = 12345.0;

      final settingsService = MockSettingsService();
      when(settingsService.getAllSettings()).thenAnswer((_) async => Settings(
          retirementDate: null,
          targetIncome: targetValue,
          acceptTermsAndConditions: null,
          acceptFinancialAdviceWarning: null,
          welcomeScreenDismissed: null,
          optIntoAnalyticsWarning: false));
      when(settingsService.saveUserSettings(const UserSettings(
              retirementDate: null,
              targetIncome: null,
              optIntoAnalyticsWarning: false)))
          .thenAnswer((_) async => true);
      final mockAnalyticsHelper = MockAnalyticsHelper();
      when(mockAnalyticsHelper.enableAnalytics(false))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createSettingsScreen(
          settingsService, createMockDatabaseService(), mockAnalyticsHelper));
      await tester.pumpAndSettle();

      // Set the date of the date picker
      // Currently not possible to set the data to unset / null

      await tester.enterText(
          find.byKey(EditSettingsWidget.editSettingTargetIncomeKey), '');

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      verify(settingsService.getAllSettings()).called(1);
      verify(settingsService.saveUserSettings(const UserSettings(
              retirementDate: null,
              targetIncome: null,
              optIntoAnalyticsWarning: false)))
          .called(1);
    });

    testWidgets('validation should prevent invalid target income value',
        (tester) async {
      DateTime retirementDate = DateHelper.getToday();
      String invalidTargetValue = 'invalid';

      final settingsService = MockSettingsService();
      when(settingsService.getAllSettings()).thenAnswer((_) async =>
          const Settings(
              retirementDate: null,
              targetIncome: null,
              acceptTermsAndConditions: null,
              acceptFinancialAdviceWarning: null,
              welcomeScreenDismissed: null,
              optIntoAnalyticsWarning: false));
      when(settingsService.saveUserSettings(UserSettings(
              retirementDate: retirementDate,
              targetIncome: null,
              optIntoAnalyticsWarning: false)))
          .thenAnswer((_) async => true);
      final mockAnalyticsHelper = MockAnalyticsHelper();
      when(mockAnalyticsHelper.enableAnalytics(false))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createSettingsScreen(
          settingsService, createMockDatabaseService(), mockAnalyticsHelper));
      await tester.pumpAndSettle();

      // Set the date of the date picker
      await tester.tap(find.byKey(EditSettingsWidget.editSettingRetirementDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(retirementDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(EditSettingsWidget.editSettingTargetIncomeKey),
          invalidTargetValue);

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      expect(find.text("Please enter a valid number"), findsOneWidget);

      verify(settingsService.getAllSettings()).called(1);
      verifyNever(settingsService.saveUserSettings(UserSettings(
          retirementDate: retirementDate,
          targetIncome: null,
          optIntoAnalyticsWarning: false)));
    });
  });

  group('Test delete all button', () {
    testWidgets('tapping the delete all button displays warning prompt',
        (tester) async {
      final settingsService = MockSettingsService();
      when(settingsService.getAllSettings()).thenAnswer((_) async =>
          const Settings(
              retirementDate: null,
              targetIncome: null,
              acceptTermsAndConditions: null,
              acceptFinancialAdviceWarning: null,
              welcomeScreenDismissed: null,
              optIntoAnalyticsWarning: false));
      final mockAnalyticsHelper = MockAnalyticsHelper();
      when(mockAnalyticsHelper.enableAnalytics(false))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createSettingsScreen(
          settingsService, createMockDatabaseService(), mockAnalyticsHelper));
      await tester.pumpAndSettle();

      // check the elements are not yet visible
      expect(find.text("Delete All Data?"), findsNothing);
      expect(find.text("Are you sure you want to delete all data in the app?"),
          findsNothing);

      // Tap the delete button
      await tester.tap(find.widgetWithText(TextButton, "Delete All"));
      await tester.pumpAndSettle();

      expect(find.text("Delete All Data?"), findsOneWidget);
      expect(find.text("Are you sure you want to delete all data in the app?"),
          findsOneWidget);
    });

    testWidgets('tapping no dismissess the warning prompt', (tester) async {
      final settingsService = MockSettingsService();
      when(settingsService.getAllSettings()).thenAnswer((_) async =>
          const Settings(
              retirementDate: null,
              targetIncome: null,
              acceptTermsAndConditions: null,
              acceptFinancialAdviceWarning: null,
              welcomeScreenDismissed: null,
              optIntoAnalyticsWarning: false));
      final databaseService = createMockDatabaseService();
      when(databaseService.clearAllData()).thenAnswer((_) async => true);
      final mockAnalyticsHelper = MockAnalyticsHelper();
      when(mockAnalyticsHelper.enableAnalytics(false))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createSettingsScreen(
          settingsService, databaseService, mockAnalyticsHelper));
      await tester.pumpAndSettle();

      // Tap the delete button
      await tester.tap(find.widgetWithText(TextButton, "Delete All"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, "No"));
      await tester.pumpAndSettle();

      expect(find.text("Delete All Data?"), findsNothing);
      expect(find.text("Are you sure you want to delete all data in the app?"),
          findsNothing);
      expect(find.text("Settings"), findsOneWidget);

      verifyNever(databaseService.clearAllData());
    });

    testWidgets('tapping yes clears data and dismissess the warning prompt',
        (tester) async {
      final settingsService = MockSettingsService();
      when(settingsService.getAllSettings()).thenAnswer((_) async =>
          const Settings(
              retirementDate: null,
              targetIncome: null,
              acceptTermsAndConditions: null,
              acceptFinancialAdviceWarning: null,
              welcomeScreenDismissed: null,
              optIntoAnalyticsWarning: false));
      final databaseService = createMockDatabaseService();
      when(databaseService.clearAllData()).thenAnswer((_) async => true);
      final mockAnalyticsHelper = MockAnalyticsHelper();
      when(mockAnalyticsHelper.enableAnalytics(false))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createSettingsScreen(
          settingsService, databaseService, mockAnalyticsHelper));
      await tester.pumpAndSettle();

      // Tap the delete button
      await tester.tap(find.widgetWithText(TextButton, "Delete All"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, "Yes"));
      await tester.pumpAndSettle();

      expect(find.text("Delete All Data?"), findsNothing);
      expect(find.text("Are you sure you want to delete all data in the app?"),
          findsNothing);
      expect(find.widgetWithText(SnackBar, "All data removed successfully!"),
          findsOneWidget); //look for snackbar notification

      // should navigate back to home screen
      expect(find.byType(HomeScreen), findsOneWidget);

      verify(databaseService.clearAllData()).called(1);
    });
  });

  group('Test analytics', () {
    testWidgets(
        'opting into analytics enables analytics and saves the setting',
        (tester) async {
      DateTime retirementDate = DateHelper.getToday();
      double targetValue = 12345.0;
      bool optIntoAnalyticsWarning = true;

      final settingsService = MockSettingsService();
      when(settingsService.getAllSettings()).thenAnswer((_) async =>
          const Settings(
              retirementDate: null,
              targetIncome: null,
              acceptTermsAndConditions: null,
              acceptFinancialAdviceWarning: null,
              welcomeScreenDismissed: null,
              optIntoAnalyticsWarning: false));
      final databaseService = createMockDatabaseService();
      when(databaseService.clearAllData()).thenAnswer((_) async => true);
      final mockAnalyticsHelper = MockAnalyticsHelper();
      when(mockAnalyticsHelper.enableAnalytics(true))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createSettingsScreen(
          settingsService, createMockDatabaseService(), mockAnalyticsHelper));
      await tester.pumpAndSettle();

      // Set the date of the date picker
      await tester.tap(find.byKey(EditSettingsWidget.editSettingRetirementDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(retirementDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(EditSettingsWidget.editSettingTargetIncomeKey),
          targetValue.toString());

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));

      verify(settingsService.getAllSettings()).called(1);
      verify(settingsService.saveUserSettings(UserSettings(
              retirementDate: retirementDate,
              targetIncome: targetValue,
              optIntoAnalyticsWarning: optIntoAnalyticsWarning)))
          .called(1);
      verify(mockAnalyticsHelper.enableAnalytics(true)).called(1);
    });

    testWidgets(
        'opting out of analytics disables analytics and saves the setting',
        (tester) async {
      DateTime retirementDate = DateHelper.getToday();
      double targetValue = 12345.0;
      bool optIntoAnalyticsWarning = false;

      final settingsService = MockSettingsService();
      when(settingsService.getAllSettings()).thenAnswer((_) async =>
          const Settings(
              retirementDate: null,
              targetIncome: null,
              acceptTermsAndConditions: null,
              acceptFinancialAdviceWarning: null,
              welcomeScreenDismissed: null,
              optIntoAnalyticsWarning: true));
      final databaseService = createMockDatabaseService();
      when(databaseService.clearAllData()).thenAnswer((_) async => true);
      final mockAnalyticsHelper = MockAnalyticsHelper();
      when(mockAnalyticsHelper.enableAnalytics(false))
          .thenAnswer((_) async => {});

      await tester.pumpWidget(createSettingsScreen(
          settingsService, createMockDatabaseService(), mockAnalyticsHelper));
      await tester.pumpAndSettle();

      // Set the date of the date picker
      await tester.tap(find.byKey(EditSettingsWidget.editSettingRetirementDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(retirementDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(EditSettingsWidget.editSettingTargetIncomeKey),
          targetValue.toString());

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));

      verify(settingsService.getAllSettings()).called(1);
      verify(settingsService.saveUserSettings(UserSettings(
              retirementDate: retirementDate,
              targetIncome: targetValue,
              optIntoAnalyticsWarning: optIntoAnalyticsWarning)))
          .called(1);
      verify(mockAnalyticsHelper.enableAnalytics(false)).called(1);
    });
  });
}
