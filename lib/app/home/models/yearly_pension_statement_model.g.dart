// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'yearly_pension_statement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$YearlyPensionStatementModelImpl _$$YearlyPensionStatementModelImplFromJson(
        Map<String, dynamic> json) =>
    _$YearlyPensionStatementModelImpl(
      year: (json['year'] as num).toInt(),
      pensionWithStatement: (json['pensionWithStatement'] as List<dynamic>)
          .map((e) =>
              PensionWithStatementModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$YearlyPensionStatementModelImplToJson(
        _$YearlyPensionStatementModelImpl instance) =>
    <String, dynamic>{
      'year': instance.year,
      'pensionWithStatement': instance.pensionWithStatement,
    };
