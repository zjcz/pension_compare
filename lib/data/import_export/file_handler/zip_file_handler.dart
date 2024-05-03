import 'package:archive/archive_io.dart';
import 'package:pension_compare/data/import_export/exporter.dart';
import 'package:pension_compare/data/import_export/file_handler/file_handler.dart';

class ZipFileHandler extends FileHandler {
  final String? password;

  ZipFileHandler({
    required this.password,
    required super.filename,
  });

@override
  void saveFile(List<ExportDataModel> exportDataFiles) {
    // Save the export files
    var encoder = ZipFileEncoder(password: password);
    encoder.create(filename);
    for (ExportDataModel exportDataFile in exportDataFiles) {
      encoder.addArchiveFile(ArchiveFile(exportDataFile.filename,
          exportDataFile.fileContents.length, exportDataFile.fileContents));
    }
    encoder.closeSync();
  }
  
  @override
  List<ExportDataModel> loadFile() {
    // TODO: implement loadFile
    throw UnimplementedError();
  }

  
}
