// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pension_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PensionModelImpl _$$PensionModelImplFromJson(Map<String, dynamic> json) =>
    _$PensionModelImpl(
      pensionId: json['pensionId'] as int?,
      name: json['name'] as String,
      maturityDate: json['maturityDate'] == null
          ? null
          : DateTime.parse(json['maturityDate'] as String),
    );

Map<String, dynamic> _$$PensionModelImplToJson(_$PensionModelImpl instance) =>
    <String, dynamic>{
      'pensionId': instance.pensionId,
      'name': instance.name,
      'maturityDate': instance.maturityDate?.toIso8601String(),
    };
