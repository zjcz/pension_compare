import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/app/otherIncome/models/other_income_model.dart';

class OtherIncomeMapper {
  static OtherIncomeModel mapToModel(OtherIncome otherIncome) {
    return OtherIncomeModel(      
      otherIncomeId: otherIncome.otherIncomeId,
      name: otherIncome.name,
      annualAmount: otherIncome.annualAmount,
    );
  }

  static List<OtherIncomeModel> mapToModelList(List<OtherIncome> otherIncomes) {
    return otherIncomes.map((otherIncome) => mapToModel(otherIncome)).toList();
  }
}
