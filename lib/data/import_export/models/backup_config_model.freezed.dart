// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'backup_config_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

BackupConfigModel _$BackupConfigModelFromJson(Map<String, dynamic> json) {
  return _BackupConfigModel.fromJson(json);
}

/// @nodoc
mixin _$BackupConfigModel {
  DateTime get backupDate => throw _privateConstructorUsedError;
  String get backupVersion => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BackupConfigModelCopyWith<BackupConfigModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BackupConfigModelCopyWith<$Res> {
  factory $BackupConfigModelCopyWith(
          BackupConfigModel value, $Res Function(BackupConfigModel) then) =
      _$BackupConfigModelCopyWithImpl<$Res, BackupConfigModel>;
  @useResult
  $Res call({DateTime backupDate, String backupVersion});
}

/// @nodoc
class _$BackupConfigModelCopyWithImpl<$Res, $Val extends BackupConfigModel>
    implements $BackupConfigModelCopyWith<$Res> {
  _$BackupConfigModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? backupDate = null,
    Object? backupVersion = null,
  }) {
    return _then(_value.copyWith(
      backupDate: null == backupDate
          ? _value.backupDate
          : backupDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      backupVersion: null == backupVersion
          ? _value.backupVersion
          : backupVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BackupConfigModelImplCopyWith<$Res>
    implements $BackupConfigModelCopyWith<$Res> {
  factory _$$BackupConfigModelImplCopyWith(_$BackupConfigModelImpl value,
          $Res Function(_$BackupConfigModelImpl) then) =
      __$$BackupConfigModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({DateTime backupDate, String backupVersion});
}

/// @nodoc
class __$$BackupConfigModelImplCopyWithImpl<$Res>
    extends _$BackupConfigModelCopyWithImpl<$Res, _$BackupConfigModelImpl>
    implements _$$BackupConfigModelImplCopyWith<$Res> {
  __$$BackupConfigModelImplCopyWithImpl(_$BackupConfigModelImpl _value,
      $Res Function(_$BackupConfigModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? backupDate = null,
    Object? backupVersion = null,
  }) {
    return _then(_$BackupConfigModelImpl(
      backupDate: null == backupDate
          ? _value.backupDate
          : backupDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      backupVersion: null == backupVersion
          ? _value.backupVersion
          : backupVersion // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BackupConfigModelImpl
    with DiagnosticableTreeMixin
    implements _BackupConfigModel {
  const _$BackupConfigModelImpl(
      {required this.backupDate, required this.backupVersion});

  factory _$BackupConfigModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$BackupConfigModelImplFromJson(json);

  @override
  final DateTime backupDate;
  @override
  final String backupVersion;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'BackupConfigModel(backupDate: $backupDate, backupVersion: $backupVersion)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'BackupConfigModel'))
      ..add(DiagnosticsProperty('backupDate', backupDate))
      ..add(DiagnosticsProperty('backupVersion', backupVersion));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BackupConfigModelImpl &&
            (identical(other.backupDate, backupDate) ||
                other.backupDate == backupDate) &&
            (identical(other.backupVersion, backupVersion) ||
                other.backupVersion == backupVersion));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, backupDate, backupVersion);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BackupConfigModelImplCopyWith<_$BackupConfigModelImpl> get copyWith =>
      __$$BackupConfigModelImplCopyWithImpl<_$BackupConfigModelImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BackupConfigModelImplToJson(
      this,
    );
  }
}

abstract class _BackupConfigModel implements BackupConfigModel {
  const factory _BackupConfigModel(
      {required final DateTime backupDate,
      required final String backupVersion}) = _$BackupConfigModelImpl;

  factory _BackupConfigModel.fromJson(Map<String, dynamic> json) =
      _$BackupConfigModelImpl.fromJson;

  @override
  DateTime get backupDate;
  @override
  String get backupVersion;
  @override
  @JsonKey(ignore: true)
  _$$BackupConfigModelImplCopyWith<_$BackupConfigModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
