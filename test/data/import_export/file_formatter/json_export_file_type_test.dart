import 'dart:convert';
import 'package:pension_compare/data/import_export/exporter.dart';
import 'package:pension_compare/data/import_export/file_formatter/json_export_file_type.dart';
import 'package:pension_compare/data/import_export/models/backup_config_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_other_income_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pension_compare/data/import_export/models/transfer_pension_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_secure_settings_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_settings_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_statement_model.dart';

void main() {
  group('Test export to json and back', () {
    testWidgets('export data to json data files', (tester) async {
      TransferOtherIncomeModel otherIncome = buildOtherIncomeModel();
      TransferPensionModel pension = buildPensionModel();
      TransferSettingsModel settings = buildSettingsModel();
      TransferSecureSettingsModel secureSettings = buildSecureSettingsModel();
      BackupConfigModel backupConfig =
          BackupConfigModel(backupDate: DateTime.now(), backupVersion: '1');

      TransferDataModel dataModel = TransferDataModel(
          transferOtherIncomeModelList: [otherIncome],
          transferPensionModelList: [pension],
          transferSettingsModel: settings,
          transferSecureSettingsModel: secureSettings,
          backupConfigModel: backupConfig);

      JsonExportFileType jsonExportFileType = JsonExportFileType();
      List<ExportDataModel> exportDataModel =
          jsonExportFileType.export(dataModel);

      // Step 1: Check if the export data model is not null and has the correct length
      expect(exportDataModel, isNotNull);
      expect(exportDataModel.length, 5);
      expect(exportDataModel[0].filename, 'pension_data.json');
      expect(exportDataModel[0].fileContents, isNotEmpty);
      expect(exportDataModel[1].filename, 'other_income_data.json');
      expect(exportDataModel[1].fileContents, isNotEmpty);
      expect(exportDataModel[2].filename, 'settings_data.json');
      expect(exportDataModel[2].fileContents, isNotEmpty);
      expect(exportDataModel[3].filename, 'sec_settings_data.json');
      expect(exportDataModel[3].fileContents, isNotEmpty);
      expect(exportDataModel[4].filename, 'backup_config.json');
      expect(exportDataModel[4].fileContents, isNotEmpty);

      // Step 2: Parse the JSON string back to an object
      List<dynamic> jsonPensionList =
          jsonDecode(exportDataModel[0].fileContents);
      List<TransferPensionModel> parsedPensions = jsonPensionList
          .map((item) => TransferPensionModel.fromJson(item))
          .toList();
      List<dynamic> jsonOtherIncomeList =
          jsonDecode(exportDataModel[1].fileContents);
      List<TransferOtherIncomeModel> parsedOtherIncomes = jsonOtherIncomeList
          .map((item) => TransferOtherIncomeModel.fromJson(item))
          .toList();
      TransferSettingsModel parsedSettings = TransferSettingsModel.fromJson(
          jsonDecode(exportDataModel[2].fileContents));
      TransferSecureSettingsModel parsedSecureSettings =
          TransferSecureSettingsModel.fromJson(
              jsonDecode(exportDataModel[3].fileContents));
      BackupConfigModel parsedbackupConfig = BackupConfigModel.fromJson(
          jsonDecode(exportDataModel[4].fileContents));

      // Step 3: Compare the original object with the parsed object
      expect(parsedOtherIncomes[0], equals(otherIncome));
      expect(parsedPensions[0], equals(pension));
      expect(parsedSettings, equals(settings));
      expect(parsedSecureSettings, equals(secureSettings));
      expect(parsedbackupConfig, equals(backupConfig));
    });

    testWidgets('import data to json data files', (tester) async {
      TransferOtherIncomeModel otherIncome = buildOtherIncomeModel();
      TransferPensionModel pension = buildPensionModel();
      TransferSettingsModel settings = buildSettingsModel();
      TransferSecureSettingsModel secureSettings = buildSecureSettingsModel();
      BackupConfigModel backupConfig =
          BackupConfigModel(backupDate: DateTime.now(), backupVersion: '1');

      TransferDataModel dataModel = TransferDataModel(
        transferOtherIncomeModelList: [otherIncome],
        transferPensionModelList: [pension],
        transferSettingsModel: settings,
        transferSecureSettingsModel: secureSettings,
        backupConfigModel: backupConfig,
      );

      JsonExportFileType jsonExportFileType = JsonExportFileType();
      List<ExportDataModel> exportDataModel =
          jsonExportFileType.export(dataModel);

      // Now reimport the data
      TransferDataModel importedDataModel =
          jsonExportFileType.import(exportDataModel);

      expect(importedDataModel, isNotNull);
      expect(importedDataModel.transferOtherIncomeModelList,
          equals(dataModel.transferOtherIncomeModelList));
      expect(importedDataModel.transferPensionModelList,
          equals(dataModel.transferPensionModelList));
      expect(importedDataModel.transferSettingsModel,
          equals(dataModel.transferSettingsModel));
      expect(importedDataModel.transferSecureSettingsModel,
          equals(dataModel.transferSecureSettingsModel));
      expect(importedDataModel.backupConfigModel,
          equals(dataModel.backupConfigModel));
    });
  });

  group('Test invalid imports', () {
    testWidgets('import empty data model', (tester) async {
      JsonExportFileType jsonExportFileType = JsonExportFileType();
      List<ExportDataModel> exportDataModel = [];

      // Now reimport the data
      final result = (() => jsonExportFileType.import(exportDataModel));

      expect(result, throwsException);
    });

    testWidgets('import invalid files in data model', (tester) async {
      JsonExportFileType jsonExportFileType = JsonExportFileType();
      List<ExportDataModel> exportDataModel = [
        ExportDataModel(
            filename: jsonExportFileType.otherIncomeExportFilename,
            fileContents: ''),
        ExportDataModel(
            filename: jsonExportFileType.settingsExportFilename,
            fileContents: ''),
        ExportDataModel(
            filename: jsonExportFileType.pensionExportFilename,
            fileContents: '')
      ]; // only includes 3 files, expecting 4

      // Now reimport the data
      final result = (() => jsonExportFileType.import(exportDataModel));

      expect(result, throwsException);
    });

    testWidgets('import file with missing pension data in data model',
        (tester) async {
      JsonExportFileType jsonExportFileType = JsonExportFileType();
      List<ExportDataModel> exportDataModel = [
        ExportDataModel(
            filename: jsonExportFileType.otherIncomeExportFilename,
            fileContents: ''),
        ExportDataModel(
            filename: jsonExportFileType.settingsExportFilename,
            fileContents: ''),
        ExportDataModel(
            filename: jsonExportFileType.backupConfigExportFilename,
            fileContents: ''),
        ExportDataModel(filename: 'random_file.json', fileContents: '')
      ];

      // Now reimport the data
      final result = (() => jsonExportFileType.import(exportDataModel));

      expect(result, throwsException);
    });

    testWidgets('import file with missing other income data in data model',
        (tester) async {
      JsonExportFileType jsonExportFileType = JsonExportFileType();
      List<ExportDataModel> exportDataModel = [
        ExportDataModel(
            filename: jsonExportFileType.pensionExportFilename,
            fileContents: ''),
        ExportDataModel(
            filename: jsonExportFileType.settingsExportFilename,
            fileContents: ''),
        ExportDataModel(
            filename: jsonExportFileType.backupConfigExportFilename,
            fileContents: ''),
        ExportDataModel(filename: 'random_file.json', fileContents: '')
      ];

      // Now reimport the data
      final result = (() => jsonExportFileType.import(exportDataModel));

      expect(result, throwsException);
    });
    testWidgets('import file with missing settings data in data model',
        (tester) async {
      JsonExportFileType jsonExportFileType = JsonExportFileType();
      List<ExportDataModel> exportDataModel = [
        ExportDataModel(
            filename: jsonExportFileType.otherIncomeExportFilename,
            fileContents: ''),
        ExportDataModel(
            filename: jsonExportFileType.pensionExportFilename,
            fileContents: ''),
        ExportDataModel(
            filename: jsonExportFileType.backupConfigExportFilename,
            fileContents: ''),
        ExportDataModel(filename: 'random_file.json', fileContents: '')
      ];

      // Now reimport the data
      final result = (() => jsonExportFileType.import(exportDataModel));

      expect(result, throwsException);
    });

    testWidgets('import file with missing backup config data in data model',
        (tester) async {
      JsonExportFileType jsonExportFileType = JsonExportFileType();
      List<ExportDataModel> exportDataModel = [
        ExportDataModel(
            filename: jsonExportFileType.otherIncomeExportFilename,
            fileContents: ''),
        ExportDataModel(
            filename: jsonExportFileType.pensionExportFilename,
            fileContents: ''),
        ExportDataModel(
            filename: jsonExportFileType.settingsExportFilename,
            fileContents: ''),
        ExportDataModel(filename: 'random_file.json', fileContents: '')
      ];

      // Now reimport the data
      final result = (() => jsonExportFileType.import(exportDataModel));

      expect(result, throwsException);
    });
  });
}

TransferOtherIncomeModel buildOtherIncomeModel() {
  int otherIncomeId = 5;
  String name = 'new income';
  double amount = 123.45;
  TransferOtherIncomeModel otherIncome = TransferOtherIncomeModel(
      otherIncomeId: otherIncomeId, name: name, annualAmount: amount);

  return otherIncome;
}

TransferPensionModel buildPensionModel() {
  int pensionId = 5;
  String pensionName = 'new pension';
  DateTime maturityDate = DateTime(2050, 1, 1);
  int statementId = 5;
  DateTime statementDate = DateTime(2024, 1, 1);
  double planValue = 123.45;
  double projectedAnnualAmount = 678.90;
  double yearlyCharges = 987.65;
  double transferValue = 432.10;
  double amountPaidIn = 1928.37;

  TransferStatementModel transferStatement = TransferStatementModel(
      statementId: statementId,
      statementDate: statementDate,
      planValue: planValue,
      projectedAnnualAmount: projectedAnnualAmount,
      yearlyCharges: yearlyCharges,
      transferValue: transferValue,
      amountPaidIn: amountPaidIn);
  TransferPensionModel transferPension = TransferPensionModel(
      pensionId: pensionId,
      name: pensionName,
      maturityDate: maturityDate,
      statements: [transferStatement]);

  return transferPension;
}

TransferSettingsModel buildSettingsModel() {
  bool acceptTermsAndConditions = true;
  bool acceptFinancialAdviceWarning = true;
  bool welcomeScreenDismissed = true;
  bool optIntoAnalyticsWarning = true;

  TransferSettingsModel settings = TransferSettingsModel(
      acceptTermsAndConditions: acceptTermsAndConditions,
      acceptFinancialAdviceWarning: acceptFinancialAdviceWarning,
      welcomeScreenDismissed: welcomeScreenDismissed,
      optIntoAnalyticsWarning: optIntoAnalyticsWarning);

  return settings;
}

TransferSecureSettingsModel buildSecureSettingsModel() {
  DateTime retirementDate = DateTime(2000, 1, 1);
  double targetIncome = 123.45;

  TransferSecureSettingsModel settings = TransferSecureSettingsModel(
      retirementDate: retirementDate, targetIncome: targetIncome);
  return settings;
}
