// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_statement_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransferStatementModel _$TransferStatementModelFromJson(
    Map<String, dynamic> json) {
  return _TransferStatementModel.fromJson(json);
}

/// @nodoc
mixin _$TransferStatementModel {
  int get statementId => throw _privateConstructorUsedError;
  DateTime get statementDate => throw _privateConstructorUsedError;
  double get planValue => throw _privateConstructorUsedError;
  double get projectedAnnualAmount => throw _privateConstructorUsedError;
  double? get yearlyCharges => throw _privateConstructorUsedError;
  double? get transferValue => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransferStatementModelCopyWith<TransferStatementModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferStatementModelCopyWith<$Res> {
  factory $TransferStatementModelCopyWith(TransferStatementModel value,
          $Res Function(TransferStatementModel) then) =
      _$TransferStatementModelCopyWithImpl<$Res, TransferStatementModel>;
  @useResult
  $Res call(
      {int statementId,
      DateTime statementDate,
      double planValue,
      double projectedAnnualAmount,
      double? yearlyCharges,
      double? transferValue});
}

/// @nodoc
class _$TransferStatementModelCopyWithImpl<$Res,
        $Val extends TransferStatementModel>
    implements $TransferStatementModelCopyWith<$Res> {
  _$TransferStatementModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statementId = null,
    Object? statementDate = null,
    Object? planValue = null,
    Object? projectedAnnualAmount = null,
    Object? yearlyCharges = freezed,
    Object? transferValue = freezed,
  }) {
    return _then(_value.copyWith(
      statementId: null == statementId
          ? _value.statementId
          : statementId // ignore: cast_nullable_to_non_nullable
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransferStatementModelImplCopyWith<$Res>
    implements $TransferStatementModelCopyWith<$Res> {
  factory _$$TransferStatementModelImplCopyWith(
          _$TransferStatementModelImpl value,
          $Res Function(_$TransferStatementModelImpl) then) =
      __$$TransferStatementModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int statementId,
      DateTime statementDate,
      double planValue,
      double projectedAnnualAmount,
      double? yearlyCharges,
      double? transferValue});
}

/// @nodoc
class __$$TransferStatementModelImplCopyWithImpl<$Res>
    extends _$TransferStatementModelCopyWithImpl<$Res,
        _$TransferStatementModelImpl>
    implements _$$TransferStatementModelImplCopyWith<$Res> {
  __$$TransferStatementModelImplCopyWithImpl(
      _$TransferStatementModelImpl _value,
      $Res Function(_$TransferStatementModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? statementId = null,
    Object? statementDate = null,
    Object? planValue = null,
    Object? projectedAnnualAmount = null,
    Object? yearlyCharges = freezed,
    Object? transferValue = freezed,
  }) {
    return _then(_$TransferStatementModelImpl(
      statementId: null == statementId
          ? _value.statementId
          : statementId // ignore: cast_nullable_to_non_nullable
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferStatementModelImpl
    with DiagnosticableTreeMixin
    implements _TransferStatementModel {
  const _$TransferStatementModelImpl(
      {required this.statementId,
      required this.statementDate,
      required this.planValue,
      required this.projectedAnnualAmount,
      this.yearlyCharges,
      this.transferValue});

  factory _$TransferStatementModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferStatementModelImplFromJson(json);

  @override
  final int statementId;
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
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TransferStatementModel(statementId: $statementId, statementDate: $statementDate, planValue: $planValue, projectedAnnualAmount: $projectedAnnualAmount, yearlyCharges: $yearlyCharges, transferValue: $transferValue)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'TransferStatementModel'))
      ..add(DiagnosticsProperty('statementId', statementId))
      ..add(DiagnosticsProperty('statementDate', statementDate))
      ..add(DiagnosticsProperty('planValue', planValue))
      ..add(DiagnosticsProperty('projectedAnnualAmount', projectedAnnualAmount))
      ..add(DiagnosticsProperty('yearlyCharges', yearlyCharges))
      ..add(DiagnosticsProperty('transferValue', transferValue));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferStatementModelImpl &&
            (identical(other.statementId, statementId) ||
                other.statementId == statementId) &&
            (identical(other.statementDate, statementDate) ||
                other.statementDate == statementDate) &&
            (identical(other.planValue, planValue) ||
                other.planValue == planValue) &&
            (identical(other.projectedAnnualAmount, projectedAnnualAmount) ||
                other.projectedAnnualAmount == projectedAnnualAmount) &&
            (identical(other.yearlyCharges, yearlyCharges) ||
                other.yearlyCharges == yearlyCharges) &&
            (identical(other.transferValue, transferValue) ||
                other.transferValue == transferValue));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, statementId, statementDate,
      planValue, projectedAnnualAmount, yearlyCharges, transferValue);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferStatementModelImplCopyWith<_$TransferStatementModelImpl>
      get copyWith => __$$TransferStatementModelImplCopyWithImpl<
          _$TransferStatementModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferStatementModelImplToJson(
      this,
    );
  }
}

abstract class _TransferStatementModel implements TransferStatementModel {
  const factory _TransferStatementModel(
      {required final int statementId,
      required final DateTime statementDate,
      required final double planValue,
      required final double projectedAnnualAmount,
      final double? yearlyCharges,
      final double? transferValue}) = _$TransferStatementModelImpl;

  factory _TransferStatementModel.fromJson(Map<String, dynamic> json) =
      _$TransferStatementModelImpl.fromJson;

  @override
  int get statementId;
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
  @JsonKey(ignore: true)
  _$$TransferStatementModelImplCopyWith<_$TransferStatementModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
