import 'package:drift/drift.dart';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'package:sqlite3/sqlite3.dart';

import 'android_connection.dart';
import 'linux_connection.dart';
import 'windows_connection.dart';

const _encryptionPassword = 'drift.example.unsafe_password';

abstract class Connection {
  LazyDatabase openConnection() {
    // the LazyDatabase util lets us find the right location for the file async.
    return LazyDatabase(() async {
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

      return NativeDatabase.createInBackground(
        file,
        isolateSetup: setupSqlCipher,
        setup: (db) {
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
          final escapedKey = _encryptionPassword.replaceAll("'", "''");
          db.execute("pragma key = '$escapedKey'");

          // Enable foreign keys
          db.execute('PRAGMA foreign_keys = ON');

          // Test that the key is correct by selecting from a table
          db.execute('select count(*) from sqlite_master');
        },
      );
    });
  }

  // allows implementing classes to setup SQLCipher for their platform
  Future<void> setupSqlCipher() async {}

  static LazyDatabase getDatabaseConnection() {
    Connection c = _getPlatformConnection();
    return c.openConnection();
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
