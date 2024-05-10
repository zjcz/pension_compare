// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backup_config_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BackupConfigModelImpl _$$BackupConfigModelImplFromJson(
        Map<String, dynamic> json) =>
    _$BackupConfigModelImpl(
      backupDate: DateTime.parse(json['backupDate'] as String),
      backupVersion: json['backupVersion'] as String,
    );

Map<String, dynamic> _$$BackupConfigModelImplToJson(
        _$BackupConfigModelImpl instance) =>
    <String, dynamic>{
      'backupDate': instance.backupDate.toIso8601String(),
      'backupVersion': instance.backupVersion,
    };
