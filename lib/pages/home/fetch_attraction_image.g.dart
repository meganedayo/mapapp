// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_attraction_image.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$fetchAttractionImagesHash() =>
    r'1f34ff6884759358d23ba84ac84e14a3881c1c94';

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

/// See also [fetchAttractionImages].
@ProviderFor(fetchAttractionImages)
const fetchAttractionImagesProvider = FetchAttractionImagesFamily();

/// See also [fetchAttractionImages].
class FetchAttractionImagesFamily extends Family<AsyncValue<List<String>>> {
  /// See also [fetchAttractionImages].
  const FetchAttractionImagesFamily();

  /// See also [fetchAttractionImages].
  FetchAttractionImagesProvider call(
    String attractionId,
  ) {
    return FetchAttractionImagesProvider(
      attractionId,
    );
  }

  @override
  FetchAttractionImagesProvider getProviderOverride(
    covariant FetchAttractionImagesProvider provider,
  ) {
    return call(
      provider.attractionId,
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
  String? get name => r'fetchAttractionImagesProvider';
}

/// See also [fetchAttractionImages].
class FetchAttractionImagesProvider
    extends AutoDisposeFutureProvider<List<String>> {
  /// See also [fetchAttractionImages].
  FetchAttractionImagesProvider(
    String attractionId,
  ) : this._internal(
          (ref) => fetchAttractionImages(
            ref as FetchAttractionImagesRef,
            attractionId,
          ),
          from: fetchAttractionImagesProvider,
          name: r'fetchAttractionImagesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchAttractionImagesHash,
          dependencies: FetchAttractionImagesFamily._dependencies,
          allTransitiveDependencies:
              FetchAttractionImagesFamily._allTransitiveDependencies,
          attractionId: attractionId,
        );

  FetchAttractionImagesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.attractionId,
  }) : super.internal();

  final String attractionId;

  @override
  Override overrideWith(
    FutureOr<List<String>> Function(FetchAttractionImagesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchAttractionImagesProvider._internal(
        (ref) => create(ref as FetchAttractionImagesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        attractionId: attractionId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<List<String>> createElement() {
    return _FetchAttractionImagesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAttractionImagesProvider &&
        other.attractionId == attractionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, attractionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchAttractionImagesRef on AutoDisposeFutureProviderRef<List<String>> {
  /// The parameter `attractionId` of this provider.
  String get attractionId;
}

class _FetchAttractionImagesProviderElement
    extends AutoDisposeFutureProviderElement<List<String>>
    with FetchAttractionImagesRef {
  _FetchAttractionImagesProviderElement(super.provider);

  @override
  String get attractionId =>
      (origin as FetchAttractionImagesProvider).attractionId;
}

String _$fetchAttractionImageHash() =>
    r'830bab917e2719b6fe282c03b9d60d50a95c3305';

/// See also [fetchAttractionImage].
@ProviderFor(fetchAttractionImage)
const fetchAttractionImageProvider = FetchAttractionImageFamily();

/// See also [fetchAttractionImage].
class FetchAttractionImageFamily extends Family<AsyncValue<String>> {
  /// See also [fetchAttractionImage].
  const FetchAttractionImageFamily();

  /// See also [fetchAttractionImage].
  FetchAttractionImageProvider call(
    String attractionId,
  ) {
    return FetchAttractionImageProvider(
      attractionId,
    );
  }

  @override
  FetchAttractionImageProvider getProviderOverride(
    covariant FetchAttractionImageProvider provider,
  ) {
    return call(
      provider.attractionId,
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
  String? get name => r'fetchAttractionImageProvider';
}

/// See also [fetchAttractionImage].
class FetchAttractionImageProvider extends AutoDisposeFutureProvider<String> {
  /// See also [fetchAttractionImage].
  FetchAttractionImageProvider(
    String attractionId,
  ) : this._internal(
          (ref) => fetchAttractionImage(
            ref as FetchAttractionImageRef,
            attractionId,
          ),
          from: fetchAttractionImageProvider,
          name: r'fetchAttractionImageProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$fetchAttractionImageHash,
          dependencies: FetchAttractionImageFamily._dependencies,
          allTransitiveDependencies:
              FetchAttractionImageFamily._allTransitiveDependencies,
          attractionId: attractionId,
        );

  FetchAttractionImageProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.attractionId,
  }) : super.internal();

  final String attractionId;

  @override
  Override overrideWith(
    FutureOr<String> Function(FetchAttractionImageRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FetchAttractionImageProvider._internal(
        (ref) => create(ref as FetchAttractionImageRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        attractionId: attractionId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _FetchAttractionImageProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FetchAttractionImageProvider &&
        other.attractionId == attractionId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, attractionId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FetchAttractionImageRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `attractionId` of this provider.
  String get attractionId;
}

class _FetchAttractionImageProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with FetchAttractionImageRef {
  _FetchAttractionImageProviderElement(super.provider);

  @override
  String get attractionId =>
      (origin as FetchAttractionImageProvider).attractionId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
