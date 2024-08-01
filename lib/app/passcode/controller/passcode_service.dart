import 'package:crypt/crypt.dart';
import 'package:pension_compare/data/database/database_service.dart';

class PasscodeService {
  static const minPasscodeLength = 4;
  static const maxPasscodeLength = 10;
  static const passcodeSalt =
      'C^kWkXoS53Jnc%rlbQl77d5t5Rym7Y5DQ0h@nYC@rlVbaRyvSVw9x7peLbfW4bBehUkpoO*E&xepRUt8aM42jVdk4Mf7KzkquPMi!nJsQ1jIN3#sTPUOI#L#Da4vWlOx';

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

  /// Set the passcode to use when accessing the database
  bool setPasscode(String newPasscode) {
    if (!validatePasscode(newPasscode)) {
      return false;
    }
    _passcode = newPasscode;
    return true;
  }

  /// Change the passcode to use when accessing the database
  bool changePasscode(String newPasscode, DatabaseService databaseService) {
    if (!validatePasscode(newPasscode)) {
      return false;
    }
    databaseService.setNewEncryptedPassword(encryptPasscode(newPasscode));
    _passcode = newPasscode;
    return true;
  }

  bool validatePasscode(String passcode) {
    return passcode.length >= minPasscodeLength &&
        passcode.length <= maxPasscodeLength &&
        (int.tryParse(passcode) != null);
  }

  /// Test the passcode by opening a database connection
  Future<bool> testPasscode(String passcode) async {
    bool isValid = validatePasscode(passcode);

    if (isValid) {
      DatabaseService ds = DatabaseService.withDefaultConnection(
          encryptPasscode(passcode),
          createInIsolate: false);

      try {
        isValid = await ds.testConnection();
      } catch (e) {
        isValid = false;
      } finally {
        await ds.close();
      }
    }
    return isValid;
  }

  String encryptPasscode(String passcode) {
    return Crypt.sha256(passcode, rounds: 1000, salt: passcodeSalt).hash;
  }
}
