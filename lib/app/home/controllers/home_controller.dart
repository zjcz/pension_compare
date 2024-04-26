import 'package:pension_compare/app/home/models/pension_with_latest_statement_model.dart';
import 'package:pension_compare/data/mapper/pension_with_latest_statement_mapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pension_compare/data/database/database_service.dart';

part 'home_controller.g.dart';

@riverpod
class HomeController extends _$HomeController {
  late final DatabaseService _databaseService =
      ref.read(DatabaseService.provider);

  @override
  Stream<List<PensionWithLatestStatementModel>> build() {
    return _databaseService
        .getAllPensionsWithLatestStatement()
        .map((p) => PensionWithLatestStatementMapper.mapToModelList(p));
  }

  Future<void> populateTestData() {
    return _databaseService.populateTestData();
  }

  Future<void> clearAllData() {
    return _databaseService.clearAllData();
  }
}
