import 'package:pension_compare/app/settings/models/settings.dart';
import 'package:pension_compare/data/import_export/models/transfer_settings_model.dart';

class SettingsMapper {
  static TransferSettingsModel toTransfer(Settings settings) {
    return TransferSettingsModel(
      retirementDate: settings.retirementDate,
      targetIncome: settings.targetIncome,
      acceptTermsAndConditions: settings.acceptTermsAndConditions,
      acceptFinancialAdviceWarning: settings.acceptFinancialAdviceWarning,
      welcomeScreenDismissed: settings.welcomeScreenDismissed,
    );
  }

  static Settings fromTransfer(TransferSettingsModel settings) {
    return Settings(
      retirementDate: settings.retirementDate,
      targetIncome: settings.targetIncome,
      acceptTermsAndConditions: settings.acceptTermsAndConditions,
      acceptFinancialAdviceWarning: settings.acceptFinancialAdviceWarning,
      welcomeScreenDismissed: settings.welcomeScreenDismissed,
    );
  }
}
