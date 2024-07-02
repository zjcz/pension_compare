// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statement_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$statementControllerHash() =>
    r'a238b9ccf0507aac6c0dbf9b3db550b0d354ffc1';

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

abstract class _$StatementController
    extends BuildlessAutoDisposeStreamNotifier<List<StatementModel>> {
  late final int pensionId;

  Stream<List<StatementModel>> build(
    int pensionId,
  );
}

/// See also [StatementController].
@ProviderFor(StatementController)
const statementControllerProvider = StatementControllerFamily();

/// See also [StatementController].
class StatementControllerFamily
    extends Family<AsyncValue<List<StatementModel>>> {
  /// See also [StatementController].
  const StatementControllerFamily();

  /// See also [StatementController].
  StatementControllerProvider call(
    int pensionId,
  ) {
    return StatementControllerProvider(
      pensionId,
    );
  }

  @override
  StatementControllerProvider getProviderOverride(
    covariant StatementControllerProvider provider,
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
  String? get name => r'statementControllerProvider';
}

/// See also [StatementController].
class StatementControllerProvider extends AutoDisposeStreamNotifierProviderImpl<
    StatementController, List<StatementModel>> {
  /// See also [StatementController].
  StatementControllerProvider(
    int pensionId,
  ) : this._internal(
          () => StatementController()..pensionId = pensionId,
          from: statementControllerProvider,
          name: r'statementControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$statementControllerHash,
          dependencies: StatementControllerFamily._dependencies,
          allTransitiveDependencies:
              StatementControllerFamily._allTransitiveDependencies,
          pensionId: pensionId,
        );

  StatementControllerProvider._internal(
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
  Stream<List<StatementModel>> runNotifierBuild(
    covariant StatementController notifier,
  ) {
    return notifier.build(
      pensionId,
    );
  }

  @override
  Override overrideWith(StatementController Function() create) {
    return ProviderOverride(
      origin: this,
      override: StatementControllerProvider._internal(
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
  AutoDisposeStreamNotifierProviderElement<StatementController,
      List<StatementModel>> createElement() {
    return _StatementControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is StatementControllerProvider && other.pensionId == pensionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, pensionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin StatementControllerRef
    on AutoDisposeStreamNotifierProviderRef<List<StatementModel>> {
  /// The parameter `pensionId` of this provider.
  int get pensionId;
}

class _StatementControllerProviderElement
    extends AutoDisposeStreamNotifierProviderElement<StatementController,
        List<StatementModel>> with StatementControllerRef {
  _StatementControllerProviderElement(super.provider);

  @override
  int get pensionId => (origin as StatementControllerProvider).pensionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
