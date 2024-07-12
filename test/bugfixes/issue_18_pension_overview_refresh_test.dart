import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:pension_compare/app/pension/views/edit_pension_screen.dart';
import 'package:pension_compare/app/pension/views/pension_overview_screen.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/constants/pension_status.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/route_config.dart';
import 'package:pension_compare/service_locator.dart';

import 'issue_18_pension_overview_refresh_test.mocks.dart';

// Tests to resolve issue #18 - Editing Pension record does not update the
// Pension Overview Screen
// https://github.com/zjcz/pension_compare/issues/18
@GenerateMocks([DatabaseService, SettingsService])
void main() {
    setUp(() async {
    // reset before each test to prevent errors with duplicate DatabaseService
    await getIt.reset();
  });
  
  group('Test to recreate issue 18', () {
    testWidgets(
        'pension overview screen shows changes after editing the pension',
        (tester) async {
      // arrange
      int id = 3;
      String name = "Test Pension";
      DateTime maturityDate = DateTime(2024, 1, 1);
      String newName = "Record after changes";
      Pension pensionRecord =
          Pension(pensionId: id, name: name, maturityDate: maturityDate,
            status: PensionStatus.active.dataValue,
            statusDate: DateTime.now());

      final databaseService = createMockDatabaseService();
      when(databaseService.watchPension(id))
          .thenAnswer((_) => Stream.value(pensionRecord));
      when(databaseService.watchPension(id)).thenAnswer(
          (_) => Stream.value(pensionRecord.copyWith(name: newName)));
      when(databaseService.doesPensionNameExist(id, newName))
          .thenAnswer((_) async => false);
      when(databaseService.updatePension(id, newName, maturityDate, null))
          .thenAnswer((_) async => 1);
      when(databaseService.getAllStatementsForPension(id))
          .thenAnswer((_) => Stream.value([]));

      // act
      await tester.pumpWidget(createScreen(pensionRecord, databaseService));
      await tester.pumpAndSettle();
      await tester.tap(find.byIcon(Icons.more_vert));
      await tester.pumpAndSettle();
      await tester.tap(find.text("Edit Pension"));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.byKey(EditPensionScreen.pensionNameKey), newName);
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, "Save"));
      await tester.pumpAndSettle();

      // assert
      verify(databaseService.updatePension(id, newName, maturityDate, null))
          .called(1);
      expect(find.byType(PensionOverviewScreen), findsOneWidget);
      expect(find.text(newName), findsOneWidget);
    });
  });
}

Widget createScreen(Pension pensionRecord, DatabaseService db) {
  final settingsService = MockSettingsService();
  when(settingsService.getAllSettings()).thenAnswer((_) async => const Settings(
      acceptTermsAndConditions: null,
      acceptFinancialAdviceWarning: null,
      welcomeScreenDismissed: null,
      optIntoAnalyticsWarning: false));
  getIt.registerSingleton<SettingsService>(settingsService);
  return ProviderScope(
      overrides: [
        DatabaseService.provider.overrideWithValue(db),
      ],
      child: MaterialApp.router(
        routerConfig: setupRouter(
          initialLocation:
              "${RouteDefs.pensionOverview}/${pensionRecord.pensionId}",
        ),
      ));
}

DatabaseService createMockDatabaseService() {
  DatabaseService ds = MockDatabaseService();
  // setup any mocks required by all tests
  return ds;
}
