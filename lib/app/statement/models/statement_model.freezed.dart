// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'statement_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

StatementModel _$StatementModelFromJson(Map<String, dynamic> json) {
  return _StatementModel.fromJson(json);
}

/// @nodoc
mixin _$StatementModel {
  int? get statementId => throw _privateConstructorUsedError;
  int get pension => throw _privateConstructorUsedError;
  DateTime get statementDate => throw _privateConstructorUsedError;
  double get planValue => throw _privateConstructorUsedError;
  double get projectedAnnualAmount => throw _privateConstructorUsedError;
  double? get yearlyCharges => throw _privateConstructorUsedError;
  double? get transferValue => throw _privateConstructorUsedError;
  double? get amountPaidIn => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StatementModelCopyWith<StatementModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StatementModelCopyWith<$Res> {
  factory $StatementModelCopyWith(
          StatementModel value, $Res Function(StatementModel) then) =
      _$StatementModelCopyWithImpl<$Res, StatementModel>;
  @useResult
  $Res call(
      {int? statementId,
      int pension,
      DateTime statementDate,
      double planValue,
      double projectedAnnualAmount,
      double? yearlyCharges,
      double? transferValue,
      double? amountPaidIn});
}

/// @nodoc
class _$StatementModelCopyWithImpl<$Res, $Val extends StatementModel>
    implements $StatementModelCopyWith<$Res> {
  _$StatementModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statementId = freezed,
    Object? pension = null,
    Object? statementDate = null,
    Object? planValue = null,
    Object? projectedAnnualAmount = null,
    Object? yearlyCharges = freezed,
    Object? transferValue = freezed,
    Object? amountPaidIn = freezed,
  }) {
    return _then(_value.copyWith(
      statementId: freezed == statementId
          ? _value.statementId
          : statementId // ignore: cast_nullable_to_non_nullable
              as int?,
      pension: null == pension
          ? _value.pension
          : pension // ignore: cast_nullable_to_non_nullable
              as int,
      statementDate: null == statementDate
          ? _value.statementDate
          : statementDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      planValue: null == planValue
          ? _value.planValue
          : planValue // ignore: cast_nullable_to_non_nullable
              as double,
      projectedAnnualAmount: null == projectedAnnualAmount
          ? _value.projectedAnnualAmount
          : projectedAnnualAmount // ignore: cast_nullable_to_non_nullable
              as double,
      yearlyCharges: freezed == yearlyCharges
          ? _value.yearlyCharges
          : yearlyCharges // ignore: cast_nullable_to_non_nullable
              as double?,
      transferValue: freezed == transferValue
          ? _value.transferValue
          : transferValue // ignore: cast_nullable_to_non_nullable
              as double?,
      amountPaidIn: freezed == amountPaidIn
          ? _value.amountPaidIn
          : amountPaidIn // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$StatementModelImplCopyWith<$Res>
    implements $StatementModelCopyWith<$Res> {
  factory _$$StatementModelImplCopyWith(_$StatementModelImpl value,
          $Res Function(_$StatementModelImpl) then) =
      __$$StatementModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? statementId,
      int pension,
      DateTime statementDate,
      double planValue,
      double projectedAnnualAmount,
      double? yearlyCharges,
      double? transferValue,
      double? amountPaidIn});
}

/// @nodoc
class __$$StatementModelImplCopyWithImpl<$Res>
    extends _$StatementModelCopyWithImpl<$Res, _$StatementModelImpl>
    implements _$$StatementModelImplCopyWith<$Res> {
  __$$StatementModelImplCopyWithImpl(
      _$StatementModelImpl _value, $Res Function(_$StatementModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statementId = freezed,
    Object? pension = null,
    Object? statementDate = null,
    Object? planValue = null,
    Object? projectedAnnualAmount = null,
    Object? yearlyCharges = freezed,
    Object? transferValue = freezed,
    Object? amountPaidIn = freezed,
  }) {
    return _then(_$StatementModelImpl(
      statementId: freezed == statementId
          ? _value.statementId
          : statementId // ignore: cast_nullable_to_non_nullable
              as int?,
      pension: null == pension
          ? _value.pension
          : pension // ignore: cast_nullable_to_non_nullable
              as int,
      statementDate: null == statementDate
          ? _value.statementDate
          : statementDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      planValue: null == planValue
          ? _value.planValue
          : planValue // ignore: cast_nullable_to_non_nullable
              as double,
      projectedAnnualAmount: null == projectedAnnualAmount
          ? _value.projectedAnnualAmount
          : projectedAnnualAmount // ignore: cast_nullable_to_non_nullable
              as double,
      yearlyCharges: freezed == yearlyCharges
          ? _value.yearlyCharges
          : yearlyCharges // ignore: cast_nullable_to_non_nullable
              as double?,
      transferValue: freezed == transferValue
          ? _value.transferValue
          : transferValue // ignore: cast_nullable_to_non_nullable
              as double?,
      amountPaidIn: freezed == amountPaidIn
          ? _value.amountPaidIn
          : amountPaidIn // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$StatementModelImpl
    with DiagnosticableTreeMixin
    implements _StatementModel {
  const _$StatementModelImpl(
      {this.statementId,
      required this.pension,
      required this.statementDate,
      required this.planValue,
      required this.projectedAnnualAmount,
      this.yearlyCharges,
      this.transferValue,
      this.amountPaidIn});

  factory _$StatementModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$StatementModelImplFromJson(json);

  @override
  final int? statementId;
  @override
  final int pension;
  @override
  final DateTime statementDate;
  @override
  final double planValue;
  @override
  final double projectedAnnualAmount;
  @override
  final double? yearlyCharges;
  @override
  final double? transferValue;
  @override
  final double? amountPaidIn;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'StatementModel(statementId: $statementId, pension: $pension, statementDate: $statementDate, planValue: $planValue, projectedAnnualAmount: $projectedAnnualAmount, yearlyCharges: $yearlyCharges, transferValue: $transferValue, amountPaidIn: $amountPaidIn)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'StatementModel'))
      ..add(DiagnosticsProperty('statementId', statementId))
      ..add(DiagnosticsProperty('pension', pension))
      ..add(DiagnosticsProperty('statementDate', statementDate))
      ..add(DiagnosticsProperty('planValue', planValue))
      ..add(DiagnosticsProperty('projectedAnnualAmount', projectedAnnualAmount))
      ..add(DiagnosticsProperty('yearlyCharges', yearlyCharges))
      ..add(DiagnosticsProperty('transferValue', transferValue))
      ..add(DiagnosticsProperty('amountPaidIn', amountPaidIn));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StatementModelImpl &&
            (identical(other.statementId, statementId) ||
                other.statementId == statementId) &&
            (identical(other.pension, pension) || other.pension == pension) &&
            (identical(other.statementDate, statementDate) ||
                other.statementDate == statementDate) &&
            (identical(other.planValue, planValue) ||
                other.planValue == planValue) &&
            (identical(other.projectedAnnualAmount, projectedAnnualAmount) ||
                other.projectedAnnualAmount == projectedAnnualAmount) &&
            (identical(other.yearlyCharges, yearlyCharges) ||
                other.yearlyCharges == yearlyCharges) &&
            (identical(other.transferValue, transferValue) ||
                other.transferValue == transferValue) &&
            (identical(other.amountPaidIn, amountPaidIn) ||
                other.amountPaidIn == amountPaidIn));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      statementId,
      pension,
      statementDate,
      planValue,
      projectedAnnualAmount,
      yearlyCharges,
      transferValue,
      amountPaidIn);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$StatementModelImplCopyWith<_$StatementModelImpl> get copyWith =>
      __$$StatementModelImplCopyWithImpl<_$StatementModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$StatementModelImplToJson(
      this,
    );
  }
}

abstract class _StatementModel implements StatementModel {
  const factory _StatementModel(
      {final int? statementId,
      required final int pension,
      required final DateTime statementDate,
      required final double planValue,
      required final double projectedAnnualAmount,
      final double? yearlyCharges,
      final double? transferValue,
      final double? amountPaidIn}) = _$StatementModelImpl;

  factory _StatementModel.fromJson(Map<String, dynamic> json) =
      _$StatementModelImpl.fromJson;

  @override
  int? get statementId;
  @override
  int get pension;
  @override
  DateTime get statementDate;
  @override
  double get planValue;
  @override
  double get projectedAnnualAmount;
  @override
  double? get yearlyCharges;
  @override
  double? get transferValue;
  @override
  double? get amountPaidIn;
  @override
  @JsonKey(ignore: true)
  _$$StatementModelImplCopyWith<_$StatementModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
