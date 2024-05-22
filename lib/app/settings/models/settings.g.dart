// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsImpl _$$SettingsImplFromJson(Map<String, dynamic> json) =>
    _$SettingsImpl(
      retirementDate: json['retirementDate'] == null
          ? null
          : DateTime.parse(json['retirementDate'] as String),
      targetIncome: (json['targetIncome'] as num?)?.toDouble(),
      acceptTermsAndConditions: json['acceptTermsAndConditions'] as bool?,
      acceptFinancialAdviceWarning:
          json['acceptFinancialAdviceWarning'] as bool?,
      welcomeScreenDismissed: json['welcomeScreenDismissed'] as bool?,
      optIntoAnalyticsWarning: json['optIntoAnalyticsWarning'] as bool,
    );

Map<String, dynamic> _$$SettingsImplToJson(_$SettingsImpl instance) =>
    <String, dynamic>{
      'retirementDate': instance.retirementDate?.toIso8601String(),
      'targetIncome': instance.targetIncome,
      'acceptTermsAndConditions': instance.acceptTermsAndConditions,
      'acceptFinancialAdviceWarning': instance.acceptFinancialAdviceWarning,
      'welcomeScreenDismissed': instance.welcomeScreenDismissed,
      'optIntoAnalyticsWarning': instance.optIntoAnalyticsWarning,
    };
