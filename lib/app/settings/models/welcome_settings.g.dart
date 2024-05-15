// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'welcome_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WelcomeSettingsImpl _$$WelcomeSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$WelcomeSettingsImpl(
      acceptTermsAndConditions: json['acceptTermsAndConditions'] as bool?,
      acceptFinancialAdviceWarning:
          json['acceptFinancialAdviceWarning'] as bool?,
      welcomeScreenDismissed: json['welcomeScreenDismissed'] as bool?,
    );

Map<String, dynamic> _$$WelcomeSettingsImplToJson(
        _$WelcomeSettingsImpl instance) =>
    <String, dynamic>{
      'acceptTermsAndConditions': instance.acceptTermsAndConditions,
      'acceptFinancialAdviceWarning': instance.acceptFinancialAdviceWarning,
      'welcomeScreenDismissed': instance.welcomeScreenDismissed,
    };
