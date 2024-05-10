import 'package:pension_compare/data/import_export/exporter.dart';
import 'package:pension_compare/data/import_export/file_handler/zip_file_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as p;

void main() {
  group('Test extracting zip files', () {
    testWidgets('can open valid zip file', (tester) async {
      String filename = p.join('test', 'res', 'zips', 'backup_no_password.zip');
      String? password;

      ZipFileHandler zipFileHandler =
          ZipFileHandler(filename: filename, password: password);
      List<ExportDataModel> exportDataModel =
          zipFileHandler.loadFileSync('json');

      expect(exportDataModel, isNotNull);
      expect(exportDataModel.length, 4);
      expect(exportDataModel[0].filename, 'pension_data.json');
      expect(exportDataModel[0].fileContents, isNotEmpty);
      expect(exportDataModel[1].filename, 'other_income_data.json');
      expect(exportDataModel[1].fileContents, isNotEmpty);
      expect(exportDataModel[2].filename, 'settings_data.json');
      expect(exportDataModel[2].fileContents, isNotEmpty);
      expect(exportDataModel[3].filename, 'backup_config.json');
      expect(exportDataModel[3].fileContents, isNotEmpty);
    });

    testWidgets('can open password protected zip file', (tester) async {
      String filename =
          p.join('test', 'res', 'zips', 'backup_with_password.zip');
      String? password = 'abc';

      ZipFileHandler zipFileHandler =
          ZipFileHandler(filename: filename, password: password);
      List<ExportDataModel> exportDataModel =
          zipFileHandler.loadFileSync('json');

      expect(exportDataModel, isNotNull);
      expect(exportDataModel.length, 4);
      expect(exportDataModel[0].filename, 'pension_data.json');
      expect(exportDataModel[0].fileContents, isNotEmpty);
      expect(exportDataModel[1].filename, 'other_income_data.json');
      expect(exportDataModel[1].fileContents, isNotEmpty);
      expect(exportDataModel[2].filename, 'settings_data.json');
      expect(exportDataModel[2].fileContents, isNotEmpty);
      expect(exportDataModel[3].filename, 'backup_config.json');
      expect(exportDataModel[3].fileContents, isNotEmpty);
    });

    testWidgets('cannot open password protected zip file with invalid password',
        (tester) async {
      String filename =
          p.join('test', 'res', 'zips', 'backup_with_password.zip');
      String? password = 'invalid';

      ZipFileHandler zipFileHandler =
          ZipFileHandler(filename: filename, password: password);

      expectLater(() => zipFileHandler.loadFileSync('json'), throwsException);
    });

    testWidgets('cannot open invalid zip file', (tester) async {
      String filename = p.join('test', 'res', 'zips', 'invalid_backup.zip');
      String? password;

      ZipFileHandler zipFileHandler =
          ZipFileHandler(filename: filename, password: password);

      expectLater(() => zipFileHandler.loadFileSync('json'), throwsException);
    });

    testWidgets('can open empty but valid zip file', (tester) async {
      String filename = p.join('test', 'res', 'zips', 'empty_export.zip');
      String? password;

      ZipFileHandler zipFileHandler =
          ZipFileHandler(filename: filename, password: password);

      List<ExportDataModel> exportDataModel =
          zipFileHandler.loadFileSync('json');

      expect(exportDataModel, isNotNull);
      expect(exportDataModel.length, isZero);
    });

    testWidgets('ignore files not matching json extension', (tester) async {
      String filename = p.join(
          'test', 'res', 'zips', 'valid_zip_containing_no_json_files.zip');
      String? password;

      ZipFileHandler zipFileHandler =
          ZipFileHandler(filename: filename, password: password);

      List<ExportDataModel> exportDataModel =
          zipFileHandler.loadFileSync('json');

      expect(exportDataModel, isNotNull);
      expect(exportDataModel.length, isZero);
    });
  });
}
