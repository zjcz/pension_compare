import 'connection.dart';

import 'dart:ffi';
import 'package:sqlite3/open.dart';

class WindowsConnection extends Connection {
  @override
  Future<void> setupSqlCipher() async {
    open.overrideFor(
        OperatingSystem.windows, () => DynamicLibrary.open('sqlcipher.dll'));
  }
}
