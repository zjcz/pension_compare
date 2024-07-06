// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'secure_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SecureSettingsModel _$SecureSettingsModelFromJson(Map<String, dynamic> json) {
  return _SecureSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$SecureSettingsModel {
  double? get targetIncome => throw _privateConstructorUsedError;
  DateTime? get retirementDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SecureSettingsModelCopyWith<SecureSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SecureSettingsModelCopyWith<$Res> {
  factory $SecureSettingsModelCopyWith(
          SecureSettingsModel value, $Res Function(SecureSettingsModel) then) =
      _$SecureSettingsModelCopyWithImpl<$Res, SecureSettingsModel>;
  @useResult
  $Res call({double? targetIncome, DateTime? retirementDate});
}

/// @nodoc
class _$SecureSettingsModelCopyWithImpl<$Res, $Val extends SecureSettingsModel>
    implements $SecureSettingsModelCopyWith<$Res> {
  _$SecureSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetIncome = freezed,
    Object? retirementDate = freezed,
  }) {
    return _then(_value.copyWith(
      targetIncome: freezed == targetIncome
          ? _value.targetIncome
          : targetIncome // ignore: cast_nullable_to_non_nullable
              as double?,
      retirementDate: freezed == retirementDate
          ? _value.retirementDate
          : retirementDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SecureSettingsModelImplCopyWith<$Res>
    implements $SecureSettingsModelCopyWith<$Res> {
  factory _$$SecureSettingsModelImplCopyWith(_$SecureSettingsModelImpl value,
          $Res Function(_$SecureSettingsModelImpl) then) =
      __$$SecureSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({double? targetIncome, DateTime? retirementDate});
}

/// @nodoc
class __$$SecureSettingsModelImplCopyWithImpl<$Res>
    extends _$SecureSettingsModelCopyWithImpl<$Res, _$SecureSettingsModelImpl>
    implements _$$SecureSettingsModelImplCopyWith<$Res> {
  __$$SecureSettingsModelImplCopyWithImpl(_$SecureSettingsModelImpl _value,
      $Res Function(_$SecureSettingsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? targetIncome = freezed,
    Object? retirementDate = freezed,
  }) {
    return _then(_$SecureSettingsModelImpl(
      targetIncome: freezed == targetIncome
          ? _value.targetIncome
          : targetIncome // ignore: cast_nullable_to_non_nullable
              as double?,
      retirementDate: freezed == retirementDate
          ? _value.retirementDate
          : retirementDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SecureSettingsModelImpl
    with DiagnosticableTreeMixin
    implements _SecureSettingsModel {
  const _$SecureSettingsModelImpl(
      {required this.targetIncome, required this.retirementDate});

  factory _$SecureSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$SecureSettingsModelImplFromJson(json);

  @override
  final double? targetIncome;
  @override
  final DateTime? retirementDate;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'SecureSettingsModel(targetIncome: $targetIncome, retirementDate: $retirementDate)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'SecureSettingsModel'))
      ..add(DiagnosticsProperty('targetIncome', targetIncome))
      ..add(DiagnosticsProperty('retirementDate', retirementDate));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SecureSettingsModelImpl &&
            (identical(other.targetIncome, targetIncome) ||
                other.targetIncome == targetIncome) &&
            (identical(other.retirementDate, retirementDate) ||
                other.retirementDate == retirementDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, targetIncome, retirementDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SecureSettingsModelImplCopyWith<_$SecureSettingsModelImpl> get copyWith =>
      __$$SecureSettingsModelImplCopyWithImpl<_$SecureSettingsModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SecureSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _SecureSettingsModel implements SecureSettingsModel {
  const factory _SecureSettingsModel(
      {required final double? targetIncome,
      required final DateTime? retirementDate}) = _$SecureSettingsModelImpl;

  factory _SecureSettingsModel.fromJson(Map<String, dynamic> json) =
      _$SecureSettingsModelImpl.fromJson;

  @override
  double? get targetIncome;
  @override
  DateTime? get retirementDate;
  @override
  @JsonKey(ignore: true)
  _$$SecureSettingsModelImplCopyWith<_$SecureSettingsModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
