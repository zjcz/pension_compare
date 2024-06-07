import 'package:crypt/crypt.dart';
import 'package:pension_compare/data/database/database_service.dart';

class PasscodeService {
  static const minPasscodeLength = 4;
  static const maxPasscodeLength = 10;

  String? _passcode;
  bool isPasscodeSet() {
    return _passcode != null;
  }

  String? getPasscode() {
    return _passcode;
  }

  String getEncryptedPasscode() {
    return encryptPasscode(_passcode ?? '');
  }

  bool setPasscode(String newPasscode, {DatabaseService? databaseService}) {
    if (!_validatePasscode(newPasscode)) {
      return false;
    }
    if (databaseService != null) {
      databaseService.setNewEncryptedPassword(encryptPasscode(newPasscode));
    }
    _passcode = newPasscode;
    return true;
  }

  bool _validatePasscode(String passcode) {
    return passcode.length >= minPasscodeLength &&
        passcode.length <= maxPasscodeLength;
  }

  Future<bool> validatePasscode(String passcode) async {
    bool isValid = _validatePasscode(passcode);

    if (isValid) {
      DatabaseService ds =
          DatabaseService.withDefaultConnection(encryptPasscode(passcode));

      try {
        isValid = await ds.testConnection();
      } finally {
        ds.close();
      }
    }
    return isValid;
  }

  String encryptPasscode(String passcode) {
    return Crypt.sha256(passcode, rounds: 1000, salt: passcode).hash;
  }
}
