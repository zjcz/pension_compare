import 'connection.dart';

import 'dart:ffi';
import 'package:sqlite3/open.dart';

class LinuxConnection extends Connection {
  @override
  Future<void> setupSqlCipher() async {
    open.overrideFor(
        OperatingSystem.linux, () => DynamicLibrary.open('libsqlcipher.so'));
  }
}
