// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'secure_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SecureSettingsModelImpl _$$SecureSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SecureSettingsModelImpl(
      targetIncome: (json['targetIncome'] as num?)?.toDouble(),
      retirementDate: json['retirementDate'] == null
          ? null
          : DateTime.parse(json['retirementDate'] as String),
    );

Map<String, dynamic> _$$SecureSettingsModelImplToJson(
        _$SecureSettingsModelImpl instance) =>
    <String, dynamic>{
      'targetIncome': instance.targetIncome,
      'retirementDate': instance.retirementDate?.toIso8601String(),
    };
