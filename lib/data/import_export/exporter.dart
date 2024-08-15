import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/app/settings/controllers/settings_service.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/data/import_export/file_formatter/export_file_type.dart';
import 'package:pension_compare/data/import_export/file_handler/file_handler.dart';
import 'package:pension_compare/data/import_export/mapper/other_income_mapper.dart';
import 'package:pension_compare/data/import_export/mapper/pension_mapper.dart';
import 'package:pension_compare/data/import_export/mapper/settings_mapper.dart';
import 'package:pension_compare/data/import_export/models/backup_config_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_other_income_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_pension_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_secure_settings_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_settings_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_statement_model.dart';
import 'package:pension_compare/data/import_export/mapper/secure_settings_mapper.dart';

/// Export and import the data from the database using the ExportFileType and FileHandler supplied.
class Exporter {
  static const String backupVersionNumber = '1';

  final DatabaseService databaseService;
  final SettingsService settingsService;
  final ExportFileType exportFileType;
  final FileHandler fileHandler;

  Exporter({
    required this.databaseService,
    required this.settingsService,
    required this.exportFileType,
    required this.fileHandler,
  });

  Future<void> export() async {
    // 1. Convert the data to transfer data models
    TransferDataModel exportDataModel = await _buildExport();

    // 2. Build the export files
    List<ExportDataModel> exportDataFiles =
        exportFileType.export(exportDataModel);

    // 3. Save the export files
    await fileHandler.saveFile(exportDataFiles);
  }

  Future<void> import() async {
    // 1. Load the file
    List<ExportDataModel> exportDataFiles =
        await fileHandler.loadFile(exportFileType.fileExtension);

    // 2. Build the parse the data files
    TransferDataModel importDataModel = exportFileType.import(exportDataFiles);

    // 3. Import the data files into the database
    await _importData(importDataModel);
  }

  /// Convert the database to transfer data models
  Future<TransferDataModel> _buildExport() async {
    OtherIncome? otherIncome = await databaseService.getStatePension();
    List<Pension> pensions = await databaseService.getAllPensions().first;
    Settings settings = await settingsService.getAllSettings();
    SecureSettings secureSettings =
        await databaseService.getSecureSettings().first;

    List<TransferPensionModel> transferPensions = [];
    for (Pension pension in pensions) {
      List<Statement> statements = await databaseService
          .getAllStatementsForPension(pension.pensionId)
          .first;
      TransferPensionModel transferPension =
          PensionMapper.toTransfer(pension, statements);
      transferPensions.add(transferPension);
    }

    TransferDataModel dataModel = TransferDataModel(
      transferOtherIncomeModelList: otherIncome == null
          ? []
          : [OtherIncomeMapper.toTransfer(otherIncome)],
      transferPensionModelList: transferPensions,
      transferSettingsModel: SettingsMapper.toTransfer(settings),
      transferSecureSettingsModel:
          SecureSettingsMapper.toTransfer(secureSettings),
      backupConfigModel: BackupConfigModel(
        backupDate: DateTime.now(),
        backupVersion: backupVersionNumber,
      ),
    );
    return dataModel;
  }

  /// Clear the database and import the data model
  Future<void> _importData(TransferDataModel dataModel) async {
    await databaseService.clearAllData();

    for (TransferPensionModel pension in dataModel.transferPensionModelList) {
      Pension? p = await databaseService.createPension(
          pension.name, pension.maturityDate, pension.notes);
      if (p != null && pension.statements.isNotEmpty) {
        for (TransferStatementModel statement in pension.statements) {
          await databaseService.createStatement(
              p.pensionId,
              statement.statementDate,
              statement.planValue,
              statement.projectedAnnualAmount,
              statement.yearlyCharges,
              statement.transferValue,
              statement.amountPaidIn,
              statement.notes);
        }
      }
    }

    await databaseService.saveStatePension(
        dataModel.transferOtherIncomeModelList.first.annualAmount,
        dataModel.transferOtherIncomeModelList.first.notes);

    await databaseService.saveSecureSettings(
        dataModel.transferSecureSettingsModel.targetIncome,
        dataModel.transferSecureSettingsModel.retirementDate);

    await settingsService.saveAllSettings(Settings(
      acceptTermsAndConditions:
          dataModel.transferSettingsModel.acceptTermsAndConditions,
      acceptFinancialAdviceWarning:
          dataModel.transferSettingsModel.acceptFinancialAdviceWarning,
      welcomeScreenDismissed:
          dataModel.transferSettingsModel.welcomeScreenDismissed,
      optIntoAnalyticsWarning:
          dataModel.transferSettingsModel.optIntoAnalyticsWarning,
    ));
  }
}

/// This data model contains the data from the application that will be exported
class TransferDataModel {
  final List<TransferOtherIncomeModel> transferOtherIncomeModelList;
  final List<TransferPensionModel> transferPensionModelList;
  final TransferSettingsModel transferSettingsModel;
  final TransferSecureSettingsModel transferSecureSettingsModel;
  final BackupConfigModel backupConfigModel;

  TransferDataModel({
    required this.transferOtherIncomeModelList,
    required this.transferPensionModelList,
    required this.transferSettingsModel,
    required this.transferSecureSettingsModel,
    required this.backupConfigModel,
  });
}

class ExportDataModel {
  final String filename;
  final String fileContents;

  ExportDataModel({
    required this.filename,
    required this.fileContents,
  });
}
