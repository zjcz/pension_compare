// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StatementModelImpl _$$StatementModelImplFromJson(Map<String, dynamic> json) =>
    _$StatementModelImpl(
      statementId: json['statementId'] as int?,
      pension: json['pension'] as int,
      statementDate: DateTime.parse(json['statementDate'] as String),
      planValue: (json['planValue'] as num).toDouble(),
      projectedAnnualAmount: (json['projectedAnnualAmount'] as num).toDouble(),
      yearlyCharges: (json['yearlyCharges'] as num?)?.toDouble(),
      transferValue: (json['transferValue'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$StatementModelImplToJson(
        _$StatementModelImpl instance) =>
    <String, dynamic>{
      'statementId': instance.statementId,
      'pension': instance.pension,
      'statementDate': instance.statementDate.toIso8601String(),
      'planValue': instance.planValue,
      'projectedAnnualAmount': instance.projectedAnnualAmount,
      'yearlyCharges': instance.yearlyCharges,
      'transferValue': instance.transferValue,
    };
