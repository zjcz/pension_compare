import 'package:pension_compare/app/settings/settings.dart';
import 'package:pension_compare/app/settings/settings_service.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/data/import_export/file_formatter/export_file_type.dart';
import 'package:pension_compare/data/import_export/file_handler/file_handler.dart';
import 'package:pension_compare/data/import_export/mapper/other_income_mapper.dart';
import 'package:pension_compare/data/import_export/mapper/pension_mapper.dart';
import 'package:pension_compare/data/import_export/mapper/settings_mapper.dart';
import 'package:pension_compare/data/import_export/models/transfer_other_income_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_pension_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_settings_model.dart';

class Exporter {
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
    fileHandler.saveFile(exportDataFiles);
  }

  /// Convert the database to transfer data models
  Future<TransferDataModel> _buildExport() async {
    OtherIncome? otherIncome = await databaseService.getStatePension();
    List<Pension> pensions = await databaseService.getAllPensions().first;
    Settings settings = await settingsService.getSettings();

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
    );

    return dataModel;
  }

  // static TransferDataModel buildImport() {
  //   if (dataModel.length != 3) {
  //     throw Exception('Invalid data model');
  //   }
  // }
}

/// This data model contains the data from the application that will be exported
class TransferDataModel {
  final List<TransferOtherIncomeModel> transferOtherIncomeModelList;
  final List<TransferPensionModel> transferPensionModelList;
  final TransferSettingsModel transferSettingsModel;

  TransferDataModel({
    required this.transferOtherIncomeModelList,
    required this.transferPensionModelList,
    required this.transferSettingsModel,
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
