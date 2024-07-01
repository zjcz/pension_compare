import 'package:pension_compare/data/database/database_service.dart';

class PensionWithStatement {
  final Pension pension;
  final Statement? statement;

  PensionWithStatement(this.pension, this.statement);
}
