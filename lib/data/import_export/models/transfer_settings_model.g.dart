// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferSettingsModelImpl _$$TransferSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransferSettingsModelImpl(
      acceptTermsAndConditions: json['acceptTermsAndConditions'] as bool?,
      acceptFinancialAdviceWarning:
          json['acceptFinancialAdviceWarning'] as bool?,
      welcomeScreenDismissed: json['welcomeScreenDismissed'] as bool?,
      optIntoAnalyticsWarning: json['optIntoAnalyticsWarning'] as bool,
    );

Map<String, dynamic> _$$TransferSettingsModelImplToJson(
        _$TransferSettingsModelImpl instance) =>
    <String, dynamic>{
      'acceptTermsAndConditions': instance.acceptTermsAndConditions,
      'acceptFinancialAdviceWarning': instance.acceptFinancialAdviceWarning,
      'welcomeScreenDismissed': instance.welcomeScreenDismissed,
      'optIntoAnalyticsWarning': instance.optIntoAnalyticsWarning,
    };
