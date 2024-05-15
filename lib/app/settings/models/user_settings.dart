import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

/// Settings the user can control
@freezed
class UserSettings with _$UserSettings {
  const factory UserSettings({
    required DateTime? retirementDate,
    required double? targetIncome,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, Object?> json) =>
      _$UserSettingsFromJson(json);
}
