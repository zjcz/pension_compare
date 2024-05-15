// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSettingsImpl _$$UserSettingsImplFromJson(Map<String, dynamic> json) =>
    _$UserSettingsImpl(
      retirementDate: json['retirementDate'] == null
          ? null
          : DateTime.parse(json['retirementDate'] as String),
      targetIncome: (json['targetIncome'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'retirementDate': instance.retirementDate?.toIso8601String(),
      'targetIncome': instance.targetIncome,
    };
