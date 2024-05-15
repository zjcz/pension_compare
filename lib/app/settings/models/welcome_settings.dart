import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'welcome_settings.freezed.dart';
part 'welcome_settings.g.dart';

/// Settings for the welcome screen.
@freezed
class WelcomeSettings with _$WelcomeSettings {
  const factory WelcomeSettings({
    required bool? acceptTermsAndConditions,
    required bool? acceptFinancialAdviceWarning,
    required bool? welcomeScreenDismissed,
  }) = _WelcomeSettings;

  factory WelcomeSettings.fromJson(Map<String, Object?> json) =>
      _$WelcomeSettingsFromJson(json);
}
