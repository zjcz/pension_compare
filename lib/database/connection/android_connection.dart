import 'connection.dart';

import 'package:sqlite3/open.dart';
import 'package:sqlcipher_flutter_libs/sqlcipher_flutter_libs.dart';

class AndroidConnection extends Connection {
  @override
  Future<void> setupSqlCipher() async {
    await applyWorkaroundToOpenSqlCipherOnOldAndroidVersions();

    open.overrideFor(OperatingSystem.android, openCipherOnAndroid);
  }
}
