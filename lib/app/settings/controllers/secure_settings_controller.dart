import 'package:pension_compare/app/settings/models/secure_settings_model.dart';
import 'package:pension_compare/data/mapper/secure_settings_mapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pension_compare/data/database/database_service.dart';

part 'secure_settings_controller.g.dart';

@riverpod
class SecureSettingsController extends _$SecureSettingsController {
  late final DatabaseService _databaseService =
      ref.read(DatabaseService.provider);

  @override
  Stream<SecureSettingsModel> build() {
    return _databaseService
        .getSecureSettings()
        .map((s) => SecureSettingsMapper.mapToModel(s));
  }

  Future<SecureSettingsModel> saveSecureSettings(
      double? targetIncome, DateTime? retirementDate) async {
    SecureSettings newSettings =
        await _databaseService.saveSecureSettings(targetIncome, retirementDate);
    return SecureSettingsMapper.mapToModel(newSettings);
  }
}
