import 'dart:convert';

import 'package:pension_compare/data/import_export/exporter.dart';
import 'package:pension_compare/data/import_export/file_formatter/export_file_type.dart';
import 'package:pension_compare/data/import_export/models/transfer_other_income_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_pension_model.dart';
import 'package:pension_compare/data/import_export/models/transfer_settings_model.dart';

/// Handle the import / export of the data in the json file format
class JsonExportFileType extends ExportFileType {
  @override
  String get fileExtension => 'json';

  @override
  List<ExportDataModel> export(TransferDataModel dataModel) {
    List<ExportDataModel> exportDataModel = [];

    // first export the pension data
    String pensionData = jsonEncode(dataModel.transferPensionModelList
        .map((item) => item.toJson())
        .toList());

    exportDataModel.add(ExportDataModel(
      filename: pensionExportFilename,
      fileContents: pensionData,
    ));

    // then export the other income data
    String otherIncomeData = jsonEncode(dataModel.transferOtherIncomeModelList
        .map((item) => item.toJson())
        .toList());
    exportDataModel.add(ExportDataModel(
      filename: otherIncomeExportFilename,
      fileContents: otherIncomeData,
    ));

    // finally export the settings data
    String settingsData = jsonEncode(dataModel.transferSettingsModel.toJson());
    exportDataModel.add(ExportDataModel(
      filename: settingsExportFilename,
      fileContents: settingsData,
    ));

    return exportDataModel;
  }


  @override
  TransferDataModel import(List<ExportDataModel> dataModel) {
    List<TransferPensionModel> pensionList = [];
    List<TransferOtherIncomeModel> otherIncomeList = [];
    late TransferSettingsModel settings;
    
    for (ExportDataModel item in dataModel) {
      if (item.filename == pensionExportFilename) {
        List<dynamic> jsonPensionList = jsonDecode(item.fileContents);
        pensionList = jsonPensionList
            .map((item) => TransferPensionModel.fromJson(item))
            .toList();
      } else if (item.filename == otherIncomeExportFilename) {
        List<dynamic> jsonOtherIncomeList = jsonDecode(item.fileContents);
        otherIncomeList = jsonOtherIncomeList
            .map((item) => TransferOtherIncomeModel.fromJson(item))
            .toList();
      } else if (item.filename == settingsExportFilename) {
        settings = TransferSettingsModel.fromJson(jsonDecode(item.fileContents));
      }
    }

    return TransferDataModel(
      transferOtherIncomeModelList: otherIncomeList,
      transferPensionModelList: pensionList,
      transferSettingsModel: settings,
    );
  }
}
