// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'other_income_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OtherIncomeModelImpl _$$OtherIncomeModelImplFromJson(
        Map<String, dynamic> json) =>
    _$OtherIncomeModelImpl(
      otherIncomeId: (json['otherIncomeId'] as num?)?.toInt(),
      name: json['name'] as String,
      annualAmount: (json['annualAmount'] as num).toDouble(),
    );

Map<String, dynamic> _$$OtherIncomeModelImplToJson(
        _$OtherIncomeModelImpl instance) =>
    <String, dynamic>{
      'otherIncomeId': instance.otherIncomeId,
      'name': instance.name,
      'annualAmount': instance.annualAmount,
    };
