import 'package:drift/drift.dart';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:sqlite3/sqlite3.dart';

import 'android_connection.dart';
import 'linux_connection.dart';
import 'windows_connection.dart';

abstract class Connection {
  LazyDatabase openConnection(String encryptionPassword,
      {bool createInIsolate = true}) {
    // the LazyDatabase util lets us find the right location for the file async.
    return LazyDatabase(() async {
      setupSqlCipher();

      // put the database file, called db.sqlite here, into the documents folder
      // for your app.
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(path.join(dbFolder.path, 'db.sqlite'));

      // Make sqlite3 pick a more suitable location for temporary files - the
      // one from the system may be inaccessible due to sandboxing.
      final cachebase = (await getTemporaryDirectory()).path;
      // We can't access /tmp on Android, which sqlite3 would try by default.
      // Explicitly tell it about the correct temporary directory.
      sqlite3.tempDirectory = cachebase;

      setup(db) {
        // Check that we're actually running with SQLCipher by quering the
        // cipher_version pragma.
        final result = db.select('pragma cipher_version');
        if (result.isEmpty) {
          throw UnsupportedError(
            'This database needs to run with SQLCipher, but that library is '
            'not available!',
          );
        }

        // Then, apply the key to encrypt the database. Unfortunately, this
        // pragma doesn't seem to support prepared statements so we inline the
        // key.
        final escapedKey = (encryptionPassword).replaceAll("'", "''");
        db.execute("pragma key = '$escapedKey'");

        // Test that the key is correct by selecting from a table
        try {
          db.execute('select count(*) from sqlite_master');
        } catch (e) {
          throw Exception('Unable to open secure database');
        }
      }

      if (createInIsolate) {
        return NativeDatabase.createInBackground(
          file,
          isolateSetup: setupSqlCipher,
          setup: setup,
        );
      } else {
        return NativeDatabase(file,
//        isolateSetup: setupSqlCipher,
            setup: setup);
      }
    });
  }

  // allows implementing classes to setup SQLCipher for their platform
  Future<void> setupSqlCipher() async {}

  static LazyDatabase getDatabaseConnection(String encryptionPassword,
      {bool createInIsolate = true}) {
    Connection c = _getPlatformConnection();
    return c.openConnection(encryptionPassword,
        createInIsolate: createInIsolate);
  }

  static Connection _getPlatformConnection() {
    if (Platform.isAndroid) {
      return AndroidConnection();
    } else if (Platform.isLinux) {
      return LinuxConnection();
    } else if (Platform.isWindows) {
      return WindowsConnection();
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }
}
