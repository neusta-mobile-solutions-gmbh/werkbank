import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;
import 'package:subpack_analyzer/src/core/relations/relations_model.dart';
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_utils.dart';

/// Builds a model of file and subpackage relationships within a package by
/// traversing its directory tree.
/// Tracks which Dart files are contained in or exposed by each subpackage,
/// and records the deepest source directory for each file.
class RelationsBuilder {
  RelationsBuilder._relationsBuilder({required PackageRoot packageRoot})
    : _packageRoot = packageRoot;

  /// Builds and returns a [RelationsModel] for the given [packageRoot].
  /// This function analyzes the package structure to determine
  /// which files are exposed or contained by each subpackage.
  static Future<RelationsModel> buildRelations({
    required PackageRoot packageRoot,
    required Logger logger,
  }) {
    final relationsBuilder = RelationsBuilder._relationsBuilder(
      packageRoot: packageRoot,
    );
    return relationsBuilder._buildRelations();
  }

  final PackageRoot _packageRoot;

  final _selfExposedFiles = <SubpackDirectory, Set<DartFile>>{};
  final _exposedFiles = <SubpackDirectory, Set<DartFile>>{};
  final _containedFiles = <SubpackDirectory, Set<DartFile>>{};
  final _selfExposingSubpackages = <DartFile, ISet<SubpackDirectory>>{};
  final _exposingSubpackages = <DartFile, ISet<SubpackDirectory>>{};
  final _containingSubpackages = <DartFile, ISet<SubpackDirectory>>{};

  Future<RelationsModel> _buildRelations() async {
    for (final directory in _packageRoot.subpackDirectories) {
      final directorySet = {directory}.lockUnsafe;
      await _handleDirectory(
        directory: directory,
        containingSubpacks: directorySet,
        selfExposingSubpacks: directorySet,
        exposingSubpacks: directorySet,
        isDirectlyInSubpack: true,
      );
    }

    return RelationsModel(
      selfExposedFiles: {
        for (final MapEntry(:key, :value) in _selfExposedFiles.entries)
          key: value.lock,
      }.lockUnsafe,
      exposedFiles: {
        for (final MapEntry(:key, :value) in _exposedFiles.entries)
          key: value.lock,
      }.lockUnsafe,
      containedFiles: {
        for (final MapEntry(:key, :value) in _containedFiles.entries)
          key: value.lock,
      }.lockUnsafe,
      selfExposingSubpackages: _selfExposingSubpackages.lock,
      exposingSubpackages: _exposingSubpackages.lock,
      containingSubpackages: _containingSubpackages.lock,
    );
  }

  Future<void> _handleDirectory({
    required TreeDirectory directory,
    required ISet<SubpackDirectory> containingSubpacks,
    required ISet<SubpackDirectory> selfExposingSubpacks,
    required ISet<SubpackDirectory> exposingSubpacks,
    required bool isDirectlyInSubpack,
  }) async {
    final newContainingSubpacks = directory is SubpackDirectory
        ? containingSubpacks.add(directory)
        : containingSubpacks;

    final dirName = p.basename(directory.directory.path);
    final currentIsSrcDirectory = isDirectlyInSubpack && dirName == src;

    final ISet<SubpackDirectory> newSelfExposingSubpacks;
    final ISet<SubpackDirectory> newExposingSubpacks;

    if (currentIsSrcDirectory) {
      newSelfExposingSubpacks = {newContainingSubpacks.last}.lockUnsafe;
      newExposingSubpacks = const ISet.empty();
    } else if (directory is SubpackDirectory) {
      newSelfExposingSubpacks = selfExposingSubpacks.add(directory);
      newExposingSubpacks = exposingSubpacks.add(directory);
    } else {
      newSelfExposingSubpacks = selfExposingSubpacks;
      newExposingSubpacks = exposingSubpacks;
    }

    for (final file in directory.dartFiles) {
      _handleDartFile(
        file: file,
        containingSubpacks: newContainingSubpacks,
        selfExposingSubpacks: newSelfExposingSubpacks,
        exposingSubpacks: newExposingSubpacks,
      );
    }

    for (final child in directory.directories) {
      await _handleDirectory(
        directory: child,
        containingSubpacks: newContainingSubpacks,
        selfExposingSubpacks: newSelfExposingSubpacks,
        exposingSubpacks: newExposingSubpacks,
        isDirectlyInSubpack: directory is SubpackDirectory,
      );
    }
  }

  void _handleDartFile({
    required DartFile file,
    required ISet<SubpackDirectory> containingSubpacks,
    required ISet<SubpackDirectory> selfExposingSubpacks,
    required ISet<SubpackDirectory> exposingSubpacks,
  }) {
    for (final containingSubpack in containingSubpacks) {
      (_containedFiles[containingSubpack] ??= {}).add(file);
    }
    _containingSubpackages[file] = containingSubpacks;

    for (final selfExposingSubpack in selfExposingSubpacks) {
      (_selfExposedFiles[selfExposingSubpack] ??= {}).add(file);
    }
    _selfExposingSubpackages[file] = selfExposingSubpacks;

    for (final exposingSubpack in exposingSubpacks) {
      (_exposedFiles[exposingSubpack] ??= {}).add(file);
    }
    _exposingSubpackages[file] = exposingSubpacks;
  }
}
