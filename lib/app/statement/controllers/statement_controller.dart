import 'package:pension_compare/app/statement/models/statement_model.dart';
import 'package:pension_compare/data/mapper/statement_mapper.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pension_compare/data/database/database_service.dart';

part 'statement_controller.g.dart';

@riverpod
class StatementController extends _$StatementController {
  late final DatabaseService _databaseService =
      ref.read(DatabaseService.provider);

  @override
  Stream<List<StatementModel>> build(int pensionId) {
    return _databaseService
        .getAllStatementsForPension(pensionId)
        .map((s) => StatementMapper.mapToModelList(s));
  }

  Future<StatementModel?> createStatement(
      int pensionId,
      DateTime statementDate,
      double planValue,
      double projectedAnnualAmount,
      double? yearlyCharges,
      double? transferValue,
      double? amountPaidIn) async {
    Statement? newStatement = await _databaseService.createStatement(
        pensionId,
        statementDate,
        planValue,
        projectedAnnualAmount,
        yearlyCharges,
        transferValue,
        amountPaidIn, null);
    return newStatement == null
        ? null
        : StatementMapper.mapToModel(newStatement);
  }

  Future<StatementModel?> getStatement(int id) async {
    Statement? statement = await _databaseService.getStatement(id);
    return statement == null ? null : StatementMapper.mapToModel(statement);
  }

  Future<int> deleteStatement(int id) {
    return _databaseService.deleteStatement(id);
  }

  Future<bool> updateStatement(
      int id,
      int pensionId,
      DateTime statementDate,
      double planValue,
      double projectedAnnualAmount,
      double? yearlyCharges,
      double? transferValue,
      double? amountPaidIn) {
    return _databaseService.updateStatement(
        id,
        pensionId,
        statementDate,
        planValue,
        projectedAnnualAmount,
        yearlyCharges,
        transferValue,
        amountPaidIn,
        null);
  }

  Future<bool> doesStatementDateExist(
      int? id, int pensionId, DateTime statementDate) {
    return _databaseService.doesStatementDateExist(
        id, pensionId, statementDate);
  }
}
