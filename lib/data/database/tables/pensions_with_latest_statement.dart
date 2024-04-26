import 'package:pension_compare/data/database/database_service.dart';

class PensionWithLatestStatement {
  final Pension pension;
  final Statement? latestStatement;

  PensionWithLatestStatement(this.pension, this.latestStatement);
}
