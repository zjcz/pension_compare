// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsImpl _$$SettingsImplFromJson(Map<String, dynamic> json) =>
    _$SettingsImpl(
      dateOfBirth: json['dateOfBirth'] == null
          ? null
          : DateTime.parse(json['dateOfBirth'] as String),
      plannedRetirementAge: json['plannedRetirementAge'] as int?,
      targetIncome: (json['targetIncome'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$SettingsImplToJson(_$SettingsImpl instance) =>
    <String, dynamic>{
      'dateOfBirth': instance.dateOfBirth?.toIso8601String(),
      'plannedRetirementAge': instance.plannedRetirementAge,
      'targetIncome': instance.targetIncome,
    };
