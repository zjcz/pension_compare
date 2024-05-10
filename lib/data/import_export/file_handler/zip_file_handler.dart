import 'dart:io';
import 'dart:typed_data';

import 'package:archive/archive_io.dart';
import 'package:pension_compare/data/import_export/exporter.dart';
import 'package:pension_compare/data/import_export/file_handler/file_handler.dart';
import 'package:pension_compare/data/import_export/file_handler/file_handler_exception.dart';
import 'dart:convert';

class ZipFileHandler extends FileHandler {
  final String? password;

  ZipFileHandler({
    required this.password,
    required super.filename,
  });

  /// Save the export files to the [filename]
  @override
  Future<void> saveFile(List<ExportDataModel> exportDataFiles) async {
    // Save the export files
    var encoder = ZipFileEncoder(password: password);

    try {
      encoder.create(filename);
      for (ExportDataModel exportDataFile in exportDataFiles) {
        encoder.addArchiveFile(ArchiveFile(exportDataFile.filename,
            exportDataFile.fileContents.length, exportDataFile.fileContents));
      }
    } on ArchiveException catch (e) {
      throw FileHandlerException(
          'Error saving the backup file: ${e.message}', e);
    } on Exception catch (e) {
      throw FileHandlerException('Error building the backup file: $e', e);
    } finally {
      // Close the encoder
      await encoder.close();
    }
  }

  /// Load the export files from the [filename] and return a list of ExportDataModel objects
  /// [fileExtensionFilter] is an optional filter to only load files with the specified extension
  @override
  Future<List<ExportDataModel>> loadFile(String? fileExtensionFilter) async {
    final file = File(filename);
    final bytes = await file.readAsBytes();

    return _processFile(bytes, password, fileExtensionFilter);
  }

  /// Load the export files from the [filename] and return a list of ExportDataModel objects
  /// [fileExtensionFilter] is an optional filter to only load files with the specified extension
  List<ExportDataModel> loadFileSync(String? fileExtensionFilter) {
    final file = File(filename);
    final bytes = file.readAsBytesSync();

    return _processFile(bytes, password, fileExtensionFilter);
  }

  List<ExportDataModel> _processFile(Uint8List fileBytes, String? password, String? fileExtensionFilter) {
    List<ExportDataModel> exportDataFiles = [];
    
    try {
      // Decode the zip from the InputFileStream. The archive will have the contents of the
      // zip, without having stored the data in memory.
      final archive = ZipDecoder().decodeBytes(fileBytes, password: password);

      // For all of the entries in the archive
      for (var file in archive.files) {
        // If it's a file and not a directory
        if (file.isFile &&
            (fileExtensionFilter == null ||
                file.name.endsWith(fileExtensionFilter))) {
          // Add the file to the list of files
          exportDataFiles.add(ExportDataModel(
              filename: file.name, fileContents: utf8.decode(file.content)));
        }
      }
    } on ArchiveException catch (e) {
      throw FileHandlerException(
          'Error reading the backup file: ${e.message}', e);
    } on Exception catch (e) {
      throw FileHandlerException('Error importing the backup file: $e', e);
    }
    return exportDataFiles;
  }
}
