// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pension_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PensionModelImpl _$$PensionModelImplFromJson(Map<String, dynamic> json) =>
    _$PensionModelImpl(
      pensionId: (json['pensionId'] as num?)?.toInt(),
      name: json['name'] as String,
      maturityDate: json['maturityDate'] == null
          ? null
          : DateTime.parse(json['maturityDate'] as String),
      status: $enumDecode(_$PensionStatusEnumMap, json['status']),
      statusDate: DateTime.parse(json['statusDate'] as String),
    );

Map<String, dynamic> _$$PensionModelImplToJson(_$PensionModelImpl instance) =>
    <String, dynamic>{
      'pensionId': instance.pensionId,
      'name': instance.name,
      'maturityDate': instance.maturityDate?.toIso8601String(),
      'status': _$PensionStatusEnumMap[instance.status]!,
      'statusDate': instance.statusDate.toIso8601String(),
    };

const _$PensionStatusEnumMap = {
  PensionStatus.active: 'active',
  PensionStatus.closed: 'closed',
  PensionStatus.transferred: 'transferred',
  PensionStatus.matured: 'matured',
};
