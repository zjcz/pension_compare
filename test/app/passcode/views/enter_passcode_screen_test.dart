import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/app/home/views/home_screen.dart';
import 'package:pension_compare/app/passcode/controller/passcode_service.dart';
import 'package:pension_compare/route_config.dart';
import 'package:pension_compare/service_locator.dart';

import 'enter_passcode_screen_test.mocks.dart';

Widget createEnterPasscodeScreen(PasscodeService mockPasscodeService) {
  getIt.registerSingleton<PasscodeService>(mockPasscodeService);

  return StatefulBuilder(builder: (BuildContext context, StateSetter setState) {
    return ProviderScope(
        child: MaterialApp.router(
            routerConfig: setupRouter(
      initialLocation: RouteDefs.passcodeEnter,
    )));
  });
}

@GenerateMocks([PasscodeService])
void main() {
  late MockPasscodeService mockPasscodeService;

  setUp(() async {
    mockPasscodeService = MockPasscodeService();

    // reset before each test to prevent errors with duplicate MockPasscodeService
    await getIt.reset();
  });

  group('Enter Passcode Screen', () {
    testWidgets('given new screen when loading screen then expect widgets',
        (WidgetTester tester) async {
      // Build the EnterPasscode widget
      await tester.pumpWidget(createEnterPasscodeScreen(mockPasscodeService));

      // Verify that the EnterPasscode widget renders correctly
      expect(find.text('Enter Passcode'), findsOneWidget);
      expect(find.text('Enter your 6-digit passcode:'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);
      expect(find.widgetWithText(TextButton, "Submit"), findsOneWidget);
    });

    testWidgets(
        'given passcode screen when entering valid passcode then load home screen',
        (WidgetTester tester) async {
      String validPasscode = '1234';
      when(mockPasscodeService.validatePasscode(validPasscode))
          .thenAnswer((_) async => true);
      when(mockPasscodeService.setPasscode(validPasscode)).thenAnswer((_) => true);

      // Build the EnterPasscode widget
      await tester.pumpWidget(createEnterPasscodeScreen(mockPasscodeService));
      await tester.pumpAndSettle();

      // Enter a passcode
      await tester.enterText(find.byType(TextField), validPasscode);

      // Tap the submit button
      await tester.tap(find.widgetWithText(TextButton, "Submit"));
      await tester.pumpAndSettle();

      // Verify that the passcode is set correctly
      verify(mockPasscodeService.setPasscode(validPasscode)).called(1);
      verify(mockPasscodeService.validatePasscode(validPasscode)).called(1);
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets(
        'given passcode screen when entering invalid passcode then show warning',
        (WidgetTester tester) async {
      String invalidPasscode = '1234';
      when(mockPasscodeService.validatePasscode(invalidPasscode))
          .thenAnswer((_) async => false);
      when(mockPasscodeService.setPasscode(invalidPasscode)).thenAnswer((_) => true);

      // Build the EnterPasscode widget
      await tester.pumpWidget(createEnterPasscodeScreen(mockPasscodeService));
      await tester.pumpAndSettle();

      // Enter a passcode
      await tester.enterText(find.byType(TextField), invalidPasscode);

      // Tap the submit button
      await tester.tap(find.widgetWithText(TextButton, "Submit"));
      await tester.pumpAndSettle();

      // Verify that the passcode is set correctly
      verifyNever(mockPasscodeService.setPasscode(invalidPasscode));
      verify(mockPasscodeService.validatePasscode(invalidPasscode)).called(1);
      expect(find.byType(HomeScreen), findsNothing);
      expect(find.text('Passcode incorrect. Please try again.'), findsOneWidget);
    });
  });
}
