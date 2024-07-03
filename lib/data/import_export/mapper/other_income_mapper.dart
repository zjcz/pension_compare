import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/data/import_export/models/transfer_other_income_model.dart';

class OtherIncomeMapper {
  static TransferOtherIncomeModel toTransfer(OtherIncome otherIncome) {
    return TransferOtherIncomeModel(
      otherIncomeId: otherIncome.otherIncomeId,
      name: otherIncome.name,
      annualAmount: otherIncome.annualAmount,
      notes: otherIncome.notes,
    );
  }

  static OtherIncome fromTransfer(TransferOtherIncomeModel otherIncome) {
    return OtherIncome(
      otherIncomeId: otherIncome.otherIncomeId,
      name: otherIncome.name,
      annualAmount: otherIncome.annualAmount,
      notes: otherIncome.notes,
    );
  }
}
