import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pension_compare/app/home/controllers/yearly_pension_statement_controller.dart';
import 'package:pension_compare/constants/pension_status.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/data/database/tables/pensions_with_statement.dart';
import 'package:pension_compare/data/database/tables/yearly_pension_statement.dart';

import 'yearly_pension_statement_controller_test.mocks.dart';

@GenerateMocks([DatabaseService])
void main() {
  group('Test yearly pension statement controller', () {
    testWidgets('get the records', (tester) async {
      int pensionId = 1;
      String pensionName = 'new pension';
      final databaseService = MockDatabaseService();
      when(databaseService.getYearlyPensionSummary())
          .thenAnswer((_) => Stream.value([
                YearlyPensionStatement(2021, [
                  PensionWithStatement(
                      Pension(
                          pensionId: pensionId,
                          name: pensionName,
                          maturityDate: DateTime.now(),
                          status: PensionStatus.active.dataValue,
                          statusDate: DateTime.now()),
                      null)
                ])
              ]));

      final container = createContainer(overrides: [
        DatabaseService.provider.overrideWithValue(databaseService)
      ]);

      final pensionList =
          await container.read(yearlyPensionStatementControllerProvider.future);

      expect(pensionList, isNotNull);
      expect(pensionList.length, 1);
      expect(pensionList[0].year, 2021);
      expect(pensionList[0].pensionWithStatement, isNotNull);
      expect(pensionList[0].pensionWithStatement.length, 1);
      expect(pensionList[0].pensionWithStatement[0].pension, isNotNull);
      expect(
          pensionList[0].pensionWithStatement[0].pension.pensionId, pensionId);
      expect(pensionList[0].pensionWithStatement[0].pension.name, pensionName);
      expect(pensionList[0].pensionWithStatement[0].statement, isNull);
      verify(databaseService.getYearlyPensionSummary()).called(1);

      // Workaround to avoid the FakeTimer error
      // https://github.com/rrousselGit/riverpod/issues/1941
      await tester.pumpWidget(Container());
      await tester.pumpAndSettle();
    });
  });
}

/// A testing utility which creates a [ProviderContainer] and automatically
/// disposes it at the end of the test.
/// Taken from https://riverpod.dev/docs/essentials/testing
ProviderContainer createContainer({
  ProviderContainer? parent,
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) {
  // Create a ProviderContainer, and optionally allow specifying parameters.
  final container = ProviderContainer(
    parent: parent,
    overrides: overrides,
    observers: observers,
  );

  // When the test ends, dispose the container.
  addTearDown(container.dispose);

  return container;
}
