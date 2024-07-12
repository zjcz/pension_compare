// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_pension_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferPensionModelImpl _$$TransferPensionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransferPensionModelImpl(
      pensionId: (json['pensionId'] as num).toInt(),
      name: json['name'] as String,
      maturityDate: DateTime.parse(json['maturityDate'] as String),
      status: $enumDecode(_$PensionStatusEnumMap, json['status']),
      statusDate: DateTime.parse(json['statusDate'] as String),
      statements: (json['statements'] as List<dynamic>)
          .map(
              (e) => TransferStatementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      notes: json['notes'] as String?,
    );

Map<String, dynamic> _$$TransferPensionModelImplToJson(
        _$TransferPensionModelImpl instance) =>
    <String, dynamic>{
      'pensionId': instance.pensionId,
      'name': instance.name,
      'maturityDate': instance.maturityDate.toIso8601String(),
      'status': _$PensionStatusEnumMap[instance.status]!,
      'statusDate': instance.statusDate.toIso8601String(),
      'statements': instance.statements,
      'notes': instance.notes,
    };

const _$PensionStatusEnumMap = {
  PensionStatus.active: 'active',
  PensionStatus.closed: 'closed',
  PensionStatus.transferred: 'transferred',
  PensionStatus.matured: 'matured',
};
