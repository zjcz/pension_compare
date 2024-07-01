import 'package:pension_compare/app/home/models/yearly_pension_statement_model.dart';
import 'package:pension_compare/data/mapper/yearly_pension_statement_mapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pension_compare/data/database/database_service.dart';

part 'yearly_pension_statement_controller.g.dart';

@riverpod
class YearlyPensionStatementController extends _$YearlyPensionStatementController {
  late final DatabaseService _databaseService =
      ref.read(DatabaseService.provider);

  @override
  Stream<List<YearlyPensionStatementModel>> build() {
    return _databaseService
        .getYearlyPensionSummary()
        .map((p) => YearlyPensionLatestStatementMapper.mapToModelList(p));
  }
}
