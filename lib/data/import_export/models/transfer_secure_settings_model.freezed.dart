// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_secure_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransferSecureSettingsModel _$TransferSecureSettingsModelFromJson(
    Map<String, dynamic> json) {
  return _TransferSecureSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$TransferSecureSettingsModel {
  DateTime? get retirementDate => throw _privateConstructorUsedError;
  double? get targetIncome => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransferSecureSettingsModelCopyWith<TransferSecureSettingsModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferSecureSettingsModelCopyWith<$Res> {
  factory $TransferSecureSettingsModelCopyWith(
          TransferSecureSettingsModel value,
          $Res Function(TransferSecureSettingsModel) then) =
      _$TransferSecureSettingsModelCopyWithImpl<$Res,
          TransferSecureSettingsModel>;
  @useResult
  $Res call({DateTime? retirementDate, double? targetIncome});
}

/// @nodoc
class _$TransferSecureSettingsModelCopyWithImpl<$Res,
        $Val extends TransferSecureSettingsModel>
    implements $TransferSecureSettingsModelCopyWith<$Res> {
  _$TransferSecureSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? retirementDate = freezed,
    Object? targetIncome = freezed,
  }) {
    return _then(_value.copyWith(
      retirementDate: freezed == retirementDate
          ? _value.retirementDate
          : retirementDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      targetIncome: freezed == targetIncome
          ? _value.targetIncome
          : targetIncome // ignore: cast_nullable_to_non_nullable
              as double?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransferSecureSettingsModelImplCopyWith<$Res>
    implements $TransferSecureSettingsModelCopyWith<$Res> {
  factory _$$TransferSecureSettingsModelImplCopyWith(
          _$TransferSecureSettingsModelImpl value,
          $Res Function(_$TransferSecureSettingsModelImpl) then) =
      __$$TransferSecureSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime? retirementDate, double? targetIncome});
}

/// @nodoc
class __$$TransferSecureSettingsModelImplCopyWithImpl<$Res>
    extends _$TransferSecureSettingsModelCopyWithImpl<$Res,
        _$TransferSecureSettingsModelImpl>
    implements _$$TransferSecureSettingsModelImplCopyWith<$Res> {
  __$$TransferSecureSettingsModelImplCopyWithImpl(
      _$TransferSecureSettingsModelImpl _value,
      $Res Function(_$TransferSecureSettingsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? retirementDate = freezed,
    Object? targetIncome = freezed,
  }) {
    return _then(_$TransferSecureSettingsModelImpl(
      retirementDate: freezed == retirementDate
          ? _value.retirementDate
          : retirementDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      targetIncome: freezed == targetIncome
          ? _value.targetIncome
          : targetIncome // ignore: cast_nullable_to_non_nullable
              as double?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferSecureSettingsModelImpl
    with DiagnosticableTreeMixin
    implements _TransferSecureSettingsModel {
  const _$TransferSecureSettingsModelImpl(
      {required this.retirementDate, required this.targetIncome});

  factory _$TransferSecureSettingsModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$TransferSecureSettingsModelImplFromJson(json);

  @override
  final DateTime? retirementDate;
  @override
  final double? targetIncome;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TransferSecureSettingsModel(retirementDate: $retirementDate, targetIncome: $targetIncome)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'TransferSecureSettingsModel'))
      ..add(DiagnosticsProperty('retirementDate', retirementDate))
      ..add(DiagnosticsProperty('targetIncome', targetIncome));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferSecureSettingsModelImpl &&
            (identical(other.retirementDate, retirementDate) ||
                other.retirementDate == retirementDate) &&
            (identical(other.targetIncome, targetIncome) ||
                other.targetIncome == targetIncome));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, retirementDate, targetIncome);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferSecureSettingsModelImplCopyWith<_$TransferSecureSettingsModelImpl>
      get copyWith => __$$TransferSecureSettingsModelImplCopyWithImpl<
          _$TransferSecureSettingsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferSecureSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _TransferSecureSettingsModel
    implements TransferSecureSettingsModel {
  const factory _TransferSecureSettingsModel(
      {required final DateTime? retirementDate,
      required final double? targetIncome}) = _$TransferSecureSettingsModelImpl;

  factory _TransferSecureSettingsModel.fromJson(Map<String, dynamic> json) =
      _$TransferSecureSettingsModelImpl.fromJson;

  @override
  DateTime? get retirementDate;
  @override
  double? get targetIncome;
  @override
  @JsonKey(ignore: true)
  _$$TransferSecureSettingsModelImplCopyWith<_$TransferSecureSettingsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
