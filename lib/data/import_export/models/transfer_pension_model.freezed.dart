// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_pension_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransferPensionModel _$TransferPensionModelFromJson(Map<String, dynamic> json) {
  return _TransferPensionModel.fromJson(json);
}

/// @nodoc
mixin _$TransferPensionModel {
  int get pensionId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get maturityDate => throw _privateConstructorUsedError;
  List<TransferStatementModel> get statements =>
      throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransferPensionModelCopyWith<TransferPensionModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferPensionModelCopyWith<$Res> {
  factory $TransferPensionModelCopyWith(TransferPensionModel value,
          $Res Function(TransferPensionModel) then) =
      _$TransferPensionModelCopyWithImpl<$Res, TransferPensionModel>;
  @useResult
  $Res call(
      {int pensionId,
      String name,
      DateTime maturityDate,
      List<TransferStatementModel> statements,
      String? notes});
}

/// @nodoc
class _$TransferPensionModelCopyWithImpl<$Res,
        $Val extends TransferPensionModel>
    implements $TransferPensionModelCopyWith<$Res> {
  _$TransferPensionModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pensionId = null,
    Object? name = null,
    Object? maturityDate = null,
    Object? statements = null,
    Object? notes = freezed,
  }) {
    return _then(_value.copyWith(
      pensionId: null == pensionId
          ? _value.pensionId
          : pensionId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      maturityDate: null == maturityDate
          ? _value.maturityDate
          : maturityDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      statements: null == statements
          ? _value.statements
          : statements // ignore: cast_nullable_to_non_nullable
              as List<TransferStatementModel>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransferPensionModelImplCopyWith<$Res>
    implements $TransferPensionModelCopyWith<$Res> {
  factory _$$TransferPensionModelImplCopyWith(_$TransferPensionModelImpl value,
          $Res Function(_$TransferPensionModelImpl) then) =
      __$$TransferPensionModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int pensionId,
      String name,
      DateTime maturityDate,
      List<TransferStatementModel> statements,
      String? notes});
}

/// @nodoc
class __$$TransferPensionModelImplCopyWithImpl<$Res>
    extends _$TransferPensionModelCopyWithImpl<$Res, _$TransferPensionModelImpl>
    implements _$$TransferPensionModelImplCopyWith<$Res> {
  __$$TransferPensionModelImplCopyWithImpl(_$TransferPensionModelImpl _value,
      $Res Function(_$TransferPensionModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pensionId = null,
    Object? name = null,
    Object? maturityDate = null,
    Object? statements = null,
    Object? notes = freezed,
  }) {
    return _then(_$TransferPensionModelImpl(
      pensionId: null == pensionId
          ? _value.pensionId
          : pensionId // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      maturityDate: null == maturityDate
          ? _value.maturityDate
          : maturityDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      statements: null == statements
          ? _value._statements
          : statements // ignore: cast_nullable_to_non_nullable
              as List<TransferStatementModel>,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferPensionModelImpl
    with DiagnosticableTreeMixin
    implements _TransferPensionModel {
  const _$TransferPensionModelImpl(
      {required this.pensionId,
      required this.name,
      required this.maturityDate,
      required final List<TransferStatementModel> statements,
      this.notes})
      : _statements = statements;

  factory _$TransferPensionModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferPensionModelImplFromJson(json);

  @override
  final int pensionId;
  @override
  final String name;
  @override
  final DateTime maturityDate;
  final List<TransferStatementModel> _statements;
  @override
  List<TransferStatementModel> get statements {
    if (_statements is EqualUnmodifiableListView) return _statements;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_statements);
  }

  @override
  final String? notes;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TransferPensionModel(pensionId: $pensionId, name: $name, maturityDate: $maturityDate, statements: $statements, notes: $notes)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'TransferPensionModel'))
      ..add(DiagnosticsProperty('pensionId', pensionId))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('maturityDate', maturityDate))
      ..add(DiagnosticsProperty('statements', statements))
      ..add(DiagnosticsProperty('notes', notes));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferPensionModelImpl &&
            (identical(other.pensionId, pensionId) ||
                other.pensionId == pensionId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.maturityDate, maturityDate) ||
                other.maturityDate == maturityDate) &&
            const DeepCollectionEquality()
                .equals(other._statements, _statements) &&
            (identical(other.notes, notes) || other.notes == notes));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, pensionId, name, maturityDate,
      const DeepCollectionEquality().hash(_statements), notes);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferPensionModelImplCopyWith<_$TransferPensionModelImpl>
      get copyWith =>
          __$$TransferPensionModelImplCopyWithImpl<_$TransferPensionModelImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferPensionModelImplToJson(
      this,
    );
  }
}

abstract class _TransferPensionModel implements TransferPensionModel {
  const factory _TransferPensionModel(
      {required final int pensionId,
      required final String name,
      required final DateTime maturityDate,
      required final List<TransferStatementModel> statements,
      final String? notes}) = _$TransferPensionModelImpl;

  factory _TransferPensionModel.fromJson(Map<String, dynamic> json) =
      _$TransferPensionModelImpl.fromJson;

  @override
  int get pensionId;
  @override
  String get name;
  @override
  DateTime get maturityDate;
  @override
  List<TransferStatementModel> get statements;
  @override
  String? get notes;
  @override
  @JsonKey(ignore: true)
  _$$TransferPensionModelImplCopyWith<_$TransferPensionModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
