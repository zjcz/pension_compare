import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'other_income_model.freezed.dart';
part 'other_income_model.g.dart';

@freezed
class OtherIncomeModel with _$OtherIncomeModel {
  const factory OtherIncomeModel({
    int? otherIncomeId,
    required String name,
    required double annualAmount,
  }) = _OtherIncomeModel;

  factory OtherIncomeModel.fromJson(Map<String, Object?> json) =>
      _$OtherIncomeModelFromJson(json);
}
