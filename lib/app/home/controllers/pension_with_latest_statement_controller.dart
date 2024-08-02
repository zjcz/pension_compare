import 'package:pension_compare/app/home/models/pension_with_statement_model.dart';
import 'package:pension_compare/data/mapper/pension_with_statement_mapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pension_compare/data/database/database_service.dart';

part 'pension_with_latest_statement_controller.g.dart';

@riverpod
class PensionWithLatestStatementController
    extends _$PensionWithLatestStatementController {
  late final DatabaseService _databaseService =
      // ignore: avoid_manual_providers_as_generated_provider_dependency
      ref.read(DatabaseService.provider);

  @override
  Stream<List<PensionWithStatementModel>> build() {
    return _databaseService
        .getAllPensionsWithLatestStatement()
        .map((p) => PensionWithStatementMapper.mapToModelList(p));
  }
}
