import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:pension_compare/app/pension/views/edit_pension_screen.dart';
import 'package:pension_compare/data/database/tables/pensions_with_latest_statement.dart';
import 'package:pension_compare/app/home/views/home_screen.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/route_config.dart';

import 'home_screen_test.mocks.dart';

Widget createHomeScreen(DatabaseService db) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return ProviderScope(
        overrides: [
          DatabaseService.provider.overrideWithValue(db),
        ],
        child: MaterialApp.router(
            routerConfig: setupRouter(
          initialLocation: RouteDefs.home,
        )));
  });
}

@GenerateMocks([DatabaseService])
void main() {
  group('Test displaying the home screen', () {
    testWidgets('show the home screen with no pension records', (tester) async {
      final databaseService = MockDatabaseService();
      when(databaseService.getAllPensionsWithLatestStatement())
          .thenAnswer((_) => Stream.value([]));
      await tester.pumpWidget(createHomeScreen(databaseService));
      await tester.pumpAndSettle();

      expect(find.text("Overview"), findsOneWidget);

      expect(
          find.text("No pensions found.  Click + to add one"), findsOneWidget);
    });

    testWidgets('show the home screen with a single pension record',
        (tester) async {
      int pensionId = 1;
      String pensionName = 'new pension';
      final databaseService = MockDatabaseService();
      when(databaseService.getAllPensionsWithLatestStatement())
          .thenAnswer((_) => Stream.value([
                PensionWithLatestStatement(
                    Pension(
                        pensionId: pensionId,
                        name: pensionName,
                        maturityDate: DateTime.now()),
                    null)
              ]));
      await tester.pumpWidget(createHomeScreen(databaseService));
      await tester.pumpAndSettle();

      expect(find.text("Overview"), findsOneWidget);

      expect(find.widgetWithText(DataTable, pensionName), findsOneWidget);
    });

    testWidgets('tapping + button navigates to the edit pension screen',
        (tester) async {
      final databaseService = MockDatabaseService();
      when(databaseService.getAllPensionsWithLatestStatement())
          .thenAnswer((_) => Stream.value([]));
      await tester.pumpWidget(createHomeScreen(databaseService));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);

      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      expect(find.byType(EditPensionScreen), findsOneWidget);
    });
  });
}
