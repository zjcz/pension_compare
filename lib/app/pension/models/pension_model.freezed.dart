// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pension_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PensionModel _$PensionModelFromJson(Map<String, dynamic> json) {
  return _PensionModel.fromJson(json);
}

/// @nodoc
mixin _$PensionModel {
  int? get pensionId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime? get maturityDate => throw _privateConstructorUsedError;
  PensionStatus get status => throw _privateConstructorUsedError;
  DateTime get statusDate => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PensionModelCopyWith<PensionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PensionModelCopyWith<$Res> {
  factory $PensionModelCopyWith(
          PensionModel value, $Res Function(PensionModel) then) =
      _$PensionModelCopyWithImpl<$Res, PensionModel>;
  @useResult
  $Res call(
      {int? pensionId,
      String name,
      DateTime? maturityDate,
      PensionStatus status,
      DateTime statusDate});
}

/// @nodoc
class _$PensionModelCopyWithImpl<$Res, $Val extends PensionModel>
    implements $PensionModelCopyWith<$Res> {
  _$PensionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pensionId = freezed,
    Object? name = null,
    Object? maturityDate = freezed,
    Object? status = null,
    Object? statusDate = null,
  }) {
    return _then(_value.copyWith(
      pensionId: freezed == pensionId
          ? _value.pensionId
          : pensionId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      maturityDate: freezed == maturityDate
          ? _value.maturityDate
          : maturityDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PensionStatus,
      statusDate: null == statusDate
          ? _value.statusDate
          : statusDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PensionModelImplCopyWith<$Res>
    implements $PensionModelCopyWith<$Res> {
  factory _$$PensionModelImplCopyWith(
          _$PensionModelImpl value, $Res Function(_$PensionModelImpl) then) =
      __$$PensionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? pensionId,
      String name,
      DateTime? maturityDate,
      PensionStatus status,
      DateTime statusDate});
}

/// @nodoc
class __$$PensionModelImplCopyWithImpl<$Res>
    extends _$PensionModelCopyWithImpl<$Res, _$PensionModelImpl>
    implements _$$PensionModelImplCopyWith<$Res> {
  __$$PensionModelImplCopyWithImpl(
      _$PensionModelImpl _value, $Res Function(_$PensionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pensionId = freezed,
    Object? name = null,
    Object? maturityDate = freezed,
    Object? status = null,
    Object? statusDate = null,
  }) {
    return _then(_$PensionModelImpl(
      pensionId: freezed == pensionId
          ? _value.pensionId
          : pensionId // ignore: cast_nullable_to_non_nullable
              as int?,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      maturityDate: freezed == maturityDate
          ? _value.maturityDate
          : maturityDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as PensionStatus,
      statusDate: null == statusDate
          ? _value.statusDate
          : statusDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PensionModelImpl with DiagnosticableTreeMixin implements _PensionModel {
  const _$PensionModelImpl(
      {this.pensionId,
      required this.name,
      this.maturityDate,
      required this.status,
      required this.statusDate});

  factory _$PensionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PensionModelImplFromJson(json);

  @override
  final int? pensionId;
  @override
  final String name;
  @override
  final DateTime? maturityDate;
  @override
  final PensionStatus status;
  @override
  final DateTime statusDate;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PensionModel(pensionId: $pensionId, name: $name, maturityDate: $maturityDate, status: $status, statusDate: $statusDate)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PensionModel'))
      ..add(DiagnosticsProperty('pensionId', pensionId))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('maturityDate', maturityDate))
      ..add(DiagnosticsProperty('status', status))
      ..add(DiagnosticsProperty('statusDate', statusDate));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PensionModelImpl &&
            (identical(other.pensionId, pensionId) ||
                other.pensionId == pensionId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.maturityDate, maturityDate) ||
                other.maturityDate == maturityDate) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.statusDate, statusDate) ||
                other.statusDate == statusDate));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, pensionId, name, maturityDate, status, statusDate);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PensionModelImplCopyWith<_$PensionModelImpl> get copyWith =>
      __$$PensionModelImplCopyWithImpl<_$PensionModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PensionModelImplToJson(
      this,
    );
  }
}

abstract class _PensionModel implements PensionModel {
  const factory _PensionModel(
      {final int? pensionId,
      required final String name,
      final DateTime? maturityDate,
      required final PensionStatus status,
      required final DateTime statusDate}) = _$PensionModelImpl;

  factory _PensionModel.fromJson(Map<String, dynamic> json) =
      _$PensionModelImpl.fromJson;

  @override
  int? get pensionId;
  @override
  String get name;
  @override
  DateTime? get maturityDate;
  @override
  PensionStatus get status;
  @override
  DateTime get statusDate;
  @override
  @JsonKey(ignore: true)
  _$$PensionModelImplCopyWith<_$PensionModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
