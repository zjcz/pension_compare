// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'welcome_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WelcomeSettings _$WelcomeSettingsFromJson(Map<String, dynamic> json) {
  return _WelcomeSettings.fromJson(json);
}

/// @nodoc
mixin _$WelcomeSettings {
  bool? get acceptTermsAndConditions => throw _privateConstructorUsedError;
  bool? get acceptFinancialAdviceWarning => throw _privateConstructorUsedError;
  bool? get welcomeScreenDismissed => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WelcomeSettingsCopyWith<WelcomeSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WelcomeSettingsCopyWith<$Res> {
  factory $WelcomeSettingsCopyWith(
          WelcomeSettings value, $Res Function(WelcomeSettings) then) =
      _$WelcomeSettingsCopyWithImpl<$Res, WelcomeSettings>;
  @useResult
  $Res call(
      {bool? acceptTermsAndConditions,
      bool? acceptFinancialAdviceWarning,
      bool? welcomeScreenDismissed});
}

/// @nodoc
class _$WelcomeSettingsCopyWithImpl<$Res, $Val extends WelcomeSettings>
    implements $WelcomeSettingsCopyWith<$Res> {
  _$WelcomeSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acceptTermsAndConditions = freezed,
    Object? acceptFinancialAdviceWarning = freezed,
    Object? welcomeScreenDismissed = freezed,
  }) {
    return _then(_value.copyWith(
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WelcomeSettingsImplCopyWith<$Res>
    implements $WelcomeSettingsCopyWith<$Res> {
  factory _$$WelcomeSettingsImplCopyWith(_$WelcomeSettingsImpl value,
          $Res Function(_$WelcomeSettingsImpl) then) =
      __$$WelcomeSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool? acceptTermsAndConditions,
      bool? acceptFinancialAdviceWarning,
      bool? welcomeScreenDismissed});
}

/// @nodoc
class __$$WelcomeSettingsImplCopyWithImpl<$Res>
    extends _$WelcomeSettingsCopyWithImpl<$Res, _$WelcomeSettingsImpl>
    implements _$$WelcomeSettingsImplCopyWith<$Res> {
  __$$WelcomeSettingsImplCopyWithImpl(
      _$WelcomeSettingsImpl _value, $Res Function(_$WelcomeSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acceptTermsAndConditions = freezed,
    Object? acceptFinancialAdviceWarning = freezed,
    Object? welcomeScreenDismissed = freezed,
  }) {
    return _then(_$WelcomeSettingsImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WelcomeSettingsImpl
    with DiagnosticableTreeMixin
    implements _WelcomeSettings {
  const _$WelcomeSettingsImpl(
      {required this.acceptTermsAndConditions,
      required this.acceptFinancialAdviceWarning,
      required this.welcomeScreenDismissed});

  factory _$WelcomeSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$WelcomeSettingsImplFromJson(json);

  @override
  final bool? acceptTermsAndConditions;
  @override
  final bool? acceptFinancialAdviceWarning;
  @override
  final bool? welcomeScreenDismissed;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'WelcomeSettings(acceptTermsAndConditions: $acceptTermsAndConditions, acceptFinancialAdviceWarning: $acceptFinancialAdviceWarning, welcomeScreenDismissed: $welcomeScreenDismissed)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'WelcomeSettings'))
      ..add(DiagnosticsProperty(
          'acceptTermsAndConditions', acceptTermsAndConditions))
      ..add(DiagnosticsProperty(
          'acceptFinancialAdviceWarning', acceptFinancialAdviceWarning))
      ..add(DiagnosticsProperty(
          'welcomeScreenDismissed', welcomeScreenDismissed));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WelcomeSettingsImpl &&
            (identical(
                    other.acceptTermsAndConditions, acceptTermsAndConditions) ||
                other.acceptTermsAndConditions == acceptTermsAndConditions) &&
            (identical(other.acceptFinancialAdviceWarning,
                    acceptFinancialAdviceWarning) ||
                other.acceptFinancialAdviceWarning ==
                    acceptFinancialAdviceWarning) &&
            (identical(other.welcomeScreenDismissed, welcomeScreenDismissed) ||
                other.welcomeScreenDismissed == welcomeScreenDismissed));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, acceptTermsAndConditions,
      acceptFinancialAdviceWarning, welcomeScreenDismissed);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WelcomeSettingsImplCopyWith<_$WelcomeSettingsImpl> get copyWith =>
      __$$WelcomeSettingsImplCopyWithImpl<_$WelcomeSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WelcomeSettingsImplToJson(
      this,
    );
  }
}

abstract class _WelcomeSettings implements WelcomeSettings {
  const factory _WelcomeSettings(
      {required final bool? acceptTermsAndConditions,
      required final bool? acceptFinancialAdviceWarning,
      required final bool? welcomeScreenDismissed}) = _$WelcomeSettingsImpl;

  factory _WelcomeSettings.fromJson(Map<String, dynamic> json) =
      _$WelcomeSettingsImpl.fromJson;

  @override
  bool? get acceptTermsAndConditions;
  @override
  bool? get acceptFinancialAdviceWarning;
  @override
  bool? get welcomeScreenDismissed;
  @override
  @JsonKey(ignore: true)
  _$$WelcomeSettingsImplCopyWith<_$WelcomeSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
