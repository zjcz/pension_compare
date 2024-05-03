import 'package:pension_compare/data/import_export/exporter.dart';

/// abstract class responsible for importing / exporting the data in a specific file format
/// can be used for backup/restore in json format, or export / import from excel, etc.
abstract class ExportFileType {
  String get fileExtension;
  String get pensionExportFilename => 'pension_data.$fileExtension';
  String get otherIncomeExportFilename => 'other_income_data.$fileExtension';
  String get settingsExportFilename => 'settings_data.$fileExtension';

  List<ExportDataModel> export(TransferDataModel dataModel);
  TransferDataModel import(List<ExportDataModel> dataModel);
}
