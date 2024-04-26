// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pension_with_latest_statement_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PensionWithLatestStatementModel _$PensionWithLatestStatementModelFromJson(
    Map<String, dynamic> json) {
  return _PensionWithLatestStatementModel.fromJson(json);
}

/// @nodoc
mixin _$PensionWithLatestStatementModel {
  PensionModel get pension => throw _privateConstructorUsedError;
  StatementModel? get latestStatement => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PensionWithLatestStatementModelCopyWith<PensionWithLatestStatementModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PensionWithLatestStatementModelCopyWith<$Res> {
  factory $PensionWithLatestStatementModelCopyWith(
          PensionWithLatestStatementModel value,
          $Res Function(PensionWithLatestStatementModel) then) =
      _$PensionWithLatestStatementModelCopyWithImpl<$Res,
          PensionWithLatestStatementModel>;
  @useResult
  $Res call({PensionModel pension, StatementModel? latestStatement});

  $PensionModelCopyWith<$Res> get pension;
  $StatementModelCopyWith<$Res>? get latestStatement;
}

/// @nodoc
class _$PensionWithLatestStatementModelCopyWithImpl<$Res,
        $Val extends PensionWithLatestStatementModel>
    implements $PensionWithLatestStatementModelCopyWith<$Res> {
  _$PensionWithLatestStatementModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pension = null,
    Object? latestStatement = freezed,
  }) {
    return _then(_value.copyWith(
      pension: null == pension
          ? _value.pension
          : pension // ignore: cast_nullable_to_non_nullable
              as PensionModel,
      latestStatement: freezed == latestStatement
          ? _value.latestStatement
          : latestStatement // ignore: cast_nullable_to_non_nullable
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
  $StatementModelCopyWith<$Res>? get latestStatement {
    if (_value.latestStatement == null) {
      return null;
    }

    return $StatementModelCopyWith<$Res>(_value.latestStatement!, (value) {
      return _then(_value.copyWith(latestStatement: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PensionWithLatestStatementModelImplCopyWith<$Res>
    implements $PensionWithLatestStatementModelCopyWith<$Res> {
  factory _$$PensionWithLatestStatementModelImplCopyWith(
          _$PensionWithLatestStatementModelImpl value,
          $Res Function(_$PensionWithLatestStatementModelImpl) then) =
      __$$PensionWithLatestStatementModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({PensionModel pension, StatementModel? latestStatement});

  @override
  $PensionModelCopyWith<$Res> get pension;
  @override
  $StatementModelCopyWith<$Res>? get latestStatement;
}

/// @nodoc
class __$$PensionWithLatestStatementModelImplCopyWithImpl<$Res>
    extends _$PensionWithLatestStatementModelCopyWithImpl<$Res,
        _$PensionWithLatestStatementModelImpl>
    implements _$$PensionWithLatestStatementModelImplCopyWith<$Res> {
  __$$PensionWithLatestStatementModelImplCopyWithImpl(
      _$PensionWithLatestStatementModelImpl _value,
      $Res Function(_$PensionWithLatestStatementModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? pension = null,
    Object? latestStatement = freezed,
  }) {
    return _then(_$PensionWithLatestStatementModelImpl(
      pension: null == pension
          ? _value.pension
          : pension // ignore: cast_nullable_to_non_nullable
              as PensionModel,
      latestStatement: freezed == latestStatement
          ? _value.latestStatement
          : latestStatement // ignore: cast_nullable_to_non_nullable
              as StatementModel?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PensionWithLatestStatementModelImpl
    with DiagnosticableTreeMixin
    implements _PensionWithLatestStatementModel {
  const _$PensionWithLatestStatementModelImpl(
      {required this.pension, this.latestStatement});

  factory _$PensionWithLatestStatementModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$PensionWithLatestStatementModelImplFromJson(json);

  @override
  final PensionModel pension;
  @override
  final StatementModel? latestStatement;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'PensionWithLatestStatementModel(pension: $pension, latestStatement: $latestStatement)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'PensionWithLatestStatementModel'))
      ..add(DiagnosticsProperty('pension', pension))
      ..add(DiagnosticsProperty('latestStatement', latestStatement));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PensionWithLatestStatementModelImpl &&
            (identical(other.pension, pension) || other.pension == pension) &&
            (identical(other.latestStatement, latestStatement) ||
                other.latestStatement == latestStatement));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, pension, latestStatement);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PensionWithLatestStatementModelImplCopyWith<
          _$PensionWithLatestStatementModelImpl>
      get copyWith => __$$PensionWithLatestStatementModelImplCopyWithImpl<
          _$PensionWithLatestStatementModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PensionWithLatestStatementModelImplToJson(
      this,
    );
  }
}

abstract class _PensionWithLatestStatementModel
    implements PensionWithLatestStatementModel {
  const factory _PensionWithLatestStatementModel(
          {required final PensionModel pension,
          final StatementModel? latestStatement}) =
      _$PensionWithLatestStatementModelImpl;

  factory _PensionWithLatestStatementModel.fromJson(Map<String, dynamic> json) =
      _$PensionWithLatestStatementModelImpl.fromJson;

  @override
  PensionModel get pension;
  @override
  StatementModel? get latestStatement;
  @override
  @JsonKey(ignore: true)
  _$$PensionWithLatestStatementModelImplCopyWith<
          _$PensionWithLatestStatementModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
