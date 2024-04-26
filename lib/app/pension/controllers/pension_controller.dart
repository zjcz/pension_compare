import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/data/mapper/pension_mapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pension_compare/data/database/database_service.dart';

part 'pension_controller.g.dart';

@riverpod
class PensionController extends _$PensionController {
  late final DatabaseService _databaseService =
      ref.read(DatabaseService.provider);

  @override
  Stream<List<PensionModel>> build() {
    return _databaseService
        .getAllPensions()
        .map((p) => PensionMapper.mapToModelList(p));
  }

  Future<PensionModel?> createPension(
      String name, DateTime maturityDate) async {
    Pension? newPension =
        await _databaseService.createPension(name, maturityDate);
    return newPension == null ? null : PensionMapper.mapToModel(newPension);
  }

  Future<PensionModel?> getPension(int id) async {
    Pension? pension = await _databaseService.getPension(id);
    return pension == null ? null : PensionMapper.mapToModel(pension);
  }

  Future<int> deletePension(int id) {
    return _databaseService.deletePension(id);
  }

  Future<bool> updatePension(int id, String name, DateTime maturityDate) {
    return _databaseService.updatePension(id, name, maturityDate);
  }

  Future<bool> doesPensionNameExist(int? id, String name) {
    return _databaseService.doesPensionNameExist(id, name);
  }
}
