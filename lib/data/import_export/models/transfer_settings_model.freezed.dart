// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_settings_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

TransferSettingsModel _$TransferSettingsModelFromJson(
    Map<String, dynamic> json) {
  return _TransferSettingsModel.fromJson(json);
}

/// @nodoc
mixin _$TransferSettingsModel {
  DateTime? get retirementDate => throw _privateConstructorUsedError;
  double? get targetIncome => throw _privateConstructorUsedError;
  bool? get acceptTermsAndConditions => throw _privateConstructorUsedError;
  bool? get acceptFinancialAdviceWarning => throw _privateConstructorUsedError;
  bool? get welcomeScreenDismissed => throw _privateConstructorUsedError;
  bool get optIntoAnalyticsWarning => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TransferSettingsModelCopyWith<TransferSettingsModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TransferSettingsModelCopyWith<$Res> {
  factory $TransferSettingsModelCopyWith(TransferSettingsModel value,
          $Res Function(TransferSettingsModel) then) =
      _$TransferSettingsModelCopyWithImpl<$Res, TransferSettingsModel>;
  @useResult
  $Res call(
      {DateTime? retirementDate,
      double? targetIncome,
      bool? acceptTermsAndConditions,
      bool? acceptFinancialAdviceWarning,
      bool? welcomeScreenDismissed,
      bool optIntoAnalyticsWarning});
}

/// @nodoc
class _$TransferSettingsModelCopyWithImpl<$Res,
        $Val extends TransferSettingsModel>
    implements $TransferSettingsModelCopyWith<$Res> {
  _$TransferSettingsModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? retirementDate = freezed,
    Object? targetIncome = freezed,
    Object? acceptTermsAndConditions = freezed,
    Object? acceptFinancialAdviceWarning = freezed,
    Object? welcomeScreenDismissed = freezed,
    Object? optIntoAnalyticsWarning = null,
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
      acceptTermsAndConditions: freezed == acceptTermsAndConditions
          ? _value.acceptTermsAndConditions
          : acceptTermsAndConditions // ignore: cast_nullable_to_non_nullable
              as bool?,
      acceptFinancialAdviceWarning: freezed == acceptFinancialAdviceWarning
          ? _value.acceptFinancialAdviceWarning
          : acceptFinancialAdviceWarning // ignore: cast_nullable_to_non_nullable
              as bool?,
      welcomeScreenDismissed: freezed == welcomeScreenDismissed
          ? _value.welcomeScreenDismissed
          : welcomeScreenDismissed // ignore: cast_nullable_to_non_nullable
              as bool?,
      optIntoAnalyticsWarning: null == optIntoAnalyticsWarning
          ? _value.optIntoAnalyticsWarning
          : optIntoAnalyticsWarning // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TransferSettingsModelImplCopyWith<$Res>
    implements $TransferSettingsModelCopyWith<$Res> {
  factory _$$TransferSettingsModelImplCopyWith(
          _$TransferSettingsModelImpl value,
          $Res Function(_$TransferSettingsModelImpl) then) =
      __$$TransferSettingsModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime? retirementDate,
      double? targetIncome,
      bool? acceptTermsAndConditions,
      bool? acceptFinancialAdviceWarning,
      bool? welcomeScreenDismissed,
      bool optIntoAnalyticsWarning});
}

/// @nodoc
class __$$TransferSettingsModelImplCopyWithImpl<$Res>
    extends _$TransferSettingsModelCopyWithImpl<$Res,
        _$TransferSettingsModelImpl>
    implements _$$TransferSettingsModelImplCopyWith<$Res> {
  __$$TransferSettingsModelImplCopyWithImpl(_$TransferSettingsModelImpl _value,
      $Res Function(_$TransferSettingsModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? retirementDate = freezed,
    Object? targetIncome = freezed,
    Object? acceptTermsAndConditions = freezed,
    Object? acceptFinancialAdviceWarning = freezed,
    Object? welcomeScreenDismissed = freezed,
    Object? optIntoAnalyticsWarning = null,
  }) {
    return _then(_$TransferSettingsModelImpl(
      retirementDate: freezed == retirementDate
          ? _value.retirementDate
          : retirementDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      targetIncome: freezed == targetIncome
          ? _value.targetIncome
          : targetIncome // ignore: cast_nullable_to_non_nullable
              as double?,
      acceptTermsAndConditions: freezed == acceptTermsAndConditions
          ? _value.acceptTermsAndConditions
          : acceptTermsAndConditions // ignore: cast_nullable_to_non_nullable
              as bool?,
      acceptFinancialAdviceWarning: freezed == acceptFinancialAdviceWarning
          ? _value.acceptFinancialAdviceWarning
          : acceptFinancialAdviceWarning // ignore: cast_nullable_to_non_nullable
              as bool?,
      welcomeScreenDismissed: freezed == welcomeScreenDismissed
          ? _value.welcomeScreenDismissed
          : welcomeScreenDismissed // ignore: cast_nullable_to_non_nullable
              as bool?,
      optIntoAnalyticsWarning: null == optIntoAnalyticsWarning
          ? _value.optIntoAnalyticsWarning
          : optIntoAnalyticsWarning // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TransferSettingsModelImpl
    with DiagnosticableTreeMixin
    implements _TransferSettingsModel {
  const _$TransferSettingsModelImpl(
      {required this.retirementDate,
      required this.targetIncome,
      required this.acceptTermsAndConditions,
      required this.acceptFinancialAdviceWarning,
      required this.welcomeScreenDismissed,
      required this.optIntoAnalyticsWarning});

  factory _$TransferSettingsModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$TransferSettingsModelImplFromJson(json);

  @override
  final DateTime? retirementDate;
  @override
  final double? targetIncome;
  @override
  final bool? acceptTermsAndConditions;
  @override
  final bool? acceptFinancialAdviceWarning;
  @override
  final bool? welcomeScreenDismissed;
  @override
  final bool optIntoAnalyticsWarning;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'TransferSettingsModel(retirementDate: $retirementDate, targetIncome: $targetIncome, acceptTermsAndConditions: $acceptTermsAndConditions, acceptFinancialAdviceWarning: $acceptFinancialAdviceWarning, welcomeScreenDismissed: $welcomeScreenDismissed, optIntoAnalyticsWarning: $optIntoAnalyticsWarning)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'TransferSettingsModel'))
      ..add(DiagnosticsProperty('retirementDate', retirementDate))
      ..add(DiagnosticsProperty('targetIncome', targetIncome))
      ..add(DiagnosticsProperty(
          'acceptTermsAndConditions', acceptTermsAndConditions))
      ..add(DiagnosticsProperty(
          'acceptFinancialAdviceWarning', acceptFinancialAdviceWarning))
      ..add(
          DiagnosticsProperty('welcomeScreenDismissed', welcomeScreenDismissed))
      ..add(DiagnosticsProperty(
          'optIntoAnalyticsWarning', optIntoAnalyticsWarning));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TransferSettingsModelImpl &&
            (identical(other.retirementDate, retirementDate) ||
                other.retirementDate == retirementDate) &&
            (identical(other.targetIncome, targetIncome) ||
                other.targetIncome == targetIncome) &&
            (identical(
                    other.acceptTermsAndConditions, acceptTermsAndConditions) ||
                other.acceptTermsAndConditions == acceptTermsAndConditions) &&
            (identical(other.acceptFinancialAdviceWarning,
                    acceptFinancialAdviceWarning) ||
                other.acceptFinancialAdviceWarning ==
                    acceptFinancialAdviceWarning) &&
            (identical(other.welcomeScreenDismissed, welcomeScreenDismissed) ||
                other.welcomeScreenDismissed == welcomeScreenDismissed) &&
            (identical(
                    other.optIntoAnalyticsWarning, optIntoAnalyticsWarning) ||
                other.optIntoAnalyticsWarning == optIntoAnalyticsWarning));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      retirementDate,
      targetIncome,
      acceptTermsAndConditions,
      acceptFinancialAdviceWarning,
      welcomeScreenDismissed,
      optIntoAnalyticsWarning);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TransferSettingsModelImplCopyWith<_$TransferSettingsModelImpl>
      get copyWith => __$$TransferSettingsModelImplCopyWithImpl<
          _$TransferSettingsModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TransferSettingsModelImplToJson(
      this,
    );
  }
}

abstract class _TransferSettingsModel implements TransferSettingsModel {
  const factory _TransferSettingsModel(
          {required final DateTime? retirementDate,
          required final double? targetIncome,
          required final bool? acceptTermsAndConditions,
          required final bool? acceptFinancialAdviceWarning,
          required final bool? welcomeScreenDismissed,
          required final bool optIntoAnalyticsWarning}) =
      _$TransferSettingsModelImpl;

  factory _TransferSettingsModel.fromJson(Map<String, dynamic> json) =
      _$TransferSettingsModelImpl.fromJson;

  @override
  DateTime? get retirementDate;
  @override
  double? get targetIncome;
  @override
  bool? get acceptTermsAndConditions;
  @override
  bool? get acceptFinancialAdviceWarning;
  @override
  bool? get welcomeScreenDismissed;
  @override
  bool get optIntoAnalyticsWarning;
  @override
  @JsonKey(ignore: true)
  _$$TransferSettingsModelImplCopyWith<_$TransferSettingsModelImpl>
      get copyWith => throw _privateConstructorUsedError;
}
