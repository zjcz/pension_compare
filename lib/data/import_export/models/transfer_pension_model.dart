import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:pension_compare/data/import_export/models/transfer_statement_model.dart';

part 'transfer_pension_model.freezed.dart';
part 'transfer_pension_model.g.dart';

@freezed
class TransferPensionModel with _$TransferPensionModel {
  const factory TransferPensionModel({
    required int pensionId,
    required String name,
    required DateTime maturityDate,
    required List<TransferStatementModel> statements,
  }) = _TransferPensionModel;

  factory TransferPensionModel.fromJson(Map<String, Object?> json) =>
      _$TransferPensionModelFromJson(json);
}
