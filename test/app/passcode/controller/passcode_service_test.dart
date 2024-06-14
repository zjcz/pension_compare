import 'package:crypt/crypt.dart';
import 'package:pension_compare/app/passcode/controller/passcode_service.dart';
import 'package:test/test.dart';
import 'package:matcher/matcher.dart' as match;

void main() {
  group('Test read/write passcode', () {
    test('Given no passcode is set, when a passcode is set expect to read it',
        () async {
      String passcode = '1234';
      // Given
      final passcodeService = PasscodeService();
      //final pass
      // When
      final result = passcodeService.setPasscode(passcode);
      // Then
      expect(passcodeService.isPasscodeSet(), true);
      expect(passcodeService.getPasscode(), passcode);
      expect(result, isTrue);
    });

    test('Given no passcode is set, when calling isPasscodeSet() expect false',
        () async {
      // Given
      final passcodeService = PasscodeService();
      // When
      // Then
      expect(passcodeService.isPasscodeSet(), false);
    });

    test(
        'Given no passcode is set, when an invalid passcode is set expect passcode to remain not set',
        () async {
      // Given
      final passcodeService = PasscodeService();
      // When
      final result = passcodeService.setPasscode('123');
      // Then
      expect(passcodeService.isPasscodeSet(), false);
      expect(passcodeService.getPasscode(), isNull);
      expect(result, isFalse);
    });

    test(
        'Given no passcode is set, when a passcode is too long expect passcode to remain not set',
        () async {
      // Given
      final passcodeService = PasscodeService();
      // When
      final result = passcodeService.setPasscode('12345678901');
      // Then
      expect(passcodeService.isPasscodeSet(), false);
      expect(passcodeService.getPasscode(), isNull);
      expect(result, isFalse);
    });
  });

  group('Test encryption', () {
    test('Given a passcode, when encrypting it expect to get a hash', () async {
      // Given
      final passcodeService = PasscodeService();
      const passcode = '1234';
      // When
      final encryptedPasscode = passcodeService.encryptPasscode(passcode);
      // Then
      expect(encryptedPasscode, const match.TypeMatcher<String>());
      expect(encryptedPasscode, isNot(passcode));
      expect(encryptedPasscode,
          Crypt.sha256(passcode, rounds: 1000, salt: passcode).hash);
    });

    test(
        'Given a passcode, when encrypting it expect to not equal similar passcodes',
        () async {
      // Given
      final passcodeService = PasscodeService();
      const passcode1 = '1234';
      const passcode2 = '4321';
      // When
      final encryptedPasscode1 = passcodeService.encryptPasscode(passcode1);
      final encryptedPasscode2 = passcodeService.encryptPasscode(passcode2);
      // Then
      expect(encryptedPasscode1 == encryptedPasscode2, isFalse);
    });
  });

  group('Validate passcode', () {
    test('Given a valid passcode, when validating it then return true',
        () async {
      // Given
      final passcodeService = PasscodeService();
      const passcode = '1234';
      // When
      final isValid = passcodeService.validatePasscode(passcode);
      // Then
      expect(isValid, isTrue);
    });

    test('Given a passcode, when too short then return false', () async {
      // Given
      final passcodeService = PasscodeService();
      const passcode = '123';
      // When
      final isValid = passcodeService.validatePasscode(passcode);
      // Then
      expect(isValid, isFalse);
    });

    test('Given a passcode, when too long then return false', () async {
      // Given
      final passcodeService = PasscodeService();
      const passcode = '12345678901';
      // When
      final isValid = passcodeService.validatePasscode(passcode);
      // Then
      expect(isValid, isFalse);
    });

    test('Given a passcode, when it contains letters then return false',
        () async {
      // Given
      final passcodeService = PasscodeService();
      const passcode = '1234a';
      // When
      final isValid = passcodeService.validatePasscode(passcode);
      // Then
      expect(isValid, isFalse);
    });

    test('Given a passcode, when it contains characters then return false',
        () async {
      // Given
      final passcodeService = PasscodeService();
      const passcode = '1234@';
      // When
      final isValid = passcodeService.validatePasscode(passcode);
      // Then
      expect(isValid, isFalse);
    });

    test('Given a passcode, when it contains decimal point then return false',
        () async {
      // Given
      final passcodeService = PasscodeService();
      const passcode = '1234.56';
      // When
      final isValid = passcodeService.validatePasscode(passcode);
      // Then
      expect(isValid, isFalse);
    });

    test(
        'Given a passcode, when it contains large valid number then return true',
        () async {
      // Given
      final passcodeService = PasscodeService();
      const passcode = '9999999999';
      // When
      final isValid = passcodeService.validatePasscode(passcode);
      // Then
      expect(isValid, isTrue);
    });
  });

  // TODO need to test validation.  Need to change signature to dependency injection?
}
