import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/app/statement/models/statement_model.dart';
import 'package:pension_compare/app/statement/views/edit_statement_screen.dart';
import 'package:pension_compare/constants/pension_status.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/data/mapper/statement_mapper.dart';
import 'package:pension_compare/helpers/date_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/app/pension/views/pension_overview_screen.dart';
import 'package:pension_compare/route_config.dart';
import 'package:pension_compare/service_locator.dart';

import 'edit_statement_screen_test.mocks.dart';

late MockSettingsService mockSettingsService;

Widget createEditScreen(Statement? statementRecord, DatabaseService db,
    [bool withRouting = false]) {
  if (withRouting) {
    getIt.registerSingleton<SettingsService>(mockSettingsService);

    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return ProviderScope(
          overrides: [
            DatabaseService.provider.overrideWithValue(db),
          ],
          child: MaterialApp.router(
            routerConfig: setupRouter(
                initialLocation: RouteDefs.editStatement,
                initialExtra: statementRecord == null
                    ? null
                    : StatementMapper.mapToModel(statementRecord)),
          ));
    });
  } else {
    StatementModel? statementModel = statementRecord == null
        ? null
        : StatementMapper.mapToModel(statementRecord);

    return ProviderScope(
        overrides: [
          DatabaseService.provider.overrideWithValue(db),
        ],
        child: MaterialApp(
          home: EditStatementScreen(statement: statementModel),
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

  group('Test adding / editing of statement record', () {
    testWidgets('show the add screen with no statement record', (tester) async {
      final databaseService = createMockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) => Stream.value([
            Pension(
                pensionId: 1,
                name: "new pension",
                maturityDate: DateTime.now(),
                status: PensionStatus.active.dataValue,
                statusDate: DateTime.now())
          ]));
      await tester.pumpWidget(createEditScreen(null, databaseService));
      await tester.pumpAndSettle();

      expect(find.text("Add Statement"), findsOneWidget);

      //expect(find.bySemanticsLabel('Pension'), findsOneWidget);
      expect(find.bySemanticsLabel('Statement Date'), findsOneWidget);
      expect(find.bySemanticsLabel('Plan Value'), findsOneWidget);
      expect(find.bySemanticsLabel('Projected Yearly Amount'), findsOneWidget);
      expect(find.bySemanticsLabel('Yearly Charges'), findsOneWidget);
      expect(find.bySemanticsLabel('Transfer Value'), findsOneWidget);
      expect(find.bySemanticsLabel('Amount Paid In'), findsOneWidget);

      expect(
          find.text(
              "Enter the following values found on your annual statement:"),
          findsOneWidget);

      expect(find.byType(DropdownButtonFormField<int>), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(6));
      expect(find.byKey(EditStatementScreen.pensionKey), findsOneWidget);
      expect(find.byKey(EditStatementScreen.statementDateKey), findsOneWidget);
      expect(find.byKey(EditStatementScreen.planValueKey), findsOneWidget);
      expect(find.byKey(EditStatementScreen.projectedAnnualAmountKey),
          findsOneWidget);
      expect(find.byKey(EditStatementScreen.yearlyChargesKey), findsOneWidget);
      expect(find.byKey(EditStatementScreen.transferValueKey), findsOneWidget);
      expect(find.byKey(EditStatementScreen.paidInValueKey), findsOneWidget);

      expect(find.byType(TextButton), findsOneWidget);
    });

    // testWidgets('show the edit screen with a pension record', (tester) async {
    //   Pension p =
    //       Pension(id: 1, name: "Test Pension", maturityDate: DateTime.now());
    //   await tester.pumpWidget(createEditScreen(p, null));

    //   expect(find.text("Edit Statement"), findsOneWidget);
    //   expect(find.text(p.name), findsOneWidget);
    //   expect(find.text(DateHelper.formatDate(p.maturityDate)), findsOneWidget);
    // });

    testWidgets('Set date of date picker', (WidgetTester tester) async {
      final databaseService = createMockDatabaseService();
      when(databaseService.getAllPensions())
          .thenAnswer((_) => Stream.value([]));

      // Build your app and trigger a frame
      await tester.pumpWidget(createEditScreen(null, databaseService));

      // Find the TextFormField by key
      final fieldFinder = find.byKey(EditStatementScreen.statementDateKey);

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

  group('Test database interaction of add/edit statement screen', () {
    testWidgets('save add new statement record', (tester) async {
      String name = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();
      int pensionId = 1;
      DateTime statementDate = DateHelper.getToday();
      double planValue = 12345.0;
      double projectedAnnualAmount = 1234;
      double yearlyCharges = 100;
      double transferValue = 12345;
      double paidInValue = 123456;

      final databaseService = createMockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) => Stream.value([
            Pension(
                pensionId: pensionId,
                name: name,
                maturityDate: maturityDate,
                status: PensionStatus.active.dataValue,
                statusDate: DateTime.now())
          ]));
      when(databaseService.createStatement(
              pensionId,
              statementDate,
              planValue,
              projectedAnnualAmount,
              yearlyCharges,
              transferValue,
              paidInValue,
              null))
          .thenAnswer((_) async => Statement(
              statementId: 1,
              pension: pensionId,
              statementDate: statementDate,
              planValue: planValue,
              projectedAnnualAmount: projectedAnnualAmount,
              yearlyCharges: yearlyCharges,
              transferValue: transferValue,
              amountPaidIn: paidInValue));
      when(databaseService.doesStatementDateExist(
              null, pensionId, statementDate))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createEditScreen(null, databaseService, true));
      await tester.pumpAndSettle();

      // select the pension from the DropDownButtonFormField
      await tester.tap(find.byKey(EditStatementScreen.pensionKey));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DropdownMenuItem<int>, name).last);
      await tester.pumpAndSettle();

      // Set the date of the date picker
      await tester.tap(find.byKey(EditStatementScreen.statementDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(statementDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(EditStatementScreen.planValueKey), planValue.toString());
      await tester.enterText(
          find.byKey(EditStatementScreen.projectedAnnualAmountKey),
          projectedAnnualAmount.toString());
      await tester.enterText(find.byKey(EditStatementScreen.yearlyChargesKey),
          yearlyCharges.toString());
      await tester.enterText(find.byKey(EditStatementScreen.transferValueKey),
          transferValue.toString());
      await tester.enterText(find.byKey(EditStatementScreen.paidInValueKey),
          paidInValue.toString());
      // Tap the save button
      await tester.tap(find.byType(TextButton));

      verify(databaseService.getAllPensions()).called(1);
      verify(databaseService.createStatement(
              pensionId,
              statementDate,
              planValue,
              projectedAnnualAmount,
              yearlyCharges,
              transferValue,
              paidInValue,
              null))
          .called(1);
    });

    testWidgets('update existing pension record', (tester) async {
      int pensionId = 1;
      String name = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();
      int statementId = 3;
      DateTime originalStatementDate = DateTime(2024, 1, 1);
      double originalPlanValue = 12345.0;
      double originalProjectedAnnualAmount = 1234;
      double originalYearlyCharges = 100;
      double originalTransferValue = 12345;
      double originalPaidInValue = 123456;
      DateTime newStatementDate = DateTime(2024, 1, 20);
      double newPlanValue = 54321.0;
      double newProjectedAnnualAmount = 9876;
      double newYearlyCharges = 500;
      double newTransferValue = 98765;
      double newPaidInValue = 987654;

      final databaseService = createMockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) => Stream.value([
            Pension(
                pensionId: pensionId,
                name: name,
                maturityDate: maturityDate,
                status: PensionStatus.active.dataValue,
                statusDate: DateTime.now())
          ]));
      when(databaseService.updateStatement(
              statementId,
              pensionId,
              newStatementDate,
              newPlanValue,
              newProjectedAnnualAmount,
              newYearlyCharges,
              newTransferValue,
              newPaidInValue,
              null))
          .thenAnswer((_) async => true);
      when(databaseService.doesStatementDateExist(
              statementId, pensionId, newStatementDate))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createEditScreen(
          Statement(
              statementId: statementId,
              pension: pensionId,
              statementDate: originalStatementDate,
              planValue: originalPlanValue,
              projectedAnnualAmount: originalProjectedAnnualAmount,
              yearlyCharges: originalYearlyCharges,
              transferValue: originalTransferValue,
              amountPaidIn: originalPaidInValue),
          databaseService,
          true));

      // Set the date of the date picker
      await tester.tap(find.byKey(EditStatementScreen.statementDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(newStatementDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Enter values into the TextFormFields
      await tester.enterText(find.byKey(EditStatementScreen.planValueKey),
          newPlanValue.toString());
      await tester.enterText(
          find.byKey(EditStatementScreen.projectedAnnualAmountKey),
          newProjectedAnnualAmount.toString());
      await tester.enterText(find.byKey(EditStatementScreen.yearlyChargesKey),
          newYearlyCharges.toString());
      await tester.enterText(find.byKey(EditStatementScreen.transferValueKey),
          newTransferValue.toString());
      await tester.enterText(find.byKey(EditStatementScreen.paidInValueKey),
          newPaidInValue.toString());

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, 'Save'));

      verify(databaseService.getAllPensions()).called(1);
      verifyNever(databaseService.createStatement(
          pensionId,
          newStatementDate,
          newPlanValue,
          newProjectedAnnualAmount,
          newYearlyCharges,
          newTransferValue,
          newPaidInValue,
          null));
      verify(databaseService.updateStatement(
              statementId,
              pensionId,
              newStatementDate,
              newPlanValue,
              newProjectedAnnualAmount,
              newYearlyCharges,
              newTransferValue,
              newPaidInValue,
              null))
          .called(1);
    });
  });

  group('Test navigation after save statement record', () {
    testWidgets(
        'save add new statement record returns to pension summary screen',
        (tester) async {
      String name = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();
      int pensionId = 1;
      DateTime statementDate = DateHelper.getToday();
      double planValue = 12345.0;
      double projectedAnnualAmount = 1234;
      double yearlyCharges = 100;
      double transferValue = 12345;
      double paidInValue = 12345.0;

      final databaseService = createMockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) => Stream.value([
            Pension(
                pensionId: pensionId,
                name: name,
                maturityDate: maturityDate,
                status: PensionStatus.active.dataValue,
                statusDate: DateTime.now())
          ]));
      when(databaseService.createStatement(
              pensionId,
              statementDate,
              planValue,
              projectedAnnualAmount,
              yearlyCharges,
              transferValue,
              paidInValue,
              null))
          .thenAnswer((_) async => Statement(
              statementId: 1,
              pension: pensionId,
              statementDate: statementDate,
              planValue: planValue,
              projectedAnnualAmount: projectedAnnualAmount,
              yearlyCharges: yearlyCharges,
              transferValue: transferValue,
              amountPaidIn: paidInValue));
      when(databaseService.doesStatementDateExist(
              null, pensionId, statementDate))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createEditScreen(null, databaseService, true));
      await tester.pumpAndSettle();

      // select the pension from the DropDownButtonFormField
      await tester.tap(find.byKey(EditStatementScreen.pensionKey));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DropdownMenuItem<int>, name).last);
      await tester.pumpAndSettle();

      // Set the date of the date picker
      await tester.tap(find.byKey(EditStatementScreen.statementDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(statementDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(EditStatementScreen.planValueKey), planValue.toString());
      await tester.enterText(
          find.byKey(EditStatementScreen.projectedAnnualAmountKey),
          projectedAnnualAmount.toString());
      await tester.enterText(find.byKey(EditStatementScreen.yearlyChargesKey),
          yearlyCharges.toString());
      await tester.enterText(find.byKey(EditStatementScreen.transferValueKey),
          transferValue.toString());
      await tester.enterText(find.byKey(EditStatementScreen.paidInValueKey),
          paidInValue.toString());

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      // should navigate to summary screen
      expect(find.byType(PensionOverviewScreen), findsOneWidget);
    });

    testWidgets(
        'update existing statement record returns to pension summary screen',
        (tester) async {
      int pensionId = 1;
      String name = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();
      int statementId = 3;
      DateTime originalStatementDate = DateTime(2024, 1, 1);
      double originalPlanValue = 12345.0;
      double originalProjectedAnnualAmount = 1234;
      double originalYearlyCharges = 100;
      double originalTransferValue = 12345;
      double originalPaidInValue = 123456;
      DateTime newStatementDate = DateTime(2024, 1, 20);
      double newPlanValue = 54321.0;
      double newProjectedAnnualAmount = 9876;
      double newYearlyCharges = 500;
      double newTransferValue = 98765;
      double newPaidInValue = 987654;

      final databaseService = createMockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) => Stream.value([
            Pension(
                pensionId: pensionId,
                name: name,
                maturityDate: maturityDate,
                status: PensionStatus.active.dataValue,
                statusDate: DateTime.now())
          ]));
      when(databaseService.updateStatement(
              statementId,
              pensionId,
              newStatementDate,
              newPlanValue,
              newProjectedAnnualAmount,
              newYearlyCharges,
              newTransferValue,
              newPaidInValue,
              null))
          .thenAnswer((_) async => true);
      when(databaseService.doesStatementDateExist(
              statementId, pensionId, newStatementDate))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createEditScreen(
          Statement(
              statementId: statementId,
              pension: pensionId,
              statementDate: originalStatementDate,
              planValue: originalPlanValue,
              projectedAnnualAmount: originalProjectedAnnualAmount,
              yearlyCharges: originalYearlyCharges,
              transferValue: originalTransferValue,
              amountPaidIn: originalPaidInValue),
          databaseService,
          true));

      // Set the date of the date picker
      await tester.tap(find.byKey(EditStatementScreen.statementDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(newStatementDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Enter values into the TextFormFields
      await tester.enterText(find.byKey(EditStatementScreen.planValueKey),
          newPlanValue.toString());
      await tester.enterText(
          find.byKey(EditStatementScreen.projectedAnnualAmountKey),
          newProjectedAnnualAmount.toString());
      await tester.enterText(find.byKey(EditStatementScreen.yearlyChargesKey),
          newYearlyCharges.toString());
      await tester.enterText(find.byKey(EditStatementScreen.transferValueKey),
          newTransferValue.toString());
      await tester.enterText(find.byKey(EditStatementScreen.paidInValueKey),
          newPaidInValue.toString());

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      // should navigate to summary screen
      expect(find.byType(PensionOverviewScreen), findsOneWidget);
    });
  });

  group('Test validation of add/edit statement screen', () {
    testWidgets('validation should prevent invalid plan value', (tester) async {
      String name = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();
      int pensionId = 1;
      DateTime statementDate = DateHelper.getToday();
      double planValue = 12345.0;
      double projectedAnnualAmount = 1234;
      double yearlyCharges = 100;
      double transferValue = 12345;
      double paidInValue = 123456;

      final databaseService = createMockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) => Stream.value([
            Pension(
                pensionId: pensionId,
                name: name,
                maturityDate: maturityDate,
                status: PensionStatus.active.dataValue,
                statusDate: DateTime.now())
          ]));
      when(databaseService.createStatement(
              pensionId,
              statementDate,
              planValue,
              projectedAnnualAmount,
              yearlyCharges,
              transferValue,
              paidInValue,
              null))
          .thenAnswer((_) async => Statement(
              statementId: 1,
              pension: pensionId,
              statementDate: statementDate,
              planValue: planValue,
              projectedAnnualAmount: projectedAnnualAmount,
              yearlyCharges: yearlyCharges,
              transferValue: transferValue,
              amountPaidIn: paidInValue));
      when(databaseService.doesStatementDateExist(
              null, pensionId, statementDate))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createEditScreen(null, databaseService));
      await tester.pumpAndSettle();

      // select the pension from the DropDownButtonFormField
      await tester.tap(find.byKey(EditStatementScreen.pensionKey));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DropdownMenuItem<int>, name).last);
      await tester.pumpAndSettle();

      // Set the date of the date picker
      await tester.tap(find.byKey(EditStatementScreen.statementDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(statementDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(EditStatementScreen.planValueKey), "invalid number");
      await tester.enterText(
          find.byKey(EditStatementScreen.projectedAnnualAmountKey),
          "invalid number");
      await tester.enterText(
          find.byKey(EditStatementScreen.yearlyChargesKey), "invalid number");
      await tester.enterText(
          find.byKey(EditStatementScreen.transferValueKey), "invalid number");
      await tester.enterText(
          find.byKey(EditStatementScreen.paidInValueKey), "invalid number");
      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, 'Save'));

      expect(
          find.text("Please enter a value, or 0 if unknown"), findsNWidgets(2));

      verify(databaseService.getAllPensions()).called(1);
      verifyNever(databaseService.createStatement(
          pensionId,
          statementDate,
          planValue,
          projectedAnnualAmount,
          yearlyCharges,
          transferValue,
          paidInValue,
          null));
    });

    testWidgets('validation should prevent negative values', (tester) async {
      String name = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();
      int pensionId = 1;
      DateTime statementDate = DateHelper.getToday();
      double planValue = 12345.0;
      double projectedAnnualAmount = 1234;
      double yearlyCharges = 100;
      double transferValue = 12345;
      double paidInValue = 123456;
      double negNumber = -42;

      final databaseService = createMockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) => Stream.value([
            Pension(
                pensionId: pensionId,
                name: name,
                maturityDate: maturityDate,
                status: PensionStatus.active.dataValue,
                statusDate: DateTime.now())
          ]));
      when(databaseService.createStatement(
              pensionId,
              statementDate,
              planValue,
              projectedAnnualAmount,
              yearlyCharges,
              transferValue,
              paidInValue,
              null))
          .thenAnswer((_) async => Statement(
              statementId: 1,
              pension: pensionId,
              statementDate: statementDate,
              planValue: planValue,
              projectedAnnualAmount: projectedAnnualAmount,
              yearlyCharges: yearlyCharges,
              transferValue: transferValue,
              amountPaidIn: paidInValue));
      when(databaseService.doesStatementDateExist(
              null, pensionId, statementDate))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createEditScreen(null, databaseService));
      await tester.pumpAndSettle();

      // select the pension from the DropDownButtonFormField
      await tester.tap(find.byKey(EditStatementScreen.pensionKey));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DropdownMenuItem<int>, name).last);
      await tester.pumpAndSettle();

      // Set the date of the date picker
      await tester.tap(find.byKey(EditStatementScreen.statementDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(statementDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(EditStatementScreen.planValueKey), negNumber.toString());
      await tester.enterText(
          find.byKey(EditStatementScreen.projectedAnnualAmountKey),
          negNumber.toString());
      await tester.enterText(find.byKey(EditStatementScreen.yearlyChargesKey),
          negNumber.toString());
      await tester.enterText(find.byKey(EditStatementScreen.transferValueKey),
          negNumber.toString());
      await tester.enterText(
          find.byKey(EditStatementScreen.paidInValueKey), negNumber.toString());
      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, 'Save'));

      expect(
          find.text("Please enter a value, or 0 if unknown"), findsNWidgets(2));

      verify(databaseService.getAllPensions()).called(1);
      verifyNever(databaseService.createStatement(
          pensionId,
          statementDate,
          planValue,
          projectedAnnualAmount,
          yearlyCharges,
          transferValue,
          paidInValue,
          null));
    });

    testWidgets('validation should warn of duplicate statement date',
        (tester) async {
      String name = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();
      int pensionId = 1;
      DateTime statementDate = DateHelper.getToday();
      double planValue = 12345.0;
      double projectedAnnualAmount = 1234;
      double yearlyCharges = 100;
      double transferValue = 12345;
      double paidInValue = 123456;

      final databaseService = createMockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) => Stream.value([
            Pension(
                pensionId: pensionId,
                name: name,
                maturityDate: maturityDate,
                status: PensionStatus.active.dataValue,
                statusDate: DateTime.now())
          ]));
      when(databaseService.createStatement(
              pensionId,
              statementDate,
              planValue,
              projectedAnnualAmount,
              yearlyCharges,
              transferValue,
              paidInValue,
              null))
          .thenAnswer((_) async => Statement(
              statementId: 1,
              pension: pensionId,
              statementDate: statementDate,
              planValue: planValue,
              projectedAnnualAmount: projectedAnnualAmount,
              yearlyCharges: yearlyCharges,
              transferValue: transferValue,
              amountPaidIn: paidInValue));
      when(databaseService.doesStatementDateExist(
              null, pensionId, statementDate))
          .thenAnswer((_) async => true);

      await tester.pumpWidget(createEditScreen(null, databaseService));
      await tester.pumpAndSettle();

      // select the pension from the DropDownButtonFormField
      await tester.tap(find.byKey(EditStatementScreen.pensionKey));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DropdownMenuItem<int>, name).last);
      await tester.pumpAndSettle();

      // Set the date of the date picker
      await tester.tap(find.byKey(EditStatementScreen.statementDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(statementDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(EditStatementScreen.planValueKey), planValue.toString());
      await tester.enterText(
          find.byKey(EditStatementScreen.projectedAnnualAmountKey),
          projectedAnnualAmount.toString());
      await tester.enterText(find.byKey(EditStatementScreen.yearlyChargesKey),
          yearlyCharges.toString());
      await tester.enterText(find.byKey(EditStatementScreen.transferValueKey),
          transferValue.toString());
      await tester.enterText(find.byKey(EditStatementScreen.paidInValueKey),
          paidInValue.toString());

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle();

      expect(find.text("A statement for this date already exists"),
          findsOneWidget);

      verify(databaseService.getAllPensions()).called(1);
      verify(databaseService.doesStatementDateExist(
              null, pensionId, statementDate))
          .called(1);
      verifyNever(databaseService.createStatement(
          pensionId,
          statementDate,
          planValue,
          projectedAnnualAmount,
          yearlyCharges,
          transferValue,
          paidInValue,
          null));
    });

    testWidgets('validation should clear after duplicate pension name',
        (tester) async {
      String name = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();
      int pensionId = 1;
      DateTime statementDate = DateHelper.getToday();
      DateTime newStatementDate = DateTime(
          statementDate.year,
          statementDate.month,
          (statementDate.day == 1 ? 2 : 1)); // different date
      double planValue = 12345.0;
      double projectedAnnualAmount = 1234;
      double yearlyCharges = 100;
      double transferValue = 12345;
      double paidInValue = 123456;

      final databaseService = createMockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) => Stream.value([
            Pension(
                pensionId: pensionId,
                name: name,
                maturityDate: maturityDate,
                status: PensionStatus.active.dataValue,
                statusDate: DateTime.now())
          ]));
      when(databaseService.createStatement(
              pensionId,
              newStatementDate,
              planValue,
              projectedAnnualAmount,
              yearlyCharges,
              transferValue,
              paidInValue,
              null))
          .thenAnswer((_) async => Statement(
              statementId: 1,
              pension: pensionId,
              statementDate: statementDate,
              planValue: planValue,
              projectedAnnualAmount: projectedAnnualAmount,
              yearlyCharges: yearlyCharges,
              transferValue: transferValue,
              amountPaidIn: paidInValue));
      when(databaseService.doesStatementDateExist(
              null, pensionId, statementDate))
          .thenAnswer((_) async => true);
      when(databaseService.doesStatementDateExist(
              null, pensionId, newStatementDate))
          .thenAnswer((_) async => false);

      await tester.pumpWidget(createEditScreen(null, databaseService, true));
      await tester.pumpAndSettle();

      // select the pension from the DropDownButtonFormField
      await tester.tap(find.byKey(EditStatementScreen.pensionKey));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(DropdownMenuItem<int>, name).last);
      await tester.pumpAndSettle();

      // Set the date of the date picker
      await tester.tap(find.byKey(EditStatementScreen.statementDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(statementDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(EditStatementScreen.planValueKey), planValue.toString());
      await tester.enterText(
          find.byKey(EditStatementScreen.projectedAnnualAmountKey),
          projectedAnnualAmount.toString());
      await tester.enterText(find.byKey(EditStatementScreen.yearlyChargesKey),
          yearlyCharges.toString());
      await tester.enterText(find.byKey(EditStatementScreen.transferValueKey),
          transferValue.toString());
      await tester.enterText(find.byKey(EditStatementScreen.paidInValueKey),
          paidInValue.toString());

      // Tap the save button
      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle();

      expect(find.text("A statement for this date already exists"),
          findsOneWidget);

      // change the date
      await tester.tap(find.byKey(EditStatementScreen.statementDateKey));
      await tester.pumpAndSettle();
      await tester.tap(find.text(newStatementDate.day.toString()));
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      await tester.pumpAndSettle();

      expect(
          find.text("A statement for this date already exists"), findsNothing);
    });
  });

  group('Test delete button on add/edit statement screen', () {
    testWidgets('delete button not visible for add new record', (tester) async {
      int pensionId = 1;
      String name = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();

      final databaseService = createMockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) => Stream.value([
            Pension(
                pensionId: pensionId,
                name: name,
                maturityDate: maturityDate,
                status: PensionStatus.active.dataValue,
                statusDate: DateTime.now())
          ]));

      await tester.pumpWidget(createEditScreen(null, databaseService));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextButton, "Delete"), findsNothing);
    });

    testWidgets('delete button is visible for edit record', (tester) async {
      int pensionId = 1;
      String name = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();
      int statementId = 1;
      DateTime statementDate = DateHelper.getToday();
      double planValue = 12345.0;
      double projectedAnnualAmount = 1234;
      double yearlyCharges = 100;
      double transferValue = 12345;
      double paidInValue = 123456;

      final databaseService = createMockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) => Stream.value([
            Pension(
                pensionId: pensionId,
                name: name,
                maturityDate: maturityDate,
                status: PensionStatus.active.dataValue,
                statusDate: DateTime.now())
          ]));
      final statement = Statement(
          statementId: statementId,
          pension: pensionId,
          statementDate: statementDate,
          planValue: planValue,
          projectedAnnualAmount: projectedAnnualAmount,
          yearlyCharges: yearlyCharges,
          transferValue: transferValue,
          amountPaidIn: paidInValue);

      await tester.pumpWidget(createEditScreen(statement, databaseService));
      await tester.pumpAndSettle();

      expect(find.widgetWithText(TextButton, "Delete"), findsOneWidget);
    });

    testWidgets('tapping the delete button displays warning prompt',
        (tester) async {
      int pensionId = 1;
      String name = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();
      int statementId = 1;
      DateTime statementDate = DateHelper.getToday();
      double planValue = 12345.0;
      double projectedAnnualAmount = 1234;
      double yearlyCharges = 100;
      double transferValue = 12345;
      double paidInValue = 123456;

      final databaseService = createMockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) => Stream.value([
            Pension(
                pensionId: pensionId,
                name: name,
                maturityDate: maturityDate,
                status: PensionStatus.active.dataValue,
                statusDate: DateTime.now())
          ]));
      final statement = Statement(
          statementId: statementId,
          pension: pensionId,
          statementDate: statementDate,
          planValue: planValue,
          projectedAnnualAmount: projectedAnnualAmount,
          yearlyCharges: yearlyCharges,
          transferValue: transferValue,
          amountPaidIn: paidInValue);
      await tester.pumpWidget(createEditScreen(statement, databaseService));
      await tester.pumpAndSettle();

      // check the elements are not yet visible
      expect(find.text("Delete This Statement?"), findsNothing);
      expect(find.text("Are you sure you want to delete this statement?"),
          findsNothing);

      // Tap the delete button (scroll to it first as it may be off screen)
      final buttonFinder = find.widgetWithText(TextButton, "Delete");
      final scrollableFinder = find.byType(Scrollable).last;
      await tester.scrollUntilVisible(buttonFinder, 10,
          scrollable: scrollableFinder);
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      expect(find.text("Delete This Statement?"), findsOneWidget);
      expect(find.text("Are you sure you want to delete this statement?"),
          findsOneWidget);
    });

    testWidgets('tapping no dismissess the warning prompt', (tester) async {
      int pensionId = 1;
      String name = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();
      int statementId = 1;
      DateTime statementDate = DateHelper.getToday();
      double planValue = 12345.0;
      double projectedAnnualAmount = 1234;
      double yearlyCharges = 100;
      double transferValue = 12345;
      double paidInValue = 123456;

      final databaseService = createMockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) => Stream.value([
            Pension(
                pensionId: pensionId,
                name: name,
                maturityDate: maturityDate,
                status: PensionStatus.active.dataValue,
                statusDate: DateTime.now())
          ]));
      when(databaseService.deleteStatement(statementId))
          .thenAnswer((_) async => statementId);

      final statement = Statement(
          statementId: statementId,
          pension: pensionId,
          statementDate: statementDate,
          planValue: planValue,
          projectedAnnualAmount: projectedAnnualAmount,
          yearlyCharges: yearlyCharges,
          transferValue: transferValue,
          amountPaidIn: paidInValue);
      await tester.pumpWidget(createEditScreen(statement, databaseService));
      await tester.pumpAndSettle();

      // Tap the delete button (scroll to it first as it may be off screen)
      final buttonFinder = find.widgetWithText(TextButton, "Delete");
      final scrollableFinder = find.byType(Scrollable).last;
      await tester.scrollUntilVisible(buttonFinder, 10,
          scrollable: scrollableFinder);
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, "No"));
      await tester.pumpAndSettle();

      expect(find.text("Delete This Statement?"), findsNothing);
      expect(find.text("Are you sure you want to delete this statement?"),
          findsNothing);

      verifyNever(databaseService.deleteStatement(statementId));
    });

    testWidgets(
        'tapping yes deletes the statement and dismissess the warning prompt',
        (tester) async {
      int pensionId = 1;
      String name = "Test Pension";
      DateTime maturityDate = DateHelper.getToday();
      int statementId = 5;
      DateTime statementDate = DateHelper.getToday();
      double planValue = 12345.0;
      double projectedAnnualAmount = 1234;
      double yearlyCharges = 100;
      double transferValue = 12345;
      double paidInValue = 123456;

      final databaseService = createMockDatabaseService();
      Pension p = Pension(
          pensionId: pensionId,
          name: name,
          maturityDate: maturityDate,
          status: PensionStatus.active.dataValue,
          statusDate: DateTime.now());
      when(databaseService.getAllPensions())
          .thenAnswer((_) => Stream.value([p]));
      when(databaseService.getPension(pensionId)).thenAnswer((_) async => p);
      when(databaseService.watchPension(pensionId))
          .thenAnswer((_) => Stream.value(p));
      when(databaseService.deleteStatement(statementId))
          .thenAnswer((_) async => statementId);
      when(databaseService.getAllStatementsForPension(pensionId))
          .thenAnswer((_) => Stream.value([]));

      final statement = Statement(
          statementId: statementId,
          pension: pensionId,
          statementDate: statementDate,
          planValue: planValue,
          projectedAnnualAmount: projectedAnnualAmount,
          yearlyCharges: yearlyCharges,
          transferValue: transferValue,
          amountPaidIn: paidInValue);
      await tester
          .pumpWidget(createEditScreen(statement, databaseService, true));
      await tester.pumpAndSettle();

      // Tap the delete button (scroll to it first as it may be off screen)
      final buttonFinder = find.widgetWithText(TextButton, "Delete");
      final scrollableFinder = find.byType(Scrollable).last;
      await tester.scrollUntilVisible(buttonFinder, 10,
          scrollable: scrollableFinder);
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, "Yes"));
      await tester.pumpAndSettle();

      expect(find.text("Delete This Statement?"), findsNothing);
      expect(find.text("Are you sure you want to delete this statement?"),
          findsNothing);
      expect(find.widgetWithText(SnackBar, "Statement removed successfully!"),
          findsOneWidget); //look for snackbar notification

      // should navigate back to pension overview
      expect(find.byType(PensionOverviewScreen), findsOneWidget);

      verify(databaseService.deleteStatement(statementId)).called(1);
    });
  });
}
