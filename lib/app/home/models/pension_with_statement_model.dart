import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/app/statement/models/statement_model.dart';

part 'pension_with_statement_model.freezed.dart';
part 'pension_with_statement_model.g.dart';

@freezed
class PensionWithStatementModel with _$PensionWithStatementModel {
  const factory PensionWithStatementModel({
    required PensionModel pension,    
    StatementModel? statement,
  }) = _PensionWithStatementModel;

  factory PensionWithStatementModel.fromJson(Map<String, Object?> json) =>
      _$PensionWithStatementModelFromJson(json);
}
