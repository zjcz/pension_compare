import 'package:pension_compare/constants/pension_status.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/app/pension/models/pension_model.dart';

class PensionMapper {
  static PensionModel mapToModel(Pension pension) {
    return PensionModel(
      pensionId: pension.pensionId,
      name: pension.name,
      maturityDate: pension.maturityDate,
      status: PensionStatus.fromDataValue(pension.status),
      statusDate: pension.statusDate,
    );
  }

  static List<PensionModel> mapToModelList(List<Pension> pensions) {
    return pensions.map((pension) => mapToModel(pension)).toList();
  }
}
