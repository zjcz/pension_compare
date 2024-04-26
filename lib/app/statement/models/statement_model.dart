import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'statement_model.freezed.dart';
part 'statement_model.g.dart';

@freezed
class StatementModel with _$StatementModel {
  const factory StatementModel({
    int? statementId,
    required int pension,
    required DateTime statementDate,
    required double planValue,
    required double projectedAnnualAmount,
    double? yearlyCharges,
    double? transferValue,
  }) = _StatementModel;

  factory StatementModel.fromJson(Map<String, Object?> json) =>
      _$StatementModelFromJson(json);
}
