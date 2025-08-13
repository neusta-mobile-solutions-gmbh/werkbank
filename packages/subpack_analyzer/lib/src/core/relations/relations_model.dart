import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';

/// A structure to store subpack information.
/// Gets build from a tree structure model.

class RelationsModel {
  RelationsModel({
    required IMap<SubpackDirectory, ISet<DartFile>> selfExposedFiles,
    required IMap<SubpackDirectory, ISet<DartFile>> exposedFiles,
    required IMap<SubpackDirectory, ISet<DartFile>> containedFiles,
    required IMap<DartFile, ISet<SubpackDirectory>> selfExposingSubpackages,
    required IMap<DartFile, ISet<SubpackDirectory>> exposingSubpackages,
    required IMap<DartFile, ISet<SubpackDirectory>> containingSubpackages,
  }) : _selfExposedFiles = selfExposedFiles,
       _exposedFiles = exposedFiles,
       _containedFiles = containedFiles,
       _selfExposingSubpackages = selfExposingSubpackages,
       _exposingSubpackages = exposingSubpackages,
       _containingSubpackages = containingSubpackages;

  final IMap<SubpackDirectory, ISet<DartFile>> _selfExposedFiles;
  final IMap<SubpackDirectory, ISet<DartFile>> _exposedFiles;
  final IMap<SubpackDirectory, ISet<DartFile>> _containedFiles;
  final IMap<DartFile, ISet<SubpackDirectory>> _selfExposingSubpackages;
  final IMap<DartFile, ISet<SubpackDirectory>> _exposingSubpackages;
  final IMap<DartFile, ISet<SubpackDirectory>> _containingSubpackages;

  /// Dart files that are self-exposed by these subpackages
  ISet<DartFile> selfExposedFiles(SubpackDirectory subpackDirectory) {
    return _selfExposedFiles[subpackDirectory]!;
  }

  /// Dart files that are exposed by these subpackages
  ISet<DartFile> exposedFiles(SubpackDirectory subpackDirectory) {
    return _exposedFiles[subpackDirectory]!;
  }

  /// Dart files that are contained in these subpackages
  ISet<DartFile> containedFiles(SubpackDirectory subpackDirectory) {
    return _containedFiles[subpackDirectory]!;
  }

  /// Subpackages that self-expose these dart files
  ISet<SubpackDirectory> selfExposingSubpackages(DartFile dartFile) {
    return _selfExposingSubpackages[dartFile]!;
  }

  /// Subpackages that expose these dart files
  ISet<SubpackDirectory> exposingSubpackages(DartFile dartFile) {
    return _exposingSubpackages[dartFile]!;
  }

  /// Subpackages that contain these dart files
  ISet<SubpackDirectory> containingSubpackages(DartFile dartFile) {
    return _containingSubpackages[dartFile]!;
  }

  /// The subpackage owning the given [dartFile].
  ///
  /// That is most deeply nested subpackage that contains the file.
  SubpackDirectory owningSubpackage(DartFile dartFile) {
    final directories = containingSubpackages(dartFile);
    assert(
      directories.isNotEmpty,
      'Every Dart file should be contained in at least one subpack.',
    );
    // Since sets are ordered linked sets by default and we add the
    // subpack directories in the order of their depth,
    // the last one is the deepest.
    return directories.last;
  }
}
