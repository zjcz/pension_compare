// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_secure_settings_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferSecureSettingsModelImpl _$$TransferSecureSettingsModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransferSecureSettingsModelImpl(
      retirementDate: json['retirementDate'] == null
          ? null
          : DateTime.parse(json['retirementDate'] as String),
      targetIncome: (json['targetIncome'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TransferSecureSettingsModelImplToJson(
        _$TransferSecureSettingsModelImpl instance) =>
    <String, dynamic>{
      'retirementDate': instance.retirementDate?.toIso8601String(),
      'targetIncome': instance.targetIncome,
    };
