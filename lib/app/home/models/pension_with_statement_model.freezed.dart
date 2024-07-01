// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pension_with_statement_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PensionWithStatementModel _$PensionWithStatementModelFromJson(
    Map<String, dynamic> json) {
  return _PensionWithStatementModel.fromJson(json);
}

/// @nodoc
mixin _$PensionWithStatementModel {
  PensionModel get pension => throw _privateConstructorUsedError;
  StatementModel? get statement => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PensionWithStatementModelCopyWith<PensionWithStatementModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PensionWithStatementModelCopyWith<$Res> {
  factory $PensionWithStatementModelCopyWith(PensionWithStatementModel value,
          $Res Function(PensionWithStatementModel) then) =
      _$PensionWithStatementModelCopyWithImpl<$Res, PensionWithStatementModel>;
  @useResult
  $Res call({PensionModel pension, StatementModel? statement});

  $PensionModelCopyWith<$Res> get pension;
  $StatementModelCopyWith<$Res>? get statement;
}

/// @nodoc
class _$PensionWithStatementModelCopyWithImpl<$Res,
        $Val extends PensionWithStatementModel>
    implements $PensionWithStatementModelCopyWith<$Res> {
  _$PensionWithStatementModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pension = null,
    Object? statement = freezed,
  }) {
    return _then(_value.copyWith(
      pension: null == pension
          ? _value.pension
          : pension // ignore: cast_nullable_to_non_nullable
              as PensionModel,
      statement: freezed == statement
          ? _value.statement
          : statement // ignore: cast_nullable_to_non_nullable
              as StatementModel?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PensionModelCopyWith<$Res> get pension {
    return $PensionModelCopyWith<$Res>(_value.pension, (value) {
      return _then(_value.copyWith(pension: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $StatementModelCopyWith<$Res>? get statement {
    if (_value.statement == null) {
      return null;
    }

    return $StatementModelCopyWith<$Res>(_value.statement!, (value) {
      return _then(_value.copyWith(statement: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PensionWithStatementModelImplCopyWith<$Res>
    implements $PensionWithStatementModelCopyWith<$Res> {
  factory _$$PensionWithStatementModelImplCopyWith(
          _$PensionWithStatementModelImpl value,
          $Res Function(_$PensionWithStatementModelImpl) then) =
      __$$PensionWithStatementModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PensionModel pension, StatementModel? statement});

  @override
  $PensionModelCopyWith<$Res> get pension;
  @override
  $StatementModelCopyWith<$Res>? get statement;
}

/// @nodoc
class __$$PensionWithStatementModelImplCopyWithImpl<$Res>
    extends _$PensionWithStatementModelCopyWithImpl<$Res,
        _$PensionWithStatementModelImpl>
    implements _$$PensionWithStatementModelImplCopyWith<$Res> {
  __$$PensionWithStatementModelImplCopyWithImpl(
      _$PensionWithStatementModelImpl _value,
      $Res Function(_$PensionWithStatementModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pension = null,
    Object? statement = freezed,
  }) {
    return _then(_$PensionWithStatementModelImpl(
      pension: null == pension
          ? _value.pension
          : pension // ignore: cast_nullable_to_non_nullable
              as PensionModel,
      statement: freezed == statement
          ? _value.statement
          : statement // ignore: cast_nullable_to_non_nullable
              as StatementModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PensionWithStatementModelImpl
    with DiagnosticableTreeMixin
    implements _PensionWithStatementModel {
  const _$PensionWithStatementModelImpl(
      {required this.pension, this.statement});

  factory _$PensionWithStatementModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$PensionWithStatementModelImplFromJson(json);

  @override
  final PensionModel pension;
  @override
  final StatementModel? statement;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PensionWithStatementModel(pension: $pension, statement: $statement)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PensionWithStatementModel'))
      ..add(DiagnosticsProperty('pension', pension))
      ..add(DiagnosticsProperty('statement', statement));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PensionWithStatementModelImpl &&
            (identical(other.pension, pension) || other.pension == pension) &&
            (identical(other.statement, statement) ||
                other.statement == statement));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, pension, statement);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PensionWithStatementModelImplCopyWith<_$PensionWithStatementModelImpl>
      get copyWith => __$$PensionWithStatementModelImplCopyWithImpl<
          _$PensionWithStatementModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PensionWithStatementModelImplToJson(
      this,
    );
  }
}

abstract class _PensionWithStatementModel implements PensionWithStatementModel {
  const factory _PensionWithStatementModel(
      {required final PensionModel pension,
      final StatementModel? statement}) = _$PensionWithStatementModelImpl;

  factory _PensionWithStatementModel.fromJson(Map<String, dynamic> json) =
      _$PensionWithStatementModelImpl.fromJson;

  @override
  PensionModel get pension;
  @override
  StatementModel? get statement;
  @override
  @JsonKey(ignore: true)
  _$$PensionWithStatementModelImplCopyWith<_$PensionWithStatementModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
