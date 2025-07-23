import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:meta/meta.dart';

/// The metadata of a use case.
///
/// You can get the metadata inside the widgets of a use case by using
/// [UseCase.metaDataOf].
/// Additionally the metadata gen be obtained using
/// [UseCaseComposition.metadata] of a [UseCaseComposition]
/// or by computing the metadata of a [UseCaseDescriptor], using
/// [UseCaseDescriptor.computeMetadata].
///
/// {@category Custom Use Case Metadata}
@immutable
class UseCaseMetadata {
  const UseCaseMetadata._(this._metadata);

  /// Creates a [UseCaseMetadata] object from a map of
  /// [UseCaseMetadataEntry] objects.
  ///
  /// Usually, you won't need to use this, because the
  /// metadata is constructed by the [UseCaseComposer].
  UseCaseMetadata.fromMap(Map<Type, UseCaseMetadataEntry> metadata)
    : _metadata = metadata.lock;

  /// Creates an empty [UseCaseMetadata] object.
  static const UseCaseMetadata empty = UseCaseMetadata._(IMap.empty());

  final IMap<Type, UseCaseMetadataEntry> _metadata;

  /// Gets the [UseCaseMetadataEntry] that has the given
  /// generic type [T] as its [UseCaseMetadataEntry.type].
  T? get<T extends UseCaseMetadataEntry<T>>() {
    return _metadata[T] as T?;
  }
}

/// A superclass for all metadata entries that can be dynamically added to a
/// use case. This can be used to store additional information which can be read
/// by addons or other methods inside the use case builder.
///
/// {@category Custom Use Case Metadata}
@immutable
abstract class UseCaseMetadataEntry<T extends UseCaseMetadataEntry<T>> {
  const UseCaseMetadataEntry();

  /// Gets the generic type [T] which is used to identify this
  /// [UseCaseMetadataEntry] when getting it via
  /// [UseCaseMetadata.get] or [UseCaseComposer.getMetadata].
  Type get type => T;
}
