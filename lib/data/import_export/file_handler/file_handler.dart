import 'package:pension_compare/data/import_export/exporter.dart';

abstract class FileHandler {
  final String filename;

  FileHandler({required this.filename});

  /// Save the export files to the [filename]
  Future<void> saveFile(List<ExportDataModel> exportDataFiles);

  /// Load the export files from the [filename] and return a list of ExportDataModel objects
  /// [fileExtensionFilter] is an optional filter to only load files with the specified extension
  Future<List<ExportDataModel>> loadFile(String? fileExtensionFilter);
}
