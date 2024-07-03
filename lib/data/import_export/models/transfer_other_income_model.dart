import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'transfer_other_income_model.freezed.dart';
part 'transfer_other_income_model.g.dart';

@freezed
class TransferOtherIncomeModel with _$TransferOtherIncomeModel {
  const factory TransferOtherIncomeModel({
    required int otherIncomeId,
    required String name,
    required double annualAmount,
    String? notes
  }) = _TransferOtherIncomeModel;

  factory TransferOtherIncomeModel.fromJson(Map<String, Object?> json) =>
      _$TransferOtherIncomeModelFromJson(json);
}
