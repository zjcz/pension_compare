import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/app/pension/views/edit_pension_screen.dart';
import 'package:pension_compare/app/pension/views/pension_overview_screen.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/data/mapper/pension_mapper.dart';
import 'package:pension_compare/helpers/date_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/app/home/views/home_screen.dart';
import 'package:pension_compare/route_config.dart';
import 'package:pension_compare/service_locator.dart';

import 'edit_pension_screen_test.mocks.dart';

late MockSettingsService mockSettingsService;

Widget createEditScreen(Pension? pensionRecord, DatabaseService db,
    [bool withRouting = false]) {
  if (withRouting) {
    getIt.registerSingleton<SettingsService>(mockSettingsService);

    return ProviderScope(
        overrides: [
          DatabaseService.provider.overrideWithValue(db),
        ],
        child: MaterialApp.router(
          routerConfig: setupRouter(
              initialLocation: RouteDefs.editPension,
              initialExtra: pensionRecord == null
                  ? null
                  : PensionMapper.mapToModel(pensionRecord)),
        ));
  } else {
    PensionModel? pensionModel =
        pensionRecord == null ? null : PensionMapper.mapToModel(pensionRecord);

    return ProviderScope(
        overrides: [
          DatabaseService.provider.overrideWithValue(db),
        ],
        child: MaterialApp(
          home: EditPensionScreen(pension: pensionModel),
        ));
  }
}

DatabaseService createMockDatabaseService() {
  DatabaseService ds = MockDatabaseService();
  // setup any mocks required by all tests
  return ds;
}

@GenerateMocks([DatabaseService, SettingsService])
void main() {
  setUp(() async {
    mockSettingsService = MockSettingsService();

    when(mockSettingsService.getAllSettings())
        .thenAnswer((_) async => const Settings(
              acceptTermsAndConditions: false,
              acceptFinancialAdviceWarning: false,
              welcomeScreenDismissed: true,
              optIntoAnalyticsWarning: false,
            ));

    // reset before each test to prevent errors with duplicate objects
    await getIt.reset();
  });
  group('Test adding / editing of pension record', () {
    testWidgets('show the add screen with no pension record', (tester) async {
      await tester
          .pumpWidget(createEditScreen(null, createMockDatabaseService()));

      expect(find.text("Add Pension"), findsOneWidget);

      // Check that the Name TextFormField exists
      expect(find.bySemanticsLabel('Name'), findsOneWidget);

      expect(
          find.text(
              "This is a unique name you use to identify a pension policy.  It could be the name of the pension provider or the name of the workplace associated with the pension.  The choice is yours."),
          findsOneWidget);

      // Check that the Planned Retirement Date TextFormField exists
      expect(find.bySemanticsLabel('Planned Retirement Date'), findsOneWidget);

      expect(
          find.text(
              "This is the date you have set on this pension to retire.  You can have different dates for different pensions"),
          findsOneWidget);

      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byKey(EditPensionScreen.pensionNameKey), findsOneWidget);
      expect(
          find.byKey(EditPensionScreen.pensionMaturityDateKey), findsOneWidget);

      expect(find.widgetWithText(TextButton, "Save"), findsOneWidget);
    });

    testWidgets('show the edit screen with a pension record', (tester) async {
      Pension p = Pension(
          pensionId: 1, name: "Test Pension", maturityDate: DateTime.now());
      await tester.pumpWidget(createEditScreen(p, createMockDatabaseService()));
      await tester.pumpAndSettle();

      expect(find.text("Edit Pension"), findsOneWidget);
      expect(find.text(p.name), findsOneWidget);
      expect(find.text(DateHelper.formatDate(p.maturityDate)), findsOneWidget);
    });

    testWidgets('Set date of date picker', (WidgetTester tester) async {
      // Build your app and trigger a frame
      await tester
          .pumpWidget(createEditScreen(null, createMockDatabaseService()));

      // Find the TextFormField by key
      final fieldFinder = find.byKey(EditPensionScreen.pensionMaturityDateKey);

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

  group('Test database interaction of add/edit pension screen', () {
    testWidgets('save add new pension record', (tester) async {
      String name = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();
      final databaseService = createMockDatabaseService();
      when(databaseService.doesPensionNameExist(null, name))
          .thenAnswer((_) async => false);
      when(databaseService.createPension(name, maturityDate, null)).thenAnswer(
          (_) async =>
              Pension(pensionId: 1, name: name, maturityDate: maturityDate));

      await tester.pumpWidget(createEditScreen(null, databaseService, true));

      // Enter name into the TextFormField
      await tester.enterText(
          find.byKey(EditPensionScreen.pensionNameKey), name);
      await tester.pumpAndSettle();

      // Set the date of the date picker
      await tester.tap(find.byKey(EditPensionScreen.pensionMaturityDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(maturityDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      verify(databaseService.createPension(name, maturityDate, null)).called(1);
      verifyNever(databaseService.updatePension(1, name, maturityDate, null));
    });

    testWidgets('update existing pension record', (tester) async {
      int id = 3;
      String originalName = "Test Pension";
      DateTime originalMaturityDate = DateTime(2024, 1, 1);
      String newName = "New Pension";
      DateTime newMaturityDate = DateTime(2024, 1, 20);
      final databaseService = createMockDatabaseService();
      when(databaseService.doesPensionNameExist(id, newName))
          .thenAnswer((_) async => false);
      when(databaseService.updatePension(id, newName, newMaturityDate, null))
          .thenAnswer((_) async => true);

      await tester.pumpWidget(createEditScreen(
          Pension(
              pensionId: id,
              name: originalName,
              maturityDate: originalMaturityDate),
          databaseService, true));

      // Enter name into the TextFormField
      await tester.enterText(
          find.byKey(EditPensionScreen.pensionNameKey), newName);

      // Set the date of the date picker
      await tester.tap(find.byKey(EditPensionScreen.pensionMaturityDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(newMaturityDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));

      verifyNever(databaseService.createPension(newName, newMaturityDate, null));
      verify(databaseService.updatePension(id, newName, newMaturityDate, null))
          .called(1);
    });
  });

  group('Test navigation after save pension record', () {
    testWidgets('save add new pension record returns to pension summary screen',
        (tester) async {
      String name = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();
      final databaseService = createMockDatabaseService();
      when(databaseService.doesPensionNameExist(null, name))
          .thenAnswer((_) async => false);
      when(databaseService.createPension(name, maturityDate, null)).thenAnswer(
          (_) async =>
              Pension(pensionId: 1, name: name, maturityDate: maturityDate));

      await tester.pumpWidget(createEditScreen(null, databaseService, true));

      // Enter name into the TextFormField
      await tester.enterText(
          find.byKey(EditPensionScreen.pensionNameKey), name);
      await tester.pumpAndSettle();

      // Set the date of the date picker
      await tester.tap(find.byKey(EditPensionScreen.pensionMaturityDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(maturityDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      // should navigate to summary screen
      expect(find.byType(PensionOverviewScreen), findsOneWidget);
    });

    testWidgets(
        'saving existing pension record returns to pension summary screen',
        (tester) async {
      int id = 3;
      String originalName = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();
      String newName = "New Pension";

      final databaseService = createMockDatabaseService();
      when(databaseService.doesPensionNameExist(id, newName))
          .thenAnswer((_) async => false);
      when(databaseService.updatePension(id, newName, maturityDate, null))
          .thenAnswer((_) async => true);

      await tester.pumpWidget(createEditScreen(
          Pension(
              pensionId: id, name: originalName, maturityDate: maturityDate),
          databaseService, true));

      // Enter name into the TextFormField
      await tester.enterText(
          find.byKey(EditPensionScreen.pensionNameKey), newName);

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      // should navigate to summary screen
      expect(find.byType(PensionOverviewScreen), findsOneWidget);
    });
  });

  group('Test validation of add/edit pension screen', () {
    testWidgets('validation should prevent empty date', (tester) async {
      String name = "Test Pension";
      final databaseService = createMockDatabaseService();
      when(databaseService.doesPensionNameExist(null, name))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createEditScreen(null, databaseService));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(EditPensionScreen.pensionNameKey), name);
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      expect(find.text("Please select a date"), findsOneWidget);
    });

    testWidgets('validation should prevent empty name', (tester) async {
      DateTime maturityDate = DateHelper.getToday();

      final databaseService = createMockDatabaseService();

      await tester.pumpWidget(createEditScreen(null, databaseService));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(EditPensionScreen.pensionMaturityDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(maturityDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      expect(find.text("Please enter some text"), findsOneWidget);
    });

    testWidgets('validation should warn of duplicate pension name',
        (tester) async {
      String name = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();

      final databaseService = createMockDatabaseService();
      when(databaseService.doesPensionNameExist(null, name))
          .thenAnswer((_) async => true);

      await tester.pumpWidget(createEditScreen(null, databaseService));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(EditPensionScreen.pensionNameKey), name);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(EditPensionScreen.pensionMaturityDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(maturityDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      expect(find.text("This name is already in use"), findsOneWidget);
    });

    testWidgets('validation should clear after duplicate pension name',
        (tester) async {
      String name = "Test Pension";
      String newName = "Different Pension";
      DateTime maturityDate = DateHelper.getToday();

      final databaseService = createMockDatabaseService();
      when(databaseService.doesPensionNameExist(null, name))
          .thenAnswer((_) async => true);
      when(databaseService.doesPensionNameExist(null, newName))
          .thenAnswer((_) async => false);
      when(databaseService.createPension(newName, maturityDate, null)).thenAnswer(
          (_) async =>
              Pension(pensionId: 1, name: newName, maturityDate: maturityDate));

      await tester.pumpWidget(createEditScreen(null, databaseService, true));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(EditPensionScreen.pensionNameKey), name);
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(EditPensionScreen.pensionMaturityDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(maturityDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      expect(find.text("This name is already in use"), findsOneWidget);

      await tester.enterText(
          find.byKey(EditPensionScreen.pensionNameKey), newName);
      await tester.pumpAndSettle();

      // Tap the save button again
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      expect(find.text("This name is already in use"), findsNothing);
      verify(databaseService.createPension(newName, maturityDate, null)).called(1);
    });
  });

  group('Test delete button on add/edit pension screen', () {
    testWidgets('delete button not visible for add new record', (tester) async {
      final databaseService = createMockDatabaseService();

      await tester.pumpWidget(createEditScreen(null, databaseService));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextButton, "Delete"), findsNothing);
    });

    testWidgets('delete button is visible for edit record', (tester) async {
      final databaseService = createMockDatabaseService();
      final pension = Pension(
          pensionId: 1, name: 'originalName', maturityDate: DateTime.now());

      await tester.pumpWidget(createEditScreen(pension, databaseService));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextButton, "Delete"), findsOneWidget);
    });

    testWidgets('tapping the delete button displays warning prompt',
        (tester) async {
      final pension = Pension(
          pensionId: 1, name: 'originalName', maturityDate: DateTime.now());

      await tester
          .pumpWidget(createEditScreen(pension, createMockDatabaseService()));
      await tester.pumpAndSettle();

      // check the elements are not yet visible
      expect(find.text("Delete This Pension?"), findsNothing);
      expect(
          find.text(
              "Are you sure you want to delete this pension and any statements assigned to it?"),
          findsNothing);

      // Tap the delete button
      await tester.tap(find.widgetWithText(TextButton, "Delete"));
      await tester.pumpAndSettle();

      expect(find.text("Delete This Pension?"), findsOneWidget);
      expect(
          find.text(
              "Are you sure you want to delete this pension and any statements assigned to it?"),
          findsOneWidget);
    });

    testWidgets('tapping no dismissess the warning prompt', (tester) async {
      int pensionId = 1;
      final pension = Pension(
          pensionId: pensionId,
          name: 'originalName',
          maturityDate: DateTime.now());
      final databaseService = createMockDatabaseService();
      when(databaseService.deletePension(pensionId))
          .thenAnswer((_) async => pensionId);

      await tester.pumpWidget(createEditScreen(pension, databaseService));
      await tester.pumpAndSettle();

      // Tap the delete button
      await tester.tap(find.widgetWithText(TextButton, "Delete"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, "No"));
      await tester.pumpAndSettle();

      expect(find.text("Delete This Pension?"), findsNothing);
      expect(
          find.text(
              "Are you sure you want to delete this pension and any statements assigned to it?"),
          findsNothing);

      verifyNever(databaseService.deletePension(pensionId));
    });

    testWidgets(
        'tapping yes deletes the pension and dismissess the warning prompt',
        (tester) async {
      int pensionId = 1;
      final pension = Pension(
          pensionId: pensionId,
          name: 'originalName',
          maturityDate: DateTime.now());
      final databaseService = createMockDatabaseService();
      when(databaseService.deletePension(pensionId))
          .thenAnswer((_) async => pensionId);

      await tester.pumpWidget(createEditScreen(pension, databaseService, true));
      await tester.pumpAndSettle();

      // Tap the delete button
      await tester.tap(find.widgetWithText(TextButton, "Delete"));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, "Yes"));
      await tester.pumpAndSettle();

      expect(find.text("Delete This Pension?"), findsNothing);
      expect(
          find.text(
              "Are you sure you want to delete this pension and any statements assigned to it?"),
          findsNothing);
      expect(find.widgetWithText(SnackBar, "Pension removed successfully!"),
          findsOneWidget); //look for snackbar notification

      // should navigate back to home screen
      expect(find.byType(HomeScreen), findsOneWidget);

      verify(databaseService.deletePension(pensionId)).called(1);
    });

    // test cancel
  });
}
