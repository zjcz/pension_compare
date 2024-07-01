import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:pension_compare/app/home/models/pension_with_statement_model.dart';

part 'yearly_pension_statement_model.freezed.dart';
part 'yearly_pension_statement_model.g.dart';

@freezed
class YearlyPensionStatementModel with _$YearlyPensionStatementModel {
  const factory YearlyPensionStatementModel({
    required int year,    
    required List<PensionWithStatementModel> pensionWithStatement,
  }) = _YearlyPensionStatementModel;

  factory YearlyPensionStatementModel.fromJson(Map<String, Object?> json) =>
      _$YearlyPensionStatementModelFromJson(json);
}
