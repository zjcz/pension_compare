import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'transfer_statement_model.freezed.dart';
part 'transfer_statement_model.g.dart';

@freezed
class TransferStatementModel with _$TransferStatementModel {
  const factory TransferStatementModel({
    required int statementId,
    required DateTime statementDate,
    required double planValue,
    required double projectedAnnualAmount,
    double? yearlyCharges,
    double? transferValue,
    double? amountPaidIn,
    String? notes,
  }) = _TransferStatementModel;

  factory TransferStatementModel.fromJson(Map<String, Object?> json) =>
      _$TransferStatementModelFromJson(json);
}
