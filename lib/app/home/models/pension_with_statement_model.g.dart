// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pension_with_statement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PensionWithStatementModelImpl _$$PensionWithStatementModelImplFromJson(
        Map<String, dynamic> json) =>
    _$PensionWithStatementModelImpl(
      pension: PensionModel.fromJson(json['pension'] as Map<String, dynamic>),
      statement: json['statement'] == null
          ? null
          : StatementModel.fromJson(json['statement'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PensionWithStatementModelImplToJson(
        _$PensionWithStatementModelImpl instance) =>
    <String, dynamic>{
      'pension': instance.pension,
      'statement': instance.statement,
    };
