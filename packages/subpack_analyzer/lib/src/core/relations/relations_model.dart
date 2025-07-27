import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';

/// A structure to store subpack information.
/// Gets build from a tree structure model.

class RelationsModel {
  RelationsModel({
    required this.exposedFiles,
    required this.containedFiles,
    required this.exposingSubpackages,
    required this.containingSubpackages,
    required this.deepestSrcDirectory,
  });

  /// Dart files that are exposed by these subpackages
  final IMap<SubpackDirectory, ISet<DartFile>> exposedFiles;

  /// Dart files that are contained in these subpackages
  final IMap<SubpackDirectory, ISet<DartFile>> containedFiles;

  /// Subpackages that expose these dart files
  final IMap<DartFile, ISet<SubpackDirectory>> exposingSubpackages;

  /// Subpackages that contain these dart files
  final IMap<DartFile, ISet<SubpackDirectory>> containingSubpackages;

  ///
  final IMap<DartFile, TreeDirectory> deepestSrcDirectory;
}
