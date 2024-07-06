import 'package:pension_compare/constants/defaults.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/data/import_export/models/transfer_secure_settings_model.dart';

class SecureSettingsMapper {
  static TransferSecureSettingsModel toTransfer(SecureSettings settings) {
    return TransferSecureSettingsModel(
      retirementDate: settings.retirementDate,
      targetIncome: settings.targetIncome,
    );
  }

  static SecureSettings fromTransfer(TransferSecureSettingsModel settings) {
    return SecureSettings(
      secureSettingsId: defaultSecureSettingsId,
      retirementDate: settings.retirementDate,
      targetIncome: settings.targetIncome,
    );
  }
}
