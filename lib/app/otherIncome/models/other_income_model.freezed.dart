// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'other_income_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

OtherIncomeModel _$OtherIncomeModelFromJson(Map<String, dynamic> json) {
  return _OtherIncomeModel.fromJson(json);
}

/// @nodoc
mixin _$OtherIncomeModel {
  int? get otherIncomeId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get annualAmount => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $OtherIncomeModelCopyWith<OtherIncomeModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OtherIncomeModelCopyWith<$Res> {
  factory $OtherIncomeModelCopyWith(
          OtherIncomeModel value, $Res Function(OtherIncomeModel) then) =
      _$OtherIncomeModelCopyWithImpl<$Res, OtherIncomeModel>;
  @useResult
  $Res call({int? otherIncomeId, String name, double annualAmount});
}

/// @nodoc
class _$OtherIncomeModelCopyWithImpl<$Res, $Val extends OtherIncomeModel>
    implements $OtherIncomeModelCopyWith<$Res> {
  _$OtherIncomeModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otherIncomeId = freezed,
    Object? name = null,
    Object? annualAmount = null,
  }) {
    return _then(_value.copyWith(
      otherIncomeId: freezed == otherIncomeId
          ? _value.otherIncomeId
          : otherIncomeId // ignore: cast_nullable_to_non_nullable
              as int?,
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
abstract class _$$OtherIncomeModelImplCopyWith<$Res>
    implements $OtherIncomeModelCopyWith<$Res> {
  factory _$$OtherIncomeModelImplCopyWith(_$OtherIncomeModelImpl value,
          $Res Function(_$OtherIncomeModelImpl) then) =
      __$$OtherIncomeModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? otherIncomeId, String name, double annualAmount});
}

/// @nodoc
class __$$OtherIncomeModelImplCopyWithImpl<$Res>
    extends _$OtherIncomeModelCopyWithImpl<$Res, _$OtherIncomeModelImpl>
    implements _$$OtherIncomeModelImplCopyWith<$Res> {
  __$$OtherIncomeModelImplCopyWithImpl(_$OtherIncomeModelImpl _value,
      $Res Function(_$OtherIncomeModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? otherIncomeId = freezed,
    Object? name = null,
    Object? annualAmount = null,
  }) {
    return _then(_$OtherIncomeModelImpl(
      otherIncomeId: freezed == otherIncomeId
          ? _value.otherIncomeId
          : otherIncomeId // ignore: cast_nullable_to_non_nullable
              as int?,
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
class _$OtherIncomeModelImpl
    with DiagnosticableTreeMixin
    implements _OtherIncomeModel {
  const _$OtherIncomeModelImpl(
      {this.otherIncomeId, required this.name, required this.annualAmount});

  factory _$OtherIncomeModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$OtherIncomeModelImplFromJson(json);

  @override
  final int? otherIncomeId;
  @override
  final String name;
  @override
  final double annualAmount;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'OtherIncomeModel(otherIncomeId: $otherIncomeId, name: $name, annualAmount: $annualAmount)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'OtherIncomeModel'))
      ..add(DiagnosticsProperty('otherIncomeId', otherIncomeId))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('annualAmount', annualAmount));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OtherIncomeModelImpl &&
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
  _$$OtherIncomeModelImplCopyWith<_$OtherIncomeModelImpl> get copyWith =>
      __$$OtherIncomeModelImplCopyWithImpl<_$OtherIncomeModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OtherIncomeModelImplToJson(
      this,
    );
  }
}

abstract class _OtherIncomeModel implements OtherIncomeModel {
  const factory _OtherIncomeModel(
      {final int? otherIncomeId,
      required final String name,
      required final double annualAmount}) = _$OtherIncomeModelImpl;

  factory _OtherIncomeModel.fromJson(Map<String, dynamic> json) =
      _$OtherIncomeModelImpl.fromJson;

  @override
  int? get otherIncomeId;
  @override
  String get name;
  @override
  double get annualAmount;
  @override
  @JsonKey(ignore: true)
  _$$OtherIncomeModelImplCopyWith<_$OtherIncomeModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
