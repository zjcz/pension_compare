//import 'package:file_picker/file_picker.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';

class FilePickerHelper {
  static const String openDialogTitle = 'Restore from File';
  static const String saveDialogTitle = 'Backup to File';
  static const String defaultFileExtension = 'pen';

  /// Allow the user to select a file to save to.  Returns null if user cancels,
  /// otherwise the full path to the file
  static Future<String?> getSaveToFilename(String filenameToSave) async {
    final params = SaveFileDialogParams(sourceFilePath: filenameToSave, fileName: "backup.pen");
    final filePath = await FlutterFileDialog.saveFile(params: params);
    return filePath;
    // return await FilePicker.platform.saveFile(
    //   type: FileType.custom,
    //   allowedExtensions: [defaultFileExtension],
    //   dialogTitle: saveDialogTitle,
    // );
  }

  // /// Allow the user to select a file to import.  Returns null if user cancels,
  // /// otherwise the PlatformFile object containing the file
  // static Future<PlatformFile?> getOpenFilename() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     allowedExtensions: [defaultFileExtension],
  //     dialogTitle: openDialogTitle,
  //   );

  //   if (result == null) {
  //     return null;
  //   }

  //   return result.files.first;
  // }
}
