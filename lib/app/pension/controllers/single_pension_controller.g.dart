// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'single_pension_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$singlePensionControllerHash() =>
    r'e598ac3ff062750d34b1abbe7e6f306712f878c2';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$SinglePensionController
    extends BuildlessAutoDisposeStreamNotifier<PensionModel?> {
  late final int pensionId;

  Stream<PensionModel?> build(
    int pensionId,
  );
}

/// See also [SinglePensionController].
@ProviderFor(SinglePensionController)
const singlePensionControllerProvider = SinglePensionControllerFamily();

/// See also [SinglePensionController].
class SinglePensionControllerFamily extends Family<AsyncValue<PensionModel?>> {
  /// See also [SinglePensionController].
  const SinglePensionControllerFamily();

  /// See also [SinglePensionController].
  SinglePensionControllerProvider call(
    int pensionId,
  ) {
    return SinglePensionControllerProvider(
      pensionId,
    );
  }

  @override
  SinglePensionControllerProvider getProviderOverride(
    covariant SinglePensionControllerProvider provider,
  ) {
    return call(
      provider.pensionId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'singlePensionControllerProvider';
}

/// See also [SinglePensionController].
class SinglePensionControllerProvider
    extends AutoDisposeStreamNotifierProviderImpl<SinglePensionController,
        PensionModel?> {
  /// See also [SinglePensionController].
  SinglePensionControllerProvider(
    int pensionId,
  ) : this._internal(
          () => SinglePensionController()..pensionId = pensionId,
          from: singlePensionControllerProvider,
          name: r'singlePensionControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$singlePensionControllerHash,
          dependencies: SinglePensionControllerFamily._dependencies,
          allTransitiveDependencies:
              SinglePensionControllerFamily._allTransitiveDependencies,
          pensionId: pensionId,
        );

  SinglePensionControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.pensionId,
  }) : super.internal();

  final int pensionId;

  @override
  Stream<PensionModel?> runNotifierBuild(
    covariant SinglePensionController notifier,
  ) {
    return notifier.build(
      pensionId,
    );
  }

  @override
  Override overrideWith(SinglePensionController Function() create) {
    return ProviderOverride(
      origin: this,
      override: SinglePensionControllerProvider._internal(
        () => create()..pensionId = pensionId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        pensionId: pensionId,
      ),
    );
  }

  @override
  AutoDisposeStreamNotifierProviderElement<SinglePensionController,
      PensionModel?> createElement() {
    return _SinglePensionControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SinglePensionControllerProvider &&
        other.pensionId == pensionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pensionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SinglePensionControllerRef
    on AutoDisposeStreamNotifierProviderRef<PensionModel?> {
  /// The parameter `pensionId` of this provider.
  int get pensionId;
}

class _SinglePensionControllerProviderElement
    extends AutoDisposeStreamNotifierProviderElement<SinglePensionController,
        PensionModel?> with SinglePensionControllerRef {
  _SinglePensionControllerProviderElement(super.provider);

  @override
  int get pensionId => (origin as SinglePensionControllerProvider).pensionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
