import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/data/mapper/pension_mapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pension_compare/data/database/database_service.dart';

part 'single_pension_controller.g.dart';

@riverpod
class SinglePensionController extends _$SinglePensionController {
  late final DatabaseService _databaseService =
      // ignore: avoid_manual_providers_as_generated_provider_dependency
      ref.read(DatabaseService.provider);

  @override
  Stream<PensionModel?> build(int pensionId) {
    return _databaseService
        .watchPension(pensionId)
        .map((p) => p == null ? null : PensionMapper.mapToModel(p));
  }
}
