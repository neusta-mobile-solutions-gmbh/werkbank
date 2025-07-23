import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;

import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_utils.dart';
import 'package:subpack_analyzer/src/core/relations/relations_model.dart';

/// Builds a model of file and subpackage relationships within a package by traversing its directory tree.
/// Tracks which Dart files are contained in or exposed by each subpackage, and records the deepest source directory for each file.
class RelationsBuilder {
  /// Builds and returns a [RelationsModel] for the given [packageRoot].
  /// This function analyzes the package structure to determine which files are exposed or contained by each subpackage.
  static Future<RelationsModel> buildRelations({
    required PackageRoot packageRoot,
    required Logger logger,
  }) async {
    final relationsBuilder = RelationsBuilder._relationsBuilder(
      packageRoot: packageRoot,
      logger: logger,
    );
    return relationsBuilder._buildRelations();
  }

  RelationsBuilder._relationsBuilder({
    required PackageRoot packageRoot,
    required Logger logger,
  }) : _packageRoot = packageRoot;

  final PackageRoot _packageRoot;

  final _exposedFiles = <SubpackDirectory, Set<DartFile>>{};
  final _containedFiles = <SubpackDirectory, Set<DartFile>>{};
  final _exposingSubpackages = <DartFile, ISet<SubpackDirectory>>{};
  final _containingSubpackages = <DartFile, ISet<SubpackDirectory>>{};
  final _deepestSrcDirectory = <DartFile, TreeDirectory>{};

  Future<RelationsModel> _buildRelations() async {
    for (final directory in _packageRoot.subpackDirectories) {
      await _handleDirectory(
        directory: directory,
        containingSubpacks: {directory}.lockUnsafe,
        exposingSubpacks: {directory}.lockUnsafe,
        isDirInSubpack: true,
        srcDirectory: null,
      );
    }

    return RelationsModel(
      exposedFiles: {
        for (final MapEntry(:key, :value) in _exposedFiles.entries)
          key: value.lock,
      }.lockUnsafe,
      containedFiles: {
        for (final MapEntry(:key, :value) in _containedFiles.entries)
          key: value.lock,
      }.lockUnsafe,
      exposingSubpackages: _exposingSubpackages.lock,
      containingSubpackages: _containingSubpackages.lock,
      deepestSrcDirectory: _deepestSrcDirectory.lock,
    );
  }

  Future<void> _handleDirectory({
    required TreeDirectory directory,
    required ISet<SubpackDirectory> containingSubpacks,
    required ISet<SubpackDirectory> exposingSubpacks,
    required bool isDirInSubpack,
    required TreeDirectory? srcDirectory,
  }) async {
    final newContainingSubpacks = directory is SubpackDirectory
        ? containingSubpacks.add(directory)
        : containingSubpacks;

    final splitPath = p.split(directory.directory.path);
    final currentIsSrcDirectory = isDirInSubpack && splitPath.last == src;

    final ISet<SubpackDirectory> newExposingSubpacks;

    final TreeDirectory? newSrcDirectory;
    if (currentIsSrcDirectory) {
      newSrcDirectory = directory;
      newExposingSubpacks = <SubpackDirectory>{}.lockUnsafe;
    } else if (directory is SubpackDirectory) {
      newSrcDirectory = null;
      newExposingSubpacks = exposingSubpacks.add(directory);
    } else {
      newSrcDirectory = srcDirectory;
      newExposingSubpacks = exposingSubpacks;
    }

    for (final file in directory.dartFiles) {
      _handleDartFile(
        file: file,
        containingSubpacks: newContainingSubpacks,
        exposingSubpacks: newExposingSubpacks,
        srcDirectory: newSrcDirectory,
      );
    }

    for (final child in directory.directories) {
      await _handleDirectory(
        directory: child,
        containingSubpacks: newContainingSubpacks,
        exposingSubpacks: newExposingSubpacks,
        isDirInSubpack: directory is SubpackDirectory,
        srcDirectory: newSrcDirectory,
      );
    }
  }

  /// Adds entries for `file` in `_containedFiles`, `_exposedFiles` and
  /// `_deepestSrcDirectory` if conditions are met.
  void _handleDartFile({
    required DartFile file,
    required ISet<SubpackDirectory> containingSubpacks,
    required ISet<SubpackDirectory> exposingSubpacks,
    required TreeDirectory? srcDirectory,
  }) {
    for (final containingSubpack in containingSubpacks) {
      (_containedFiles[containingSubpack] ??= {}).add(file);
    }
    _containingSubpackages[file] = containingSubpacks;

    for (final exposingSubpack in exposingSubpacks) {
      (_exposedFiles[exposingSubpack] ??= {}).add(file);
    }
    _exposingSubpackages[file] = exposingSubpacks;

    if (srcDirectory != null) {
      _deepestSrcDirectory[file] = srcDirectory;
    }
  }
}
