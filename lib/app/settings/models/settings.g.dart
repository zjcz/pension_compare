// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsImpl _$$SettingsImplFromJson(Map<String, dynamic> json) =>
    _$SettingsImpl(
      acceptTermsAndConditions: json['acceptTermsAndConditions'] as bool?,
      acceptFinancialAdviceWarning:
          json['acceptFinancialAdviceWarning'] as bool?,
      welcomeScreenDismissed: json['welcomeScreenDismissed'] as bool?,
      optIntoAnalyticsWarning: json['optIntoAnalyticsWarning'] as bool,
    );

Map<String, dynamic> _$$SettingsImplToJson(_$SettingsImpl instance) =>
    <String, dynamic>{
      'acceptTermsAndConditions': instance.acceptTermsAndConditions,
      'acceptFinancialAdviceWarning': instance.acceptFinancialAdviceWarning,
      'welcomeScreenDismissed': instance.welcomeScreenDismissed,
      'optIntoAnalyticsWarning': instance.optIntoAnalyticsWarning,
    };
