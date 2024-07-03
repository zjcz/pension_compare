import 'package:mockito/annotations.dart';
import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/data/import_export/exporter.dart';
import 'package:pension_compare/data/import_export/file_formatter/json_export_file_type.dart';
import 'package:pension_compare/data/import_export/file_handler/file_handler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pension_compare/data/import_export/models/backup_config_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_other_income_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_pension_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_settings_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_statement_model.dart';
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
                maturityDate: DateTime(2024, 1, 1),
                notes: 'Some notes')
          ]));
      when(databaseService.getStatePension()).thenAnswer((_) async =>
          const OtherIncome(
              otherIncomeId: 1, name: 'State Pension', annualAmount: 1000, notes: 'More notes'));
      when(databaseService.getAllStatementsForPension(1))
          .thenAnswer((_) => Stream.value([
                Statement(
                    statementId: 1,
                    pension: 1,
                    statementDate: DateTime(2024, 1, 1),
                    planValue: 1000,
                    projectedAnnualAmount: 2000,
                    yearlyCharges: 3000,
                    transferValue: 4000,
                    statementNotes: 'Statement notes')
              ]));

      final settingsService = MockSettingsService();
      when(settingsService.getAllSettings()).thenAnswer((_) async => Settings(
          retirementDate: DateTime(2050, 1, 1),
          targetIncome: 9000,
          acceptTermsAndConditions: true,
          acceptFinancialAdviceWarning: true,
          welcomeScreenDismissed: true,
          optIntoAnalyticsWarning: true));

      final fileHandler = MockFileHandler();

      Exporter exporter = Exporter(
          databaseService: databaseService,
          settingsService: settingsService,
          exportFileType: JsonExportFileType(),
          fileHandler: fileHandler);

      await exporter.export();

      // verify the data the File Handler was asked to save
      expect(fileHandler.exportDataFiles, isNotNull);
      expect(fileHandler.exportDataFiles.length, 4);
      expect(fileHandler.exportDataFiles[0].filename, 'pension_data.json');
      expect(fileHandler.exportDataFiles[1].filename, 'other_income_data.json');
      expect(fileHandler.exportDataFiles[2].filename, 'settings_data.json');
      expect(fileHandler.exportDataFiles[3].filename, 'backup_config.json');
      expect(fileHandler.exportDataFiles[0].fileContents, isNotEmpty);
      expect(fileHandler.exportDataFiles[1].fileContents, isNotEmpty);
      expect(fileHandler.exportDataFiles[2].fileContents, isNotEmpty);
      expect(fileHandler.exportDataFiles[3].fileContents, isNotEmpty);

      verify(databaseService.getAllPensions()).called(1);
      verify(databaseService.getStatePension()).called(1);
      verify(databaseService.getAllStatementsForPension(1)).called(1);
      verify(settingsService.getAllSettings()).called(1);
    });
  });

  group('Test import from file', () {
    testWidgets('import data to database', (tester) async {
      int pensionId = 1;
      String pensionName = 'Test Pension';
      DateTime maturityDate = DateTime(2024, 1, 1);
      String pensionNotes = 'Some notes';
      int statementId = 5;
      DateTime statementDate = DateTime(2024, 1, 1);
      double planValue = 123.45;
      double projectedAnnualAmount = 678.90;
      double yearlyCharges = 987.65;
      double transferValue = 432.10;
      double amountPaidIn = 1928.37;
      String statementNotes = 'Some statement notes';
      double statePensionAnnualAmount = 34567;
      String otherIncomeNotes = 'Some other income notes';
      DateTime retirementDate = DateTime(2024, 1, 1);
      double targetIncome = 87654;
      bool acceptTermsAndConditions = true;
      bool acceptFinancialAdviceWarning = true;
      bool welcomeScreenDismissed = true;
      bool optIntoAnalyticsWarning = true;

      MockDatabaseService databaseService = MockDatabaseService();
      when(databaseService.clearAllData()).thenAnswer((_) async {});
      when(databaseService.createPension(pensionName, maturityDate, pensionNotes)).thenAnswer(
          (_) async => Pension(
              pensionId: pensionId,
              name: pensionName,
              maturityDate: maturityDate,
              notes: pensionNotes));
      when(databaseService.createStatement(pensionId, statementDate, planValue,
              projectedAnnualAmount, yearlyCharges, transferValue, amountPaidIn, statementNotes))
          .thenAnswer((_) async => Statement(
              statementId: statementId,
              pension: pensionId,
              statementDate: statementDate,
              planValue: planValue,
              projectedAnnualAmount: projectedAnnualAmount,
              yearlyCharges: yearlyCharges,
              transferValue: transferValue,
              statementNotes: statementNotes));
      when(databaseService.saveStatePension(statePensionAnnualAmount, otherIncomeNotes))
          .thenAnswer((_) async => OtherIncome(
              otherIncomeId: 1,
              name: 'State Pension',
              annualAmount: statePensionAnnualAmount,
              notes: otherIncomeNotes));

      MockSettingsService settingsService = MockSettingsService();
      when(settingsService.saveAllSettings(Settings(
              retirementDate: retirementDate,
              targetIncome: targetIncome,
              acceptTermsAndConditions: acceptTermsAndConditions,
              acceptFinancialAdviceWarning: acceptFinancialAdviceWarning,
              welcomeScreenDismissed: welcomeScreenDismissed,
              optIntoAnalyticsWarning: optIntoAnalyticsWarning)))
          .thenAnswer((_) async => {});

      // create the data to import
      TransferStatementModel transferStatement = TransferStatementModel(
          statementId: statementId,
          statementDate: statementDate,
          planValue: planValue,
          projectedAnnualAmount: projectedAnnualAmount,
          yearlyCharges: yearlyCharges,
          transferValue: transferValue, 
          amountPaidIn: amountPaidIn,
          notes: statementNotes);
      TransferPensionModel transferPension = TransferPensionModel(
          pensionId: pensionId,
          name: pensionName,
          maturityDate: maturityDate,
          notes: pensionNotes,
          statements: [transferStatement]);
      TransferOtherIncomeModel transferOtherIncome = TransferOtherIncomeModel(
          otherIncomeId: 1,
          name: 'State Pension',
          annualAmount: statePensionAnnualAmount,
          notes: otherIncomeNotes);
      TransferSettingsModel transferSettings = TransferSettingsModel(
          retirementDate: retirementDate,
          targetIncome: targetIncome,
          acceptTermsAndConditions: acceptTermsAndConditions,
          acceptFinancialAdviceWarning: acceptFinancialAdviceWarning,
          welcomeScreenDismissed: welcomeScreenDismissed,
          optIntoAnalyticsWarning: optIntoAnalyticsWarning);
      TransferDataModel dataModel = TransferDataModel(
        transferOtherIncomeModelList: [transferOtherIncome],
        transferPensionModelList: [transferPension],
        transferSettingsModel: transferSettings,
        backupConfigModel: BackupConfigModel(
          backupDate: DateTime.now(),
          backupVersion: "1",
        ),
      );

      JsonExportFileType jsonExportFileType = JsonExportFileType();
      MockFileHandler fileHandler = MockFileHandler();
      fileHandler.exportDataFiles = jsonExportFileType.export(dataModel);
      Exporter exporter = Exporter(
          databaseService: databaseService,
          settingsService: settingsService,
          exportFileType: JsonExportFileType(),
          fileHandler: fileHandler);

      await exporter.import();

      // // verify the data the File Handler was asked to save
      verify(databaseService.clearAllData()).called(1);
      verify(databaseService.createPension(pensionName, maturityDate, pensionNotes))
          .called(1);
      verify(databaseService.createStatement(pensionId, statementDate,
              planValue, projectedAnnualAmount, yearlyCharges, transferValue, amountPaidIn, statementNotes))
          .called(1);
      verify(databaseService.saveStatePension(statePensionAnnualAmount, otherIncomeNotes))
          .called(1);
      verify(settingsService.saveAllSettings(Settings(
              retirementDate: retirementDate,
              targetIncome: targetIncome,
              acceptTermsAndConditions: acceptTermsAndConditions,
              acceptFinancialAdviceWarning: acceptFinancialAdviceWarning,
              welcomeScreenDismissed: welcomeScreenDismissed,
              optIntoAnalyticsWarning: optIntoAnalyticsWarning)))
          .called(1);
    });
  });
}

class MockFileHandler extends Mock implements FileHandler {
  List<ExportDataModel> exportDataFiles = [];

  @override
  Future<void> saveFile(List<ExportDataModel> exportDataFiles) async {
    this.exportDataFiles = exportDataFiles;
  }

  @override
  Future<List<ExportDataModel>> loadFile(String? fileExtensionFilter) async {
    return exportDataFiles;
  }
}
