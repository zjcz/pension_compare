import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

class FilePickerHelper {
  static const String openDialogTitle = 'Restore from File';
  static const String saveDialogTitle = 'Backup to File';
  static const String defaultFileExtension = 'zip';

  /// Allow the user to select a file to save to.  Returns null if user cancels,
  /// otherwise the full path to the file
  static Future<String?> getSaveToFilename(Uint8List? fileContents) async {
    try {
      return await FilePicker.platform.saveFile(
        type: FileType.custom,
        allowedExtensions: [defaultFileExtension],
        dialogTitle: saveDialogTitle,
        fileName: "backup.$defaultFileExtension",
        bytes: fileContents,
      );
    } catch (e) {
      print('Error saving file: $e');
      return null;
    }
  }

  /// Allow the user to select a file to import.  Returns null if user cancels,
  /// otherwise the PlatformFile object containing the file
  static Future<String?> getOpenFilename() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      //allowedExtensions: [defaultFileExtension],
      dialogTitle: openDialogTitle,
    );

    return result?.files.first.path;
  }
}
