// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferSettingsModelImpl _$$TransferSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransferSettingsModelImpl(
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

Map<String, dynamic> _$$TransferSettingsModelImplToJson(
        _$TransferSettingsModelImpl instance) =>
    <String, dynamic>{
      'retirementDate': instance.retirementDate?.toIso8601String(),
      'targetIncome': instance.targetIncome,
      'acceptTermsAndConditions': instance.acceptTermsAndConditions,
      'acceptFinancialAdviceWarning': instance.acceptFinancialAdviceWarning,
      'welcomeScreenDismissed': instance.welcomeScreenDismissed,
      'optIntoAnalyticsWarning': instance.optIntoAnalyticsWarning,
    };
