import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/app/statement/models/statement_model.dart';

part 'pension_with_latest_statement_model.freezed.dart';
part 'pension_with_latest_statement_model.g.dart';

@freezed
class PensionWithLatestStatementModel with _$PensionWithLatestStatementModel {
  const factory PensionWithLatestStatementModel({
    required PensionModel pension,    
    StatementModel? latestStatement,
  }) = _PensionWithLatestStatementModel;

  factory PensionWithLatestStatementModel.fromJson(Map<String, Object?> json) =>
      _$PensionWithLatestStatementModelFromJson(json);
}
