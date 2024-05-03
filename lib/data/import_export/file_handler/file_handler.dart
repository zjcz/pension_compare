import 'package:pension_compare/data/import_export/exporter.dart';

abstract class FileHandler {
  final String filename;

  FileHandler({required this.filename});

  void saveFile(List<ExportDataModel> exportDataFiles);
  List<ExportDataModel> loadFile();
}
