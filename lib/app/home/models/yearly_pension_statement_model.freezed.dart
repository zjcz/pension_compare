// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'yearly_pension_statement_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

YearlyPensionStatementModel _$YearlyPensionStatementModelFromJson(
    Map<String, dynamic> json) {
  return _YearlyPensionStatementModel.fromJson(json);
}

/// @nodoc
mixin _$YearlyPensionStatementModel {
  int get year => throw _privateConstructorUsedError;
  List<PensionWithStatementModel> get pensionWithStatement =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $YearlyPensionStatementModelCopyWith<YearlyPensionStatementModel>
      get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $YearlyPensionStatementModelCopyWith<$Res> {
  factory $YearlyPensionStatementModelCopyWith(
          YearlyPensionStatementModel value,
          $Res Function(YearlyPensionStatementModel) then) =
      _$YearlyPensionStatementModelCopyWithImpl<$Res,
          YearlyPensionStatementModel>;
  @useResult
  $Res call({int year, List<PensionWithStatementModel> pensionWithStatement});
}

/// @nodoc
class _$YearlyPensionStatementModelCopyWithImpl<$Res,
        $Val extends YearlyPensionStatementModel>
    implements $YearlyPensionStatementModelCopyWith<$Res> {
  _$YearlyPensionStatementModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? pensionWithStatement = null,
  }) {
    return _then(_value.copyWith(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      pensionWithStatement: null == pensionWithStatement
          ? _value.pensionWithStatement
          : pensionWithStatement // ignore: cast_nullable_to_non_nullable
              as List<PensionWithStatementModel>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$YearlyPensionStatementModelImplCopyWith<$Res>
    implements $YearlyPensionStatementModelCopyWith<$Res> {
  factory _$$YearlyPensionStatementModelImplCopyWith(
          _$YearlyPensionStatementModelImpl value,
          $Res Function(_$YearlyPensionStatementModelImpl) then) =
      __$$YearlyPensionStatementModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int year, List<PensionWithStatementModel> pensionWithStatement});
}

/// @nodoc
class __$$YearlyPensionStatementModelImplCopyWithImpl<$Res>
    extends _$YearlyPensionStatementModelCopyWithImpl<$Res,
        _$YearlyPensionStatementModelImpl>
    implements _$$YearlyPensionStatementModelImplCopyWith<$Res> {
  __$$YearlyPensionStatementModelImplCopyWithImpl(
      _$YearlyPensionStatementModelImpl _value,
      $Res Function(_$YearlyPensionStatementModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? year = null,
    Object? pensionWithStatement = null,
  }) {
    return _then(_$YearlyPensionStatementModelImpl(
      year: null == year
          ? _value.year
          : year // ignore: cast_nullable_to_non_nullable
              as int,
      pensionWithStatement: null == pensionWithStatement
          ? _value._pensionWithStatement
          : pensionWithStatement // ignore: cast_nullable_to_non_nullable
              as List<PensionWithStatementModel>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$YearlyPensionStatementModelImpl
    with DiagnosticableTreeMixin
    implements _YearlyPensionStatementModel {
  const _$YearlyPensionStatementModelImpl(
      {required this.year,
      required final List<PensionWithStatementModel> pensionWithStatement})
      : _pensionWithStatement = pensionWithStatement;

  factory _$YearlyPensionStatementModelImpl.fromJson(
          Map<String, dynamic> json) =>
      _$$YearlyPensionStatementModelImplFromJson(json);

  @override
  final int year;
  final List<PensionWithStatementModel> _pensionWithStatement;
  @override
  List<PensionWithStatementModel> get pensionWithStatement {
    if (_pensionWithStatement is EqualUnmodifiableListView)
      return _pensionWithStatement;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_pensionWithStatement);
  }

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'YearlyPensionStatementModel(year: $year, pensionWithStatement: $pensionWithStatement)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'YearlyPensionStatementModel'))
      ..add(DiagnosticsProperty('year', year))
      ..add(DiagnosticsProperty('pensionWithStatement', pensionWithStatement));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$YearlyPensionStatementModelImpl &&
            (identical(other.year, year) || other.year == year) &&
            const DeepCollectionEquality()
                .equals(other._pensionWithStatement, _pensionWithStatement));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, year,
      const DeepCollectionEquality().hash(_pensionWithStatement));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$YearlyPensionStatementModelImplCopyWith<_$YearlyPensionStatementModelImpl>
      get copyWith => __$$YearlyPensionStatementModelImplCopyWithImpl<
          _$YearlyPensionStatementModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$YearlyPensionStatementModelImplToJson(
      this,
    );
  }
}

abstract class _YearlyPensionStatementModel
    implements YearlyPensionStatementModel {
  const factory _YearlyPensionStatementModel(
      {required final int year,
      required final List<PensionWithStatementModel>
          pensionWithStatement}) = _$YearlyPensionStatementModelImpl;

  factory _YearlyPensionStatementModel.fromJson(Map<String, dynamic> json) =
      _$YearlyPensionStatementModelImpl.fromJson;

  @override
  int get year;
  @override
  List<PensionWithStatementModel> get pensionWithStatement;
  @override
  @JsonKey(ignore: true)
  _$$YearlyPensionStatementModelImplCopyWith<_$YearlyPensionStatementModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
