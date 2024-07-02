// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_statement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferStatementModelImpl _$$TransferStatementModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransferStatementModelImpl(
      statementId: (json['statementId'] as num).toInt(),
      statementDate: DateTime.parse(json['statementDate'] as String),
      planValue: (json['planValue'] as num).toDouble(),
      projectedAnnualAmount: (json['projectedAnnualAmount'] as num).toDouble(),
      yearlyCharges: (json['yearlyCharges'] as num?)?.toDouble(),
      transferValue: (json['transferValue'] as num?)?.toDouble(),
      amountPaidIn: (json['amountPaidIn'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TransferStatementModelImplToJson(
        _$TransferStatementModelImpl instance) =>
    <String, dynamic>{
      'statementId': instance.statementId,
      'statementDate': instance.statementDate.toIso8601String(),
      'planValue': instance.planValue,
      'projectedAnnualAmount': instance.projectedAnnualAmount,
      'yearlyCharges': instance.yearlyCharges,
      'transferValue': instance.transferValue,
      'amountPaidIn': instance.amountPaidIn,
    };
