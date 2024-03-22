import 'package:flutter/material.dart';
import 'package:mockito/annotations.dart';
import 'package:pension_compare/database/tables/pensions_with_latest_statement.dart';
import 'package:pension_compare/screens/home_screen.dart';
import 'package:pension_compare/database/database_service.dart';
import 'package:pension_compare/helpers/date_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:matcher/matcher.dart' as match;
import 'package:mockito/mockito.dart';

import 'home_screen_test.mocks.dart';

Widget createHomeScreen(DatabaseService db) {
  HomeScreen homeScreen = HomeScreen(databaseService: db);

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return MaterialApp(home: homeScreen);
  });
}

@GenerateMocks([DatabaseService])
void main() {
  group('Test displaying the home screen', () {
    testWidgets('show the home screen with no pension records', (tester) async {
      final databaseService = MockDatabaseService();
      when(databaseService.getAllPensionsWithLatestStatement())
          .thenAnswer((_) async => []);
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
          .thenAnswer((_) async => [
                PensionWithLatestStatement(
                    Pension(
                        pensionId: pensionId,
                        name: pensionName,
                        maturityDate: DateTime.now()),
                    null)
              ]);
      await tester.pumpWidget(createHomeScreen(databaseService));
      await tester.pumpAndSettle();

      expect(find.text("Overview"), findsOneWidget);

      expect(find.text(pensionName), findsOneWidget);
    });
  });
}
