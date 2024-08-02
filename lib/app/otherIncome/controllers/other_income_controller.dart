import 'package:pension_compare/app/otherIncome/models/other_income_model.dart';
import 'package:pension_compare/data/mapper/other_income_mapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pension_compare/data/database/database_service.dart';

part 'other_income_controller.g.dart';

@riverpod
class OtherIncomeController extends _$OtherIncomeController {
  late final DatabaseService _databaseService =
      // ignore: avoid_manual_providers_as_generated_provider_dependency
      ref.read(DatabaseService.provider);

  @override
  Stream<List<OtherIncomeModel>> build() {
    return _databaseService
        .getAllOtherIncomes()
        .map((p) => OtherIncomeMapper.mapToModelList(p));
  }

  Future<OtherIncomeModel?> getStatePension() async {
    OtherIncome? statePension = await _databaseService.getStatePension();
    return statePension == null
        ? null
        : OtherIncomeMapper.mapToModel(statePension);
  }

  Future<void> updateStatePension(double value) {
    return _databaseService.saveStatePension(value, null);
  }
}
