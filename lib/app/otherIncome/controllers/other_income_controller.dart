import 'package:pension_compare/app/otherIncome/models/other_income_model.dart';
import 'package:pension_compare/data/mapper/other_income_mapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pension_compare/data/database/database_service.dart';

part 'other_income_controller.g.dart';

@riverpod
class OtherIncomeController extends _$OtherIncomeController {
  late final DatabaseService _databaseService =
      ref.read(DatabaseService.provider);

  @override
  Future<List<OtherIncome>> build() {
    // nothing to do right now
    return Future.value([]);
  }

  Future<OtherIncomeModel?> getStatePension() async {
    OtherIncome? statePension = await _databaseService.getStatePension();
    return statePension == null
        ? null
        : OtherIncomeMapper.mapToModel(statePension);
  }

  Future<void> updateStatePension(double value) {
    return _databaseService.saveStatePension(value);
  }
}
