// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_service.dart';

// ignore_for_file: type=lint
class $PensionsTable extends Pensions with TableInfo<$PensionsTable, Pension> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PensionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks: GeneratedColumn.checkTextLength(maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _maturityDateMeta =
      const VerificationMeta('maturityDate');
  @override
  late final GeneratedColumn<DateTime> maturityDate = GeneratedColumn<DateTime>(
      'maturity_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, name, maturityDate];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'pensions';
  @override
  VerificationContext validateIntegrity(Insertable<Pension> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('maturity_date')) {
      context.handle(
          _maturityDateMeta,
          maturityDate.isAcceptableOrUnknown(
              data['maturity_date']!, _maturityDateMeta));
    } else if (isInserting) {
      context.missing(_maturityDateMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Pension map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pension(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      maturityDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}maturity_date'])!,
    );
  }

  @override
  $PensionsTable createAlias(String alias) {
    return $PensionsTable(attachedDatabase, alias);
  }
}

class Pension extends DataClass implements Insertable<Pension> {
  final int id;
  final String name;
  final DateTime maturityDate;
  const Pension(
      {required this.id, required this.name, required this.maturityDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['maturity_date'] = Variable<DateTime>(maturityDate);
    return map;
  }

  PensionsCompanion toCompanion(bool nullToAbsent) {
    return PensionsCompanion(
      id: Value(id),
      name: Value(name),
      maturityDate: Value(maturityDate),
    );
  }

  factory Pension.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pension(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      maturityDate: serializer.fromJson<DateTime>(json['maturityDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'maturityDate': serializer.toJson<DateTime>(maturityDate),
    };
  }

  Pension copyWith({int? id, String? name, DateTime? maturityDate}) => Pension(
        id: id ?? this.id,
        name: name ?? this.name,
        maturityDate: maturityDate ?? this.maturityDate,
      );
  @override
  String toString() {
    return (StringBuffer('Pension(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('maturityDate: $maturityDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, maturityDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pension &&
          other.id == this.id &&
          other.name == this.name &&
          other.maturityDate == this.maturityDate);
}

class PensionsCompanion extends UpdateCompanion<Pension> {
  final Value<int> id;
  final Value<String> name;
  final Value<DateTime> maturityDate;
  const PensionsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.maturityDate = const Value.absent(),
  });
  PensionsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required DateTime maturityDate,
  })  : name = Value(name),
        maturityDate = Value(maturityDate);
  static Insertable<Pension> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<DateTime>? maturityDate,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (maturityDate != null) 'maturity_date': maturityDate,
    });
  }

  PensionsCompanion copyWith(
      {Value<int>? id, Value<String>? name, Value<DateTime>? maturityDate}) {
    return PensionsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      maturityDate: maturityDate ?? this.maturityDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (maturityDate.present) {
      map['maturity_date'] = Variable<DateTime>(maturityDate.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PensionsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('maturityDate: $maturityDate')
          ..write(')'))
        .toString();
  }
}

class $StatementsTable extends Statements
    with TableInfo<$StatementsTable, Statement> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StatementsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _pensionMeta =
      const VerificationMeta('pension');
  @override
  late final GeneratedColumn<int> pension = GeneratedColumn<int>(
      'pension', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES pensions (id) ON DELETE CASCADE'));
  static const VerificationMeta _statementDateMeta =
      const VerificationMeta('statementDate');
  @override
  late final GeneratedColumn<DateTime> statementDate =
      GeneratedColumn<DateTime>('statement_date', aliasedName, false,
          type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _planValueMeta =
      const VerificationMeta('planValue');
  @override
  late final GeneratedColumn<double> planValue = GeneratedColumn<double>(
      'plan_value', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _projectedAnnualAmountMeta =
      const VerificationMeta('projectedAnnualAmount');
  @override
  late final GeneratedColumn<double> projectedAnnualAmount =
      GeneratedColumn<double>('projected_annual_amount', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _yearlyChargesMeta =
      const VerificationMeta('yearlyCharges');
  @override
  late final GeneratedColumn<double> yearlyCharges = GeneratedColumn<double>(
      'yearly_charges', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  static const VerificationMeta _transferValueMeta =
      const VerificationMeta('transferValue');
  @override
  late final GeneratedColumn<double> transferValue = GeneratedColumn<double>(
      'transfer_value', aliasedName, true,
      type: DriftSqlType.double, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        pension,
        statementDate,
        planValue,
        projectedAnnualAmount,
        yearlyCharges,
        transferValue
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'statements';
  @override
  VerificationContext validateIntegrity(Insertable<Statement> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('pension')) {
      context.handle(_pensionMeta,
          pension.isAcceptableOrUnknown(data['pension']!, _pensionMeta));
    } else if (isInserting) {
      context.missing(_pensionMeta);
    }
    if (data.containsKey('statement_date')) {
      context.handle(
          _statementDateMeta,
          statementDate.isAcceptableOrUnknown(
              data['statement_date']!, _statementDateMeta));
    } else if (isInserting) {
      context.missing(_statementDateMeta);
    }
    if (data.containsKey('plan_value')) {
      context.handle(_planValueMeta,
          planValue.isAcceptableOrUnknown(data['plan_value']!, _planValueMeta));
    } else if (isInserting) {
      context.missing(_planValueMeta);
    }
    if (data.containsKey('projected_annual_amount')) {
      context.handle(
          _projectedAnnualAmountMeta,
          projectedAnnualAmount.isAcceptableOrUnknown(
              data['projected_annual_amount']!, _projectedAnnualAmountMeta));
    } else if (isInserting) {
      context.missing(_projectedAnnualAmountMeta);
    }
    if (data.containsKey('yearly_charges')) {
      context.handle(
          _yearlyChargesMeta,
          yearlyCharges.isAcceptableOrUnknown(
              data['yearly_charges']!, _yearlyChargesMeta));
    }
    if (data.containsKey('transfer_value')) {
      context.handle(
          _transferValueMeta,
          transferValue.isAcceptableOrUnknown(
              data['transfer_value']!, _transferValueMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Statement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Statement(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      pension: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pension'])!,
      statementDate: attachedDatabase.typeMapping.read(
          DriftSqlType.dateTime, data['${effectivePrefix}statement_date'])!,
      planValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}plan_value'])!,
      projectedAnnualAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}projected_annual_amount'])!,
      yearlyCharges: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}yearly_charges']),
      transferValue: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}transfer_value']),
    );
  }

  @override
  $StatementsTable createAlias(String alias) {
    return $StatementsTable(attachedDatabase, alias);
  }
}

class Statement extends DataClass implements Insertable<Statement> {
  final int id;
  final int pension;
  final DateTime statementDate;
  final double planValue;
  final double projectedAnnualAmount;
  final double? yearlyCharges;
  final double? transferValue;
  const Statement(
      {required this.id,
      required this.pension,
      required this.statementDate,
      required this.planValue,
      required this.projectedAnnualAmount,
      this.yearlyCharges,
      this.transferValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['pension'] = Variable<int>(pension);
    map['statement_date'] = Variable<DateTime>(statementDate);
    map['plan_value'] = Variable<double>(planValue);
    map['projected_annual_amount'] = Variable<double>(projectedAnnualAmount);
    if (!nullToAbsent || yearlyCharges != null) {
      map['yearly_charges'] = Variable<double>(yearlyCharges);
    }
    if (!nullToAbsent || transferValue != null) {
      map['transfer_value'] = Variable<double>(transferValue);
    }
    return map;
  }

  StatementsCompanion toCompanion(bool nullToAbsent) {
    return StatementsCompanion(
      id: Value(id),
      pension: Value(pension),
      statementDate: Value(statementDate),
      planValue: Value(planValue),
      projectedAnnualAmount: Value(projectedAnnualAmount),
      yearlyCharges: yearlyCharges == null && nullToAbsent
          ? const Value.absent()
          : Value(yearlyCharges),
      transferValue: transferValue == null && nullToAbsent
          ? const Value.absent()
          : Value(transferValue),
    );
  }

  factory Statement.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Statement(
      id: serializer.fromJson<int>(json['id']),
      pension: serializer.fromJson<int>(json['pension']),
      statementDate: serializer.fromJson<DateTime>(json['statementDate']),
      planValue: serializer.fromJson<double>(json['planValue']),
      projectedAnnualAmount:
          serializer.fromJson<double>(json['projectedAnnualAmount']),
      yearlyCharges: serializer.fromJson<double?>(json['yearlyCharges']),
      transferValue: serializer.fromJson<double?>(json['transferValue']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'pension': serializer.toJson<int>(pension),
      'statementDate': serializer.toJson<DateTime>(statementDate),
      'planValue': serializer.toJson<double>(planValue),
      'projectedAnnualAmount': serializer.toJson<double>(projectedAnnualAmount),
      'yearlyCharges': serializer.toJson<double?>(yearlyCharges),
      'transferValue': serializer.toJson<double?>(transferValue),
    };
  }

  Statement copyWith(
          {int? id,
          int? pension,
          DateTime? statementDate,
          double? planValue,
          double? projectedAnnualAmount,
          Value<double?> yearlyCharges = const Value.absent(),
          Value<double?> transferValue = const Value.absent()}) =>
      Statement(
        id: id ?? this.id,
        pension: pension ?? this.pension,
        statementDate: statementDate ?? this.statementDate,
        planValue: planValue ?? this.planValue,
        projectedAnnualAmount:
            projectedAnnualAmount ?? this.projectedAnnualAmount,
        yearlyCharges:
            yearlyCharges.present ? yearlyCharges.value : this.yearlyCharges,
        transferValue:
            transferValue.present ? transferValue.value : this.transferValue,
      );
  @override
  String toString() {
    return (StringBuffer('Statement(')
          ..write('id: $id, ')
          ..write('pension: $pension, ')
          ..write('statementDate: $statementDate, ')
          ..write('planValue: $planValue, ')
          ..write('projectedAnnualAmount: $projectedAnnualAmount, ')
          ..write('yearlyCharges: $yearlyCharges, ')
          ..write('transferValue: $transferValue')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, pension, statementDate, planValue,
      projectedAnnualAmount, yearlyCharges, transferValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Statement &&
          other.id == this.id &&
          other.pension == this.pension &&
          other.statementDate == this.statementDate &&
          other.planValue == this.planValue &&
          other.projectedAnnualAmount == this.projectedAnnualAmount &&
          other.yearlyCharges == this.yearlyCharges &&
          other.transferValue == this.transferValue);
}

class StatementsCompanion extends UpdateCompanion<Statement> {
  final Value<int> id;
  final Value<int> pension;
  final Value<DateTime> statementDate;
  final Value<double> planValue;
  final Value<double> projectedAnnualAmount;
  final Value<double?> yearlyCharges;
  final Value<double?> transferValue;
  const StatementsCompanion({
    this.id = const Value.absent(),
    this.pension = const Value.absent(),
    this.statementDate = const Value.absent(),
    this.planValue = const Value.absent(),
    this.projectedAnnualAmount = const Value.absent(),
    this.yearlyCharges = const Value.absent(),
    this.transferValue = const Value.absent(),
  });
  StatementsCompanion.insert({
    this.id = const Value.absent(),
    required int pension,
    required DateTime statementDate,
    required double planValue,
    required double projectedAnnualAmount,
    this.yearlyCharges = const Value.absent(),
    this.transferValue = const Value.absent(),
  })  : pension = Value(pension),
        statementDate = Value(statementDate),
        planValue = Value(planValue),
        projectedAnnualAmount = Value(projectedAnnualAmount);
  static Insertable<Statement> custom({
    Expression<int>? id,
    Expression<int>? pension,
    Expression<DateTime>? statementDate,
    Expression<double>? planValue,
    Expression<double>? projectedAnnualAmount,
    Expression<double>? yearlyCharges,
    Expression<double>? transferValue,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (pension != null) 'pension': pension,
      if (statementDate != null) 'statement_date': statementDate,
      if (planValue != null) 'plan_value': planValue,
      if (projectedAnnualAmount != null)
        'projected_annual_amount': projectedAnnualAmount,
      if (yearlyCharges != null) 'yearly_charges': yearlyCharges,
      if (transferValue != null) 'transfer_value': transferValue,
    });
  }

  StatementsCompanion copyWith(
      {Value<int>? id,
      Value<int>? pension,
      Value<DateTime>? statementDate,
      Value<double>? planValue,
      Value<double>? projectedAnnualAmount,
      Value<double?>? yearlyCharges,
      Value<double?>? transferValue}) {
    return StatementsCompanion(
      id: id ?? this.id,
      pension: pension ?? this.pension,
      statementDate: statementDate ?? this.statementDate,
      planValue: planValue ?? this.planValue,
      projectedAnnualAmount:
          projectedAnnualAmount ?? this.projectedAnnualAmount,
      yearlyCharges: yearlyCharges ?? this.yearlyCharges,
      transferValue: transferValue ?? this.transferValue,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (pension.present) {
      map['pension'] = Variable<int>(pension.value);
    }
    if (statementDate.present) {
      map['statement_date'] = Variable<DateTime>(statementDate.value);
    }
    if (planValue.present) {
      map['plan_value'] = Variable<double>(planValue.value);
    }
    if (projectedAnnualAmount.present) {
      map['projected_annual_amount'] =
          Variable<double>(projectedAnnualAmount.value);
    }
    if (yearlyCharges.present) {
      map['yearly_charges'] = Variable<double>(yearlyCharges.value);
    }
    if (transferValue.present) {
      map['transfer_value'] = Variable<double>(transferValue.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StatementsCompanion(')
          ..write('id: $id, ')
          ..write('pension: $pension, ')
          ..write('statementDate: $statementDate, ')
          ..write('planValue: $planValue, ')
          ..write('projectedAnnualAmount: $projectedAnnualAmount, ')
          ..write('yearlyCharges: $yearlyCharges, ')
          ..write('transferValue: $transferValue')
          ..write(')'))
        .toString();
  }
}

class $StatePensionsTable extends StatePensions
    with TableInfo<$StatePensionsTable, StatePension> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StatePensionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      check: () => id.equals(1),
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _projectedAnnualAmountMeta =
      const VerificationMeta('projectedAnnualAmount');
  @override
  late final GeneratedColumn<double> projectedAnnualAmount =
      GeneratedColumn<double>('projected_annual_amount', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, projectedAnnualAmount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'state_pensions';
  @override
  VerificationContext validateIntegrity(Insertable<StatePension> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('projected_annual_amount')) {
      context.handle(
          _projectedAnnualAmountMeta,
          projectedAnnualAmount.isAcceptableOrUnknown(
              data['projected_annual_amount']!, _projectedAnnualAmountMeta));
    } else if (isInserting) {
      context.missing(_projectedAnnualAmountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StatePension map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StatePension(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      projectedAnnualAmount: attachedDatabase.typeMapping.read(
          DriftSqlType.double,
          data['${effectivePrefix}projected_annual_amount'])!,
    );
  }

  @override
  $StatePensionsTable createAlias(String alias) {
    return $StatePensionsTable(attachedDatabase, alias);
  }
}

class StatePension extends DataClass implements Insertable<StatePension> {
  final int id;
  final double projectedAnnualAmount;
  const StatePension({required this.id, required this.projectedAnnualAmount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['projected_annual_amount'] = Variable<double>(projectedAnnualAmount);
    return map;
  }

  StatePensionsCompanion toCompanion(bool nullToAbsent) {
    return StatePensionsCompanion(
      id: Value(id),
      projectedAnnualAmount: Value(projectedAnnualAmount),
    );
  }

  factory StatePension.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StatePension(
      id: serializer.fromJson<int>(json['id']),
      projectedAnnualAmount:
          serializer.fromJson<double>(json['projectedAnnualAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'projectedAnnualAmount': serializer.toJson<double>(projectedAnnualAmount),
    };
  }

  StatePension copyWith({int? id, double? projectedAnnualAmount}) =>
      StatePension(
        id: id ?? this.id,
        projectedAnnualAmount:
            projectedAnnualAmount ?? this.projectedAnnualAmount,
      );
  @override
  String toString() {
    return (StringBuffer('StatePension(')
          ..write('id: $id, ')
          ..write('projectedAnnualAmount: $projectedAnnualAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projectedAnnualAmount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StatePension &&
          other.id == this.id &&
          other.projectedAnnualAmount == this.projectedAnnualAmount);
}

class StatePensionsCompanion extends UpdateCompanion<StatePension> {
  final Value<int> id;
  final Value<double> projectedAnnualAmount;
  const StatePensionsCompanion({
    this.id = const Value.absent(),
    this.projectedAnnualAmount = const Value.absent(),
  });
  StatePensionsCompanion.insert({
    this.id = const Value.absent(),
    required double projectedAnnualAmount,
  }) : projectedAnnualAmount = Value(projectedAnnualAmount);
  static Insertable<StatePension> custom({
    Expression<int>? id,
    Expression<double>? projectedAnnualAmount,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectedAnnualAmount != null)
        'projected_annual_amount': projectedAnnualAmount,
    });
  }

  StatePensionsCompanion copyWith(
      {Value<int>? id, Value<double>? projectedAnnualAmount}) {
    return StatePensionsCompanion(
      id: id ?? this.id,
      projectedAnnualAmount:
          projectedAnnualAmount ?? this.projectedAnnualAmount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (projectedAnnualAmount.present) {
      map['projected_annual_amount'] =
          Variable<double>(projectedAnnualAmount.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StatePensionsCompanion(')
          ..write('id: $id, ')
          ..write('projectedAnnualAmount: $projectedAnnualAmount')
          ..write(')'))
        .toString();
  }
}

abstract class _$DatabaseService extends GeneratedDatabase {
  _$DatabaseService(QueryExecutor e) : super(e);
  late final $PensionsTable pensions = $PensionsTable(this);
  late final $StatementsTable statements = $StatementsTable(this);
  late final $StatePensionsTable statePensions = $StatePensionsTable(this);
  late final Index parentPension = Index(
      'parent_pension', 'CREATE INDEX parent_pension ON statements (pension)');
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [pensions, statements, statePensions, parentPension];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('pensions',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('statements', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}
