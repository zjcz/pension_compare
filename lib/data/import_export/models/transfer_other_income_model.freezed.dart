// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_other_income_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransferOtherIncomeModel _$TransferOtherIncomeModelFromJson(
    Map<String, dynamic> json) {
  return _TransferOtherIncomeModel.fromJson(json);
}

/// @nodoc
mixin _$TransferOtherIncomeModel {
  int get otherIncomeId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get annualAmount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransferOtherIncomeModelCopyWith<TransferOtherIncomeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferOtherIncomeModelCopyWith<$Res> {
  factory $TransferOtherIncomeModelCopyWith(TransferOtherIncomeModel value,
          $Res Function(TransferOtherIncomeModel) then) =
      _$TransferOtherIncomeModelCopyWithImpl<$Res, TransferOtherIncomeModel>;
  @useResult
  $Res call({int otherIncomeId, String name, double annualAmount});
}

/// @nodoc
class _$TransferOtherIncomeModelCopyWithImpl<$Res,
        $Val extends TransferOtherIncomeModel>
    implements $TransferOtherIncomeModelCopyWith<$Res> {
  _$TransferOtherIncomeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otherIncomeId = null,
    Object? name = null,
    Object? annualAmount = null,
  }) {
    return _then(_value.copyWith(
      otherIncomeId: null == otherIncomeId
          ? _value.otherIncomeId
          : otherIncomeId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      annualAmount: null == annualAmount
          ? _value.annualAmount
          : annualAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransferOtherIncomeModelImplCopyWith<$Res>
    implements $TransferOtherIncomeModelCopyWith<$Res> {
  factory _$$TransferOtherIncomeModelImplCopyWith(
          _$TransferOtherIncomeModelImpl value,
          $Res Function(_$TransferOtherIncomeModelImpl) then) =
      __$$TransferOtherIncomeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int otherIncomeId, String name, double annualAmount});
}

/// @nodoc
class __$$TransferOtherIncomeModelImplCopyWithImpl<$Res>
    extends _$TransferOtherIncomeModelCopyWithImpl<$Res,
        _$TransferOtherIncomeModelImpl>
    implements _$$TransferOtherIncomeModelImplCopyWith<$Res> {
  __$$TransferOtherIncomeModelImplCopyWithImpl(
      _$TransferOtherIncomeModelImpl _value,
      $Res Function(_$TransferOtherIncomeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otherIncomeId = null,
    Object? name = null,
    Object? annualAmount = null,
  }) {
    return _then(_$TransferOtherIncomeModelImpl(
      otherIncomeId: null == otherIncomeId
          ? _value.otherIncomeId
          : otherIncomeId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      annualAmount: null == annualAmount
          ? _value.annualAmount
          : annualAmount // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferOtherIncomeModelImpl
    with DiagnosticableTreeMixin
    implements _TransferOtherIncomeModel {
  const _$TransferOtherIncomeModelImpl(
      {required this.otherIncomeId,
      required this.name,
      required this.annualAmount});

  factory _$TransferOtherIncomeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferOtherIncomeModelImplFromJson(json);

  @override
  final int otherIncomeId;
  @override
  final String name;
  @override
  final double annualAmount;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TransferOtherIncomeModel(otherIncomeId: $otherIncomeId, name: $name, annualAmount: $annualAmount)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'TransferOtherIncomeModel'))
      ..add(DiagnosticsProperty('otherIncomeId', otherIncomeId))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('annualAmount', annualAmount));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferOtherIncomeModelImpl &&
            (identical(other.otherIncomeId, otherIncomeId) ||
                other.otherIncomeId == otherIncomeId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.annualAmount, annualAmount) ||
                other.annualAmount == annualAmount));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, otherIncomeId, name, annualAmount);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferOtherIncomeModelImplCopyWith<_$TransferOtherIncomeModelImpl>
      get copyWith => __$$TransferOtherIncomeModelImplCopyWithImpl<
          _$TransferOtherIncomeModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferOtherIncomeModelImplToJson(
      this,
    );
  }
}

abstract class _TransferOtherIncomeModel implements TransferOtherIncomeModel {
  const factory _TransferOtherIncomeModel(
      {required final int otherIncomeId,
      required final String name,
      required final double annualAmount}) = _$TransferOtherIncomeModelImpl;

  factory _TransferOtherIncomeModel.fromJson(Map<String, dynamic> json) =
      _$TransferOtherIncomeModelImpl.fromJson;

  @override
  int get otherIncomeId;
  @override
  String get name;
  @override
  double get annualAmount;
  @override
  @JsonKey(ignore: true)
  _$$TransferOtherIncomeModelImplCopyWith<_$TransferOtherIncomeModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
