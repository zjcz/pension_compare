import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/app/passcode/controller/passcode_service.dart';
import 'package:pension_compare/app/passcode/views/widgets/passcode_field.dart';
import 'package:pension_compare/service_locator.dart';

import 'passcode_field_test.mocks.dart';

final _formKey = GlobalKey<FormState>();
const String key = 'passcode_field';

/// Create the widget for testing
Widget createPasscodeField(
    MockPasscodeService mockPasscodeService,
    TextEditingController passcodeController,
    Function(String)? validator,
    Function(String)? onChanged,
    bool autoFocus,
    String passcodeInvalidMessage) {
  getIt.registerSingleton<PasscodeService>(mockPasscodeService);

  return MaterialApp(
      home: Scaffold(
          body: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: _formKey,
              child: PasscodeField(
                  key: const Key(key),
                  passcodeController: passcodeController,
                  validator: validator,
                  onChanged: onChanged,
                  autoFocus: autoFocus,
                  passcodeInvalidMessage: passcodeInvalidMessage))));
}

@GenerateMocks([PasscodeService])
void main() {
  late MockPasscodeService mockPasscodeService;

  setUp(() async {
    mockPasscodeService = MockPasscodeService();

    // reset before each test to prevent errors with duplicate MockPasscodeService
    await getIt.reset();
  });

  group('Test building passcode field', () {
    testWidgets(
        'Given new passcode field When initialised Then check displays correctly ',
        (tester) async {
      final passcodeController = TextEditingController();
      const passcodeInvalidMessage = 'Passcode is invalid';
      const autoFocus = true;

      await tester.pumpWidget(createPasscodeField(mockPasscodeService,
          passcodeController, null, null, autoFocus, passcodeInvalidMessage));

      expect(find.byKey(const Key(key)), findsOneWidget);
    });
  });

  group('Test validating passcode field', () {
    testWidgets(
        'Given passcode field When entering valid passcode Then do not display fail validation',
        (tester) async {
      final passcodeController = TextEditingController();
      const passcodeInvalidMessage = 'Passcode is invalid';
      const autoFocus = true;
      String validPasscode = '1234';

      when(mockPasscodeService.validatePasscode(validPasscode))
          .thenAnswer((_) => true);

      await tester.pumpWidget(createPasscodeField(mockPasscodeService,
          passcodeController, null, null, autoFocus, passcodeInvalidMessage));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), validPasscode);
      bool isValid = _formKey.currentState!.validate();

      expect(isValid, isTrue);
      verify(mockPasscodeService.validatePasscode(validPasscode)).called(1);
    });

    testWidgets(
        'Given passcode field When entering short passcode Then display fail validation',
        (tester) async {
      final passcodeController = TextEditingController();
      const passcodeInvalidMessage = 'Passcode is invalid';
      const autoFocus = true;
      String invalidPasscode = '1';

      when(mockPasscodeService.validatePasscode(invalidPasscode))
          .thenAnswer((_) => false);
      await tester.pumpWidget(createPasscodeField(mockPasscodeService,
          passcodeController, null, null, autoFocus, passcodeInvalidMessage));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), invalidPasscode);
      bool isValid = _formKey.currentState!.validate();

      expect(isValid, isFalse);
      verify(mockPasscodeService.validatePasscode(invalidPasscode)).called(1);
    });

    testWidgets(
        'Given passcode field When entering long passcode Then display fail validation',
        (tester) async {
      final passcodeController = TextEditingController();
      const passcodeInvalidMessage = 'Passcode is invalid';
      const autoFocus = true;
      String invalidPasscode = 'a' * (PasscodeService.maxPasscodeLength + 1);

      when(mockPasscodeService.validatePasscode(invalidPasscode))
          .thenAnswer((_) => false);
      when(mockPasscodeService
              .validatePasscode(invalidPasscode.substring(0, PasscodeService.maxPasscodeLength)))
          .thenAnswer((_) => true); // passcode field restricts to 10 chars
      await tester.pumpWidget(createPasscodeField(mockPasscodeService,
          passcodeController, null, null, autoFocus, passcodeInvalidMessage));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), invalidPasscode);
      bool isValid = _formKey.currentState!.validate();

      expect(isValid, isTrue);
      verifyNever(mockPasscodeService.validatePasscode(invalidPasscode));
      verify(mockPasscodeService
              .validatePasscode(invalidPasscode.substring(0, PasscodeService.maxPasscodeLength)))
          .called(1);
    });

    testWidgets(
        'Given passcode field When entering invalid passcode Then fail validation',
        (tester) async {
      final passcodeController = TextEditingController();
      const passcodeInvalidMessage = 'Passcode is invalid';
      const autoFocus = true;
      String invalidPasscode = 'abc';

      when(mockPasscodeService.validatePasscode(invalidPasscode))
          .thenAnswer((_) => false);
      await tester.pumpWidget(createPasscodeField(mockPasscodeService,
          passcodeController, null, null, autoFocus, passcodeInvalidMessage));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), invalidPasscode);
      bool isValid = _formKey.currentState!.validate();

      expect(isValid, isFalse);
      verify(mockPasscodeService.validatePasscode(invalidPasscode)).called(1);
    });

    testWidgets(
        'Given passcode field When validating Then call custom validator method',
        (tester) async {
      final passcodeController = TextEditingController();
      const passcodeInvalidMessage = 'Passcode is invalid';
      const autoFocus = true;
      String passcode = 'abc';
      bool validatorCalled = false;
      String validatorPasscode = '';
      validator(passcode) {
        validatorCalled = true;
        validatorPasscode = passcode;
        return null;
      }

      when(mockPasscodeService.validatePasscode(passcode))
          .thenAnswer((_) => true);
      await tester.pumpWidget(createPasscodeField(
          mockPasscodeService,
          passcodeController,
          validator,
          null,
          autoFocus,
          passcodeInvalidMessage));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), passcode);
      bool isValid = _formKey.currentState!.validate();

      expect(validatorCalled, isTrue);
      expect(validatorPasscode, passcode);
      expect(isValid, isTrue);
      verify(mockPasscodeService.validatePasscode(passcode)).called(1);
    });
    testWidgets(
        'Given passcode field When failing custom validator method Then fail validation',
        (tester) async {
      final passcodeController = TextEditingController();
      const passcodeInvalidMessage = 'Passcode is invalid';
      const autoFocus = true;
      String passcode = 'abc';
      bool validatorCalled = false;
      String validatorPasscode = '';
      validator(passcode) {
        validatorCalled = true;
        validatorPasscode = passcode;
        return passcodeInvalidMessage;
      }

      when(mockPasscodeService.validatePasscode(passcode))
          .thenAnswer((_) => true);
      await tester.pumpWidget(createPasscodeField(
          mockPasscodeService,
          passcodeController,
          validator,
          null,
          autoFocus,
          passcodeInvalidMessage));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), passcode);
      bool isValid = _formKey.currentState!.validate();

      expect(validatorCalled, isTrue);
      expect(validatorPasscode, passcode);
      expect(isValid, isFalse);
      verify(mockPasscodeService.validatePasscode(passcode)).called(1);
    });
  });

  group('Test onChange event of passcode field', () {
    testWidgets(
        'Given passcode field When entering passcode Then trigger onChange event',
        (tester) async {
      final passcodeController = TextEditingController();
      const passcodeInvalidMessage = 'Passcode is valid';
      const autoFocus = true;
      String passcode = '123456';
      bool onChangedCalled = false;
      String onChangedPasscode = '';
      onChanged(passcode) {
        onChangedCalled = true;
        onChangedPasscode = passcode;
      }

      await tester.pumpWidget(createPasscodeField(
          mockPasscodeService,
          passcodeController,
          null,
          onChanged,
          autoFocus,
          passcodeInvalidMessage));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), passcode);

      expect(onChangedCalled, isTrue);
      expect(onChangedPasscode, passcode);
    });
  });
}
