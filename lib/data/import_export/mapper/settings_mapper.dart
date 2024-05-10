import 'package:pension_compare/app/settings/settings.dart';
import 'package:pension_compare/data/import_export/models/transfer_settings_model.dart';

class SettingsMapper {
  static TransferSettingsModel toTransfer(Settings settings) {
    return TransferSettingsModel(
      retirementDate: settings.retirementDate,
      targetIncome: settings.targetIncome,
    );
  }

  static Settings fromTransfer(TransferSettingsModel settings) {
    return Settings(
      retirementDate: settings.retirementDate,
      targetIncome: settings.targetIncome,
    );
  }
}
