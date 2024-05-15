// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_other_income_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferOtherIncomeModelImpl _$$TransferOtherIncomeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransferOtherIncomeModelImpl(
      otherIncomeId: (json['otherIncomeId'] as num).toInt(),
      name: json['name'] as String,
      annualAmount: (json['annualAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$$TransferOtherIncomeModelImplToJson(
        _$TransferOtherIncomeModelImpl instance) =>
    <String, dynamic>{
      'otherIncomeId': instance.otherIncomeId,
      'name': instance.name,
      'annualAmount': instance.annualAmount,
    };
