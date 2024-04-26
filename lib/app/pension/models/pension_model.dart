import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';

part 'pension_model.freezed.dart';
part 'pension_model.g.dart';

@freezed
class PensionModel with _$PensionModel {
  const factory PensionModel({
    int? pensionId,
    required String name,
    DateTime? maturityDate,
  }) = _PensionModel;

  factory PensionModel.fromJson(Map<String, Object?> json) =>
      _$PensionModelFromJson(json);
}
