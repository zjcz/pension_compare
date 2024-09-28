import 'package:crypt/crypt.dart';
import 'package:pension_compare/app/passcode/controller/passcode_service.dart';
import 'package:test/test.dart';
import 'package:matcher/matcher.dart' as match;

void main() {
  String tooLongPasscode = 'a' * 65;
  String validPasscode = '12345678';

  group('Test read/write passcode', () {
    test('Given no passcode is set, when a passcode is set expect to read it',
        () async {
      // Given
      final passcodeService = PasscodeService();
      //final pass
      // When
      final result = passcodeService.setPasscode(validPasscode);
      // Then
      expect(passcodeService.isPasscodeSet(), true);
      expect(passcodeService.getPasscode(), validPasscode);
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
      final result = passcodeService.setPasscode(tooLongPasscode);
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

      // When
      final encryptedPasscode = passcodeService.encryptPasscode(validPasscode);
      // Then
      expect(encryptedPasscode, const match.TypeMatcher<String>());
      expect(encryptedPasscode, isNot(validPasscode));
      expect(
          encryptedPasscode,
          Crypt.sha256(validPasscode,
                  rounds: 1000, salt: PasscodeService.passcodeSalt)
              .hash);
    });

    test(
        'Given a passcode, when encrypting it expect to not equal similar passcodes',
        () async {
      // Given
      final passcodeService = PasscodeService();
      const passcode1 = '12345678';
      const passcode2 = '87654321';
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

      // When
      final isValid = passcodeService.validatePasscode(validPasscode);
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

      // When
      final isValid = passcodeService.validatePasscode(tooLongPasscode);
      // Then
      expect(isValid, isFalse);
    });

    test('Given a passcode, when it contains only numbers then return true',
        () async {
      // Given
      final passcodeService = PasscodeService();
      const passcode = '1234567890';
      // When
      final isValid = passcodeService.validatePasscode(passcode);
      // Then
      expect(isValid, isTrue);
    });

    test(
        'Given a passcode, when it contains only lowercase letters then return true',
        () async {
      // Given
      final passcodeService = PasscodeService();
      const passcode = 'abcdefghijklmnopqrstuvwxyz';
      // When
      final isValid = passcodeService.validatePasscode(passcode);
      // Then
      expect(isValid, isTrue);
    });

    test(
        'Given a passcode, when it contains only uppercase letters then return true',
        () async {
      // Given
      final passcodeService = PasscodeService();
      const passcode = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
      // When
      final isValid = passcodeService.validatePasscode(passcode);
      // Then
      expect(isValid, isTrue);
    });

    test('Given a passcode, when it contains only symbols then return true',
        () async {
      // Given
      final passcodeService = PasscodeService();
      const passcode = '!@#%^&*(),.?":{}|<>';
      // When
      final isValid = passcodeService.validatePasscode(passcode);
      // Then
      expect(isValid, isTrue);
    });

    test('Given a passcode, when it contains mixed characters then return true',
        () async {
      // Given
      final passcodeService = PasscodeService();
      const passcode = 'abc1234567890ABC!@#%^&*(),.?":{}|<>';
      // When
      final isValid = passcodeService.validatePasscode(passcode);
      // Then
      expect(isValid, isTrue);
    });
  });

  group('Validate passcode with message', () {
    test('Given a valid passcode, when validating it then return null',
        () async {
      // Given
      final passcodeService = PasscodeService();

      // When
      final result = passcodeService.validatePasscodeWithMessage(validPasscode);
      // Then
      expect(result, isNull);
    });

    test('Given a passcode, when too short then return false', () async {
      // Given
      final passcodeService = PasscodeService();
      const passcode = '123';
      // When
      final result = passcodeService.validatePasscodeWithMessage(passcode);
      // Then
      expect(result, 'Password must be at least 8 characters long');
    });

    test('Given a passcode, when too long then return false', () async {
      // Given
      final passcodeService = PasscodeService();

      // When
      final result = passcodeService.validatePasscodeWithMessage(tooLongPasscode);
      // Then
      expect(result, 'Password must be at most 64 characters long');
    });

    test('Given a passcode, when it contains only numbers then return true',
        () async {
      // Given
      final passcodeService = PasscodeService();
      const passcode = '££££££££';
      // When
      final result = passcodeService.validatePasscodeWithMessage(passcode);
      // Then
      expect(result,
          'Password must only contain letters, numbers, and special characters');
    });
  });
}
