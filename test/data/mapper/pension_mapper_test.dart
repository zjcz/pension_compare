import 'package:pension_compare/app/pension/models/pension_model.dart';
import 'package:pension_compare/data/database/database_service.dart';
import 'package:pension_compare/data/mapper/pension_mapper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test pension mapper', () {
    testWidgets('map single object', (tester) async {
      int pensionId = 5;
      String pensionName = 'new pension';
      DateTime maturityDate = DateTime.now();
      Pension pension = Pension(
          pensionId: pensionId, name: pensionName, maturityDate: maturityDate);

      PensionModel pensionModel = PensionMapper.mapToModel(pension);

      expect(pensionModel, isNotNull);
      expect(pensionModel.pensionId, pensionId);
      expect(pensionModel.name, pensionName);
      expect(pensionModel.maturityDate, maturityDate);
    });

    testWidgets('map list object object', (tester) async {
      int pensionId = 5;
      String pensionName = 'new pension';
      DateTime maturityDate = DateTime.now();
      Pension pension = Pension(
          pensionId: pensionId, name: pensionName, maturityDate: maturityDate);

      List<PensionModel> pensionModel = PensionMapper.mapToModelList([pension]);

      expect(pensionModel, isNotNull);
      expect(pensionModel.length, 1);
      expect(pensionModel[0].pensionId, pensionId);
      expect(pensionModel[0].name, pensionName);
      expect(pensionModel[0].maturityDate, maturityDate);
    });
  });
}
