// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database_service.dart';

// ignore_for_file: type=lint
class $PensionsTable extends Pensions with TableInfo<$PensionsTable, Pension> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PensionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _pensionIdMeta =
      const VerificationMeta('pensionId');
  @override
  late final GeneratedColumn<int> pensionId = GeneratedColumn<int>(
      'pension_id', aliasedName, false,
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
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'));
  static const VerificationMeta _maturityDateMeta =
      const VerificationMeta('maturityDate');
  @override
  late final GeneratedColumn<DateTime> maturityDate = GeneratedColumn<DateTime>(
      'maturity_date', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [pensionId, name, maturityDate];
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
    if (data.containsKey('pension_id')) {
      context.handle(_pensionIdMeta,
          pensionId.isAcceptableOrUnknown(data['pension_id']!, _pensionIdMeta));
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
  Set<GeneratedColumn> get $primaryKey => {pensionId};
  @override
  Pension map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Pension(
      pensionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}pension_id'])!,
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
  final int pensionId;
  final String name;
  final DateTime maturityDate;
  const Pension(
      {required this.pensionId,
      required this.name,
      required this.maturityDate});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['pension_id'] = Variable<int>(pensionId);
    map['name'] = Variable<String>(name);
    map['maturity_date'] = Variable<DateTime>(maturityDate);
    return map;
  }

  PensionsCompanion toCompanion(bool nullToAbsent) {
    return PensionsCompanion(
      pensionId: Value(pensionId),
      name: Value(name),
      maturityDate: Value(maturityDate),
    );
  }

  factory Pension.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Pension(
      pensionId: serializer.fromJson<int>(json['pensionId']),
      name: serializer.fromJson<String>(json['name']),
      maturityDate: serializer.fromJson<DateTime>(json['maturityDate']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'pensionId': serializer.toJson<int>(pensionId),
      'name': serializer.toJson<String>(name),
      'maturityDate': serializer.toJson<DateTime>(maturityDate),
    };
  }

  Pension copyWith({int? pensionId, String? name, DateTime? maturityDate}) =>
      Pension(
        pensionId: pensionId ?? this.pensionId,
        name: name ?? this.name,
        maturityDate: maturityDate ?? this.maturityDate,
      );
  @override
  String toString() {
    return (StringBuffer('Pension(')
          ..write('pensionId: $pensionId, ')
          ..write('name: $name, ')
          ..write('maturityDate: $maturityDate')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(pensionId, name, maturityDate);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Pension &&
          other.pensionId == this.pensionId &&
          other.name == this.name &&
          other.maturityDate == this.maturityDate);
}

class PensionsCompanion extends UpdateCompanion<Pension> {
  final Value<int> pensionId;
  final Value<String> name;
  final Value<DateTime> maturityDate;
  const PensionsCompanion({
    this.pensionId = const Value.absent(),
    this.name = const Value.absent(),
    this.maturityDate = const Value.absent(),
  });
  PensionsCompanion.insert({
    this.pensionId = const Value.absent(),
    required String name,
    required DateTime maturityDate,
  })  : name = Value(name),
        maturityDate = Value(maturityDate);
  static Insertable<Pension> custom({
    Expression<int>? pensionId,
    Expression<String>? name,
    Expression<DateTime>? maturityDate,
  }) {
    return RawValuesInsertable({
      if (pensionId != null) 'pension_id': pensionId,
      if (name != null) 'name': name,
      if (maturityDate != null) 'maturity_date': maturityDate,
    });
  }

  PensionsCompanion copyWith(
      {Value<int>? pensionId,
      Value<String>? name,
      Value<DateTime>? maturityDate}) {
    return PensionsCompanion(
      pensionId: pensionId ?? this.pensionId,
      name: name ?? this.name,
      maturityDate: maturityDate ?? this.maturityDate,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (pensionId.present) {
      map['pension_id'] = Variable<int>(pensionId.value);
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
          ..write('pensionId: $pensionId, ')
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
  static const VerificationMeta _statementIdMeta =
      const VerificationMeta('statementId');
  @override
  late final GeneratedColumn<int> statementId = GeneratedColumn<int>(
      'statement_id', aliasedName, false,
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
          'REFERENCES pensions (pension_id) ON DELETE CASCADE'));
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
        statementId,
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
    if (data.containsKey('statement_id')) {
      context.handle(
          _statementIdMeta,
          statementId.isAcceptableOrUnknown(
              data['statement_id']!, _statementIdMeta));
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
  Set<GeneratedColumn> get $primaryKey => {statementId};
  @override
  Statement map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Statement(
      statementId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}statement_id'])!,
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
  final int statementId;
  final int pension;
  final DateTime statementDate;
  final double planValue;
  final double projectedAnnualAmount;
  final double? yearlyCharges;
  final double? transferValue;
  const Statement(
      {required this.statementId,
      required this.pension,
      required this.statementDate,
      required this.planValue,
      required this.projectedAnnualAmount,
      this.yearlyCharges,
      this.transferValue});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['statement_id'] = Variable<int>(statementId);
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
      statementId: Value(statementId),
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
      statementId: serializer.fromJson<int>(json['statementId']),
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
      'statementId': serializer.toJson<int>(statementId),
      'pension': serializer.toJson<int>(pension),
      'statementDate': serializer.toJson<DateTime>(statementDate),
      'planValue': serializer.toJson<double>(planValue),
      'projectedAnnualAmount': serializer.toJson<double>(projectedAnnualAmount),
      'yearlyCharges': serializer.toJson<double?>(yearlyCharges),
      'transferValue': serializer.toJson<double?>(transferValue),
    };
  }

  Statement copyWith(
          {int? statementId,
          int? pension,
          DateTime? statementDate,
          double? planValue,
          double? projectedAnnualAmount,
          Value<double?> yearlyCharges = const Value.absent(),
          Value<double?> transferValue = const Value.absent()}) =>
      Statement(
        statementId: statementId ?? this.statementId,
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
          ..write('statementId: $statementId, ')
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
  int get hashCode => Object.hash(statementId, pension, statementDate,
      planValue, projectedAnnualAmount, yearlyCharges, transferValue);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Statement &&
          other.statementId == this.statementId &&
          other.pension == this.pension &&
          other.statementDate == this.statementDate &&
          other.planValue == this.planValue &&
          other.projectedAnnualAmount == this.projectedAnnualAmount &&
          other.yearlyCharges == this.yearlyCharges &&
          other.transferValue == this.transferValue);
}

class StatementsCompanion extends UpdateCompanion<Statement> {
  final Value<int> statementId;
  final Value<int> pension;
  final Value<DateTime> statementDate;
  final Value<double> planValue;
  final Value<double> projectedAnnualAmount;
  final Value<double?> yearlyCharges;
  final Value<double?> transferValue;
  const StatementsCompanion({
    this.statementId = const Value.absent(),
    this.pension = const Value.absent(),
    this.statementDate = const Value.absent(),
    this.planValue = const Value.absent(),
    this.projectedAnnualAmount = const Value.absent(),
    this.yearlyCharges = const Value.absent(),
    this.transferValue = const Value.absent(),
  });
  StatementsCompanion.insert({
    this.statementId = const Value.absent(),
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
    Expression<int>? statementId,
    Expression<int>? pension,
    Expression<DateTime>? statementDate,
    Expression<double>? planValue,
    Expression<double>? projectedAnnualAmount,
    Expression<double>? yearlyCharges,
    Expression<double>? transferValue,
  }) {
    return RawValuesInsertable({
      if (statementId != null) 'statement_id': statementId,
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
      {Value<int>? statementId,
      Value<int>? pension,
      Value<DateTime>? statementDate,
      Value<double>? planValue,
      Value<double>? projectedAnnualAmount,
      Value<double?>? yearlyCharges,
      Value<double?>? transferValue}) {
    return StatementsCompanion(
      statementId: statementId ?? this.statementId,
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
    if (statementId.present) {
      map['statement_id'] = Variable<int>(statementId.value);
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
          ..write('statementId: $statementId, ')
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
  static const VerificationMeta _statePensionIdMeta =
      const VerificationMeta('statePensionId');
  @override
  late final GeneratedColumn<int> statePensionId = GeneratedColumn<int>(
      'state_pension_id', aliasedName, false,
      check: () => statePensionId.equals(defaults.defaultStatePensionId),
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(defaults.defaultStatePensionId));
  static const VerificationMeta _projectedAnnualAmountMeta =
      const VerificationMeta('projectedAnnualAmount');
  @override
  late final GeneratedColumn<double> projectedAnnualAmount =
      GeneratedColumn<double>('projected_annual_amount', aliasedName, false,
          type: DriftSqlType.double, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [statePensionId, projectedAnnualAmount];
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
    if (data.containsKey('state_pension_id')) {
      context.handle(
          _statePensionIdMeta,
          statePensionId.isAcceptableOrUnknown(
              data['state_pension_id']!, _statePensionIdMeta));
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
  Set<GeneratedColumn> get $primaryKey => {statePensionId};
  @override
  StatePension map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StatePension(
      statePensionId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}state_pension_id'])!,
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
  final int statePensionId;
  final double projectedAnnualAmount;
  const StatePension(
      {required this.statePensionId, required this.projectedAnnualAmount});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['state_pension_id'] = Variable<int>(statePensionId);
    map['projected_annual_amount'] = Variable<double>(projectedAnnualAmount);
    return map;
  }

  StatePensionsCompanion toCompanion(bool nullToAbsent) {
    return StatePensionsCompanion(
      statePensionId: Value(statePensionId),
      projectedAnnualAmount: Value(projectedAnnualAmount),
    );
  }

  factory StatePension.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StatePension(
      statePensionId: serializer.fromJson<int>(json['statePensionId']),
      projectedAnnualAmount:
          serializer.fromJson<double>(json['projectedAnnualAmount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'statePensionId': serializer.toJson<int>(statePensionId),
      'projectedAnnualAmount': serializer.toJson<double>(projectedAnnualAmount),
    };
  }

  StatePension copyWith({int? statePensionId, double? projectedAnnualAmount}) =>
      StatePension(
        statePensionId: statePensionId ?? this.statePensionId,
        projectedAnnualAmount:
            projectedAnnualAmount ?? this.projectedAnnualAmount,
      );
  @override
  String toString() {
    return (StringBuffer('StatePension(')
          ..write('statePensionId: $statePensionId, ')
          ..write('projectedAnnualAmount: $projectedAnnualAmount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(statePensionId, projectedAnnualAmount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StatePension &&
          other.statePensionId == this.statePensionId &&
          other.projectedAnnualAmount == this.projectedAnnualAmount);
}

class StatePensionsCompanion extends UpdateCompanion<StatePension> {
  final Value<int> statePensionId;
  final Value<double> projectedAnnualAmount;
  const StatePensionsCompanion({
    this.statePensionId = const Value.absent(),
    this.projectedAnnualAmount = const Value.absent(),
  });
  StatePensionsCompanion.insert({
    this.statePensionId = const Value.absent(),
    required double projectedAnnualAmount,
  }) : projectedAnnualAmount = Value(projectedAnnualAmount);
  static Insertable<StatePension> custom({
    Expression<int>? statePensionId,
    Expression<double>? projectedAnnualAmount,
  }) {
    return RawValuesInsertable({
      if (statePensionId != null) 'state_pension_id': statePensionId,
      if (projectedAnnualAmount != null)
        'projected_annual_amount': projectedAnnualAmount,
    });
  }

  StatePensionsCompanion copyWith(
      {Value<int>? statePensionId, Value<double>? projectedAnnualAmount}) {
    return StatePensionsCompanion(
      statePensionId: statePensionId ?? this.statePensionId,
      projectedAnnualAmount:
          projectedAnnualAmount ?? this.projectedAnnualAmount,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (statePensionId.present) {
      map['state_pension_id'] = Variable<int>(statePensionId.value);
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
          ..write('statePensionId: $statePensionId, ')
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
