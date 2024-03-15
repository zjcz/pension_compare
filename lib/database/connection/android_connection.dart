import 'connection.dart';

import 'dart:ffi';
import 'dart:io';
import 'package:sqlite3/open.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

class AndroidConnection extends Connection {
  @override
  Future<void> setupSqlCipher() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();
    }

    open
      ..overrideFor(OperatingSystem.android, openCipherOnAndroid)
      ..overrideFor(
          OperatingSystem.linux, () => DynamicLibrary.open('libsqlcipher.so'))
      ..overrideFor(
          OperatingSystem.windows, () => DynamicLibrary.open('sqlcipher.dll'));
  }
}
