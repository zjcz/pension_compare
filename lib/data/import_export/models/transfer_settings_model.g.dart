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
    );

Map<String, dynamic> _$$TransferSettingsModelImplToJson(
        _$TransferSettingsModelImpl instance) =>
    <String, dynamic>{
      'retirementDate': instance.retirementDate?.toIso8601String(),
      'targetIncome': instance.targetIncome,
    };
