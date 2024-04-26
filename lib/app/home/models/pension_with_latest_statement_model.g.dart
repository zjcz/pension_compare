// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pension_with_latest_statement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PensionWithLatestStatementModelImpl
    _$$PensionWithLatestStatementModelImplFromJson(Map<String, dynamic> json) =>
        _$PensionWithLatestStatementModelImpl(
          pension:
              PensionModel.fromJson(json['pension'] as Map<String, dynamic>),
          latestStatement: json['latestStatement'] == null
              ? null
              : StatementModel.fromJson(
                  json['latestStatement'] as Map<String, dynamic>),
        );

Map<String, dynamic> _$$PensionWithLatestStatementModelImplToJson(
        _$PensionWithLatestStatementModelImpl instance) =>
    <String, dynamic>{
      'pension': instance.pension,
      'latestStatement': instance.latestStatement,
    };
