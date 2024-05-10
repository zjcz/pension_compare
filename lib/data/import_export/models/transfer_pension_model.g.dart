// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_pension_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TransferPensionModelImpl _$$TransferPensionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransferPensionModelImpl(
      pensionId: json['pensionId'] as int,
      name: json['name'] as String,
      maturityDate: DateTime.parse(json['maturityDate'] as String),
      statements: (json['statements'] as List<dynamic>)
          .map(
              (e) => TransferStatementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$TransferPensionModelImplToJson(
        _$TransferPensionModelImpl instance) =>
    <String, dynamic>{
      'pensionId': instance.pensionId,
      'name': instance.name,
      'maturityDate': instance.maturityDate.toIso8601String(),
      'statements': instance.statements,
    };
