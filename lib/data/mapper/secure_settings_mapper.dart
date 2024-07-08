import 'package:pension_compare/app/settings/models/secure_settings_model.dart';
import 'package:pension_compare/data/database/database_service.dart';

class SecureSettingsMapper {
  static SecureSettingsModel mapToModel(SecureSettings secureSettings) {
    return SecureSettingsModel(
      targetIncome: secureSettings.targetIncome,
      retirementDate: secureSettings.retirementDate,
    );
  }
}
