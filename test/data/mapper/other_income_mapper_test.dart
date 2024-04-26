import 'package:pension_compare/app/otherIncome/models/other_income_model.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/data/mapper/other_income_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test other income mapper', () {
    testWidgets('map single object', (tester) async {
      int otherIncomeId = 5;
      String name = 'new income';
      double amount = 123.45;
      OtherIncome otherIncome = OtherIncome(
          otherIncomeId: otherIncomeId, name: name, annualAmount: amount);

      OtherIncomeModel otherIncomeModel = OtherIncomeMapper.mapToModel(otherIncome);

      expect(otherIncomeModel, isNotNull);
      expect(otherIncomeModel.otherIncomeId, otherIncomeId);
      expect(otherIncomeModel.name, name);
      expect(otherIncomeModel.annualAmount, amount);
    });

    testWidgets('map list object object', (tester) async {
      int otherIncomeId = 5;
      String name = 'new income';
      double amount = 123.45;
      OtherIncome otherIncome = OtherIncome(
          otherIncomeId: otherIncomeId, name: name, annualAmount: amount);

      List<OtherIncomeModel> otherIncomeModel = OtherIncomeMapper.mapToModelList([otherIncome]);

      expect(otherIncomeModel, isNotNull);
      expect(otherIncomeModel.length, 1);
      expect(otherIncomeModel[0].otherIncomeId, otherIncomeId);
      expect(otherIncomeModel[0].name, name);
      expect(otherIncomeModel[0].annualAmount, amount);
    });
  });
}
