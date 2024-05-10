import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/data/import_export/models/transfer_other_income_model.dart';
import 'package:pension_compare/data/import_export/mapper/other_income_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test other income transfer mapper', () {
    testWidgets('map other income to transfer object', (tester) async {
      int otherIncomeId = 5;
      String name = 'new income';
      double amount = 123.45;
      OtherIncome otherIncome = OtherIncome(
          otherIncomeId: otherIncomeId, name: name, annualAmount: amount);

      TransferOtherIncomeModel otherIncomeModel =
          OtherIncomeMapper.toTransfer(otherIncome);

      expect(otherIncomeModel, isNotNull);
      expect(otherIncomeModel.otherIncomeId, otherIncomeId);
      expect(otherIncomeModel.name, name);
      expect(otherIncomeModel.annualAmount, amount);
    });

    testWidgets('map transfer object to other income object', (tester) async {
      int otherIncomeId = 5;
      String name = 'new income';
      double amount = 123.45;
      TransferOtherIncomeModel transferOtherIncome = TransferOtherIncomeModel(
          otherIncomeId: otherIncomeId, name: name, annualAmount: amount);

      OtherIncome otherIncome =
          OtherIncomeMapper.fromTransfer(transferOtherIncome);

      expect(otherIncome, isNotNull);
      expect(otherIncome.otherIncomeId, otherIncomeId);
      expect(otherIncome.name, name);
      expect(otherIncome.annualAmount, amount);
    });

    testWidgets('map to transfer and back again', (tester) async {
      int otherIncomeId = 5;
      String name = 'new income';
      double amount = 123.45;
      OtherIncome otherIncome = OtherIncome(
          otherIncomeId: otherIncomeId, name: name, annualAmount: amount);

      TransferOtherIncomeModel transferOtherIncome =
          OtherIncomeMapper.toTransfer(otherIncome);

      OtherIncome resultOtherIncome =
          OtherIncomeMapper.fromTransfer(transferOtherIncome);

      expect(resultOtherIncome, isNotNull);
      expect(resultOtherIncome.otherIncomeId, otherIncome.otherIncomeId);
      expect(resultOtherIncome.name, otherIncome.name);
      expect(resultOtherIncome.annualAmount, otherIncome.annualAmount);
    });
  });
}
