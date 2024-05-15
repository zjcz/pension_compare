import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/data/import_export/exporter.dart';
import 'package:pension_compare/data/import_export/file_formatter/json_export_file_type.dart';
import 'package:pension_compare/data/import_export/file_handler/zip_file_handler.dart';
import 'package:path/path.dart' as path;
import 'package:pension_compare/helpers/file_picker_helper.dart';

class BackupRestoreHelper {
  static Future<BackupRestoreResponse> backupData(
      DatabaseService databaseService,
      SettingsService settingsService,
      String? password) async {
    // Check if password is empty and set it to null
    if (password != null && password.isEmpty) {
      password = null;
    }

    final tempPath = await getTemporaryDirectory();

    final tempFilename = path.join(tempPath.path, 'export.zip');
    if (await File(tempFilename).exists()) {
      await File(tempFilename).delete();
    }
    try {
      Exporter exporter = Exporter(
          databaseService: databaseService,
          settingsService: settingsService,
          exportFileType: JsonExportFileType(),
          fileHandler:
              ZipFileHandler(filename: tempFilename, password: password));
      await exporter.export();
    } catch (e) {
      return BackupRestoreResponse(
          success: false, message: 'Error exporting data: $e');
    }

    try {
      File f = File(tempFilename);
      final fileContents = await f.readAsBytes();
      await f.delete();

      final finalfilename =
          await FilePickerHelper.getSaveToFilename(fileContents);
      if (finalfilename == null) {
        return BackupRestoreResponse(success: false, userCancelled: true);
      }
    } catch (e) {
      return BackupRestoreResponse(
          success: false, message: 'Error saving data: $e');
    }

    return BackupRestoreResponse(
        success: true, message: 'Backup saved successfully');
  }

  static Future<BackupRestoreResponse> importData(
      DatabaseService databaseService,
      SettingsService settingsService,
      String? password) async {
    // Check if password is empty and set it to null
    if (password != null && password.isEmpty) {
      password = null;
    }

    final finalfilename = await FilePickerHelper.getOpenFilename();
    if (finalfilename == null) {
      return BackupRestoreResponse(success: false, userCancelled: true);
    }

    Exporter exporter = Exporter(
        databaseService: databaseService,
        settingsService: settingsService,
        exportFileType: JsonExportFileType(),
        fileHandler:
            ZipFileHandler(filename: finalfilename, password: password));

    try {
      await exporter.import();
    } catch (e) {
      return BackupRestoreResponse(
          success: false, message: 'Error restoring backup: $e');
    }

    return BackupRestoreResponse(success: true, message: 'Restore complete');
  }
}

class BackupRestoreResponse {
  final bool success;
  final String? message;
  final bool userCancelled;

  BackupRestoreResponse(
      {required this.success, this.message, this.userCancelled = false});
}
