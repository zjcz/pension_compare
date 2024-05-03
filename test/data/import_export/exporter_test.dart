import 'package:mockito/annotations.dart';
import 'package:pension_compare/app/settings/settings.dart';
import 'package:pension_compare/app/settings/settings_service.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/data/import_export/exporter.dart';
import 'package:pension_compare/data/import_export/file_formatter/json_export_file_type.dart';
import 'package:pension_compare/data/import_export/file_handler/file_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'exporter_test.mocks.dart';

@GenerateMocks([DatabaseService, SettingsService])
void main() {
  group('Test exporter to file', () {
    testWidgets('export data to files', (tester) async {
      DatabaseService databaseService = MockDatabaseService();
      when(databaseService.getAllPensions()).thenAnswer((_) => Stream.value([
            Pension(
                pensionId: 1,
                name: 'Test Pension',
                maturityDate: DateTime(2024, 1, 1))
          ]));
      when(databaseService.getStatePension()).thenAnswer((_) async =>
          const OtherIncome(
              otherIncomeId: 1, name: 'State Pension', annualAmount: 1000));
      when(databaseService.getAllStatementsForPension(1))
          .thenAnswer((_) => Stream.value([
                Statement(
                    statementId: 1,
                    pension: 1,
                    statementDate: DateTime(2024, 1, 1),
                    planValue: 1000,
                    projectedAnnualAmount: 2000,
                    yearlyCharges: 3000,
                    transferValue: 4000)
              ]));

      final settingsService = MockSettingsService();
      when(settingsService.getSettings()).thenAnswer((_) async =>
          Settings(retirementDate: DateTime(2050, 1, 1), targetIncome: 9000));

      final fileHandler = MockFileHandler();

      Exporter exporter = Exporter(
          databaseService: databaseService,
          settingsService: settingsService,
          exportFileType: JsonExportFileType(),
          fileHandler: fileHandler);

      await exporter.export();

      // verify the data the File Handler was asked to save
      expect(fileHandler.exportDataFiles, isNotNull);
      expect(fileHandler.exportDataFiles.length, 3);
      expect(fileHandler.exportDataFiles[0].filename, 'pension_data.json');
      expect(fileHandler.exportDataFiles[1].filename, 'other_income_data.json');
      expect(fileHandler.exportDataFiles[2].filename, 'settings_data.json');
      expect(fileHandler.exportDataFiles[0].fileContents, isNotEmpty);
      expect(fileHandler.exportDataFiles[1].fileContents, isNotEmpty);
      expect(fileHandler.exportDataFiles[2].fileContents, isNotEmpty);

      verify(databaseService.getAllPensions()).called(1);
      verify(databaseService.getStatePension()).called(1);
      verify(databaseService.getAllStatementsForPension(1)).called(1);
      verify(settingsService.getSettings()).called(1);
    });
  });
}

class MockFileHandler extends Mock implements FileHandler {
  List<ExportDataModel> exportDataFiles = [];

  @override
  void saveFile(List<ExportDataModel> exportDataFiles) {
    this.exportDataFiles = exportDataFiles;
  }
}
