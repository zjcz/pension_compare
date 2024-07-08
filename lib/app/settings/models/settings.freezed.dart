// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Settings _$SettingsFromJson(Map<String, dynamic> json) {
  return _Settings.fromJson(json);
}

/// @nodoc
mixin _$Settings {
  bool? get acceptTermsAndConditions => throw _privateConstructorUsedError;
  bool? get acceptFinancialAdviceWarning => throw _privateConstructorUsedError;
  bool? get welcomeScreenDismissed => throw _privateConstructorUsedError;
  bool get optIntoAnalyticsWarning => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SettingsCopyWith<Settings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SettingsCopyWith<$Res> {
  factory $SettingsCopyWith(Settings value, $Res Function(Settings) then) =
      _$SettingsCopyWithImpl<$Res, Settings>;
  @useResult
  $Res call(
      {bool? acceptTermsAndConditions,
      bool? acceptFinancialAdviceWarning,
      bool? welcomeScreenDismissed,
      bool optIntoAnalyticsWarning});
}

/// @nodoc
class _$SettingsCopyWithImpl<$Res, $Val extends Settings>
    implements $SettingsCopyWith<$Res> {
  _$SettingsCopyWithImpl(this._value, this._then);

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
    Object? optIntoAnalyticsWarning = null,
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
      optIntoAnalyticsWarning: null == optIntoAnalyticsWarning
          ? _value.optIntoAnalyticsWarning
          : optIntoAnalyticsWarning // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SettingsImplCopyWith<$Res>
    implements $SettingsCopyWith<$Res> {
  factory _$$SettingsImplCopyWith(
          _$SettingsImpl value, $Res Function(_$SettingsImpl) then) =
      __$$SettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {bool? acceptTermsAndConditions,
      bool? acceptFinancialAdviceWarning,
      bool? welcomeScreenDismissed,
      bool optIntoAnalyticsWarning});
}

/// @nodoc
class __$$SettingsImplCopyWithImpl<$Res>
    extends _$SettingsCopyWithImpl<$Res, _$SettingsImpl>
    implements _$$SettingsImplCopyWith<$Res> {
  __$$SettingsImplCopyWithImpl(
      _$SettingsImpl _value, $Res Function(_$SettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? acceptTermsAndConditions = freezed,
    Object? acceptFinancialAdviceWarning = freezed,
    Object? welcomeScreenDismissed = freezed,
    Object? optIntoAnalyticsWarning = null,
  }) {
    return _then(_$SettingsImpl(
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
class _$SettingsImpl with DiagnosticableTreeMixin implements _Settings {
  const _$SettingsImpl(
      {required this.acceptTermsAndConditions,
      required this.acceptFinancialAdviceWarning,
      required this.welcomeScreenDismissed,
      required this.optIntoAnalyticsWarning});

  factory _$SettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$SettingsImplFromJson(json);

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
    return 'Settings(acceptTermsAndConditions: $acceptTermsAndConditions, acceptFinancialAdviceWarning: $acceptFinancialAdviceWarning, welcomeScreenDismissed: $welcomeScreenDismissed, optIntoAnalyticsWarning: $optIntoAnalyticsWarning)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Settings'))
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
            other is _$SettingsImpl &&
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
      acceptTermsAndConditions,
      acceptFinancialAdviceWarning,
      welcomeScreenDismissed,
      optIntoAnalyticsWarning);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SettingsImplCopyWith<_$SettingsImpl> get copyWith =>
      __$$SettingsImplCopyWithImpl<_$SettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SettingsImplToJson(
      this,
    );
  }
}

abstract class _Settings implements Settings {
  const factory _Settings(
      {required final bool? acceptTermsAndConditions,
      required final bool? acceptFinancialAdviceWarning,
      required final bool? welcomeScreenDismissed,
      required final bool optIntoAnalyticsWarning}) = _$SettingsImpl;

  factory _Settings.fromJson(Map<String, dynamic> json) =
      _$SettingsImpl.fromJson;

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
  _$$SettingsImplCopyWith<_$SettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
