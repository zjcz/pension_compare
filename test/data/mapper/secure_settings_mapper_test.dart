import 'package:pension_compare/app/settings/models/secure_settings_model.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pension_compare/constants/defaults.dart' as defaults;
import 'package:pension_compare/data/mapper/secure_settings_mapper.dart';

void main() {
  group('Test secure settings mapper', () {
    testWidgets('map single object', (tester) async {            
      double targetAmount = 123.45;
      DateTime retirementDate = DateTime(2022, 12, 31);
      SecureSettings secureSettings = SecureSettings(secureSettingsId: defaults.defaultSecureSettingsId,
          targetIncome: targetAmount, retirementDate: retirementDate);

      SecureSettingsModel secureSettingsModel = SecureSettingsMapper.mapToModel(secureSettings);

      expect(secureSettingsModel, isNotNull);
      expect(secureSettingsModel.targetIncome, targetAmount);
      expect(secureSettingsModel.retirementDate, retirementDate);
    });
  });
}
