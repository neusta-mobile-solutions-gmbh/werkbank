import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_error_collector.dart';

import 'package:subpack_analyzer/src/core/dependencies/dependencies_model.dart';
import 'package:subpack_analyzer/src/core/relations/relations_model.dart';
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';
import 'package:subpack_analyzer/src/core/usages/usages_model.dart';
import 'package:subpack_analyzer/src/core/analyzer/analyzer_error_model.dart';
import 'package:subpack_analyzer/src/core/analyzer/analyzer_model.dart';

/// Applies the Subpack Analyzer rules
/// on the subpack model and checks for rule violations.
class Analyzer {
  /// Applies all analyzer rules to the provided dependency, usage, and relation models.
  /// Checks for rule violations and returns an [AnalyzerModel] containing the results.
  ///
  /// This function is the main entry point for validating the subpack structure and its dependencies.
  static Future<AnalyzerModel> analyzeRelations({
    required DependenciesSuccessModel dependencies,
    required UsagesModel usages,
    required RelationsModel relations,
    required PackageRoot packageRoot,
    required Logger logger,
  }) async {
    final analyzer = Analyzer._analyzer(
      dependencies: dependencies,
      usages: usages,
      relations: relations,
      packageRoot: packageRoot,
      logger: logger,
    );
    return analyzer._analyzeRelations();
  }

  Analyzer._analyzer({
    required DependenciesSuccessModel dependencies,
    required UsagesModel usages,
    required RelationsModel relations,
    required PackageRoot packageRoot,
    required Logger logger,
  })  : _packageRoot = packageRoot,
        _usages = usages,
        _dependencies = dependencies,
        _relations = relations,
        _errors = SubpackErrorCollector<AnalyzerError>(logger: logger);

  final RelationsModel _relations;
  final DependenciesSuccessModel _dependencies;
  final UsagesModel _usages;
  final PackageRoot _packageRoot;
  final SubpackErrorCollector<AnalyzerError> _errors;

  AnalyzerModel _analyzeRelations() {
    for (final file in _usages.usingDirectives.keys) {
      for (final usage in _usages.usingDirectives[file]!) {
        _checkUndependedUsage(file, usage);
      }
    }

    if (_errors.isEmpty) {
      return AnalyzerSuccessModel();
    } else {
      return AnalyzerFailiureModel(errors: _errors.toISet());
    }
  }

  bool _checkUndependedUsage(DartFile file, Usage usage) {
    final subpacksContainingFile = _relations.containingSubpackages[file]!;
    final dependenciesOfSubpacks = {
      for (final containingSubpack in subpacksContainingFile)
        ..._dependencies.getSubpackDependencies(containingSubpack),
    };

    switch (usage) {
      case LocalUsage(dartFile: final usageFile):
        if (_isInSameSrcDir(file, usageFile)) {
          return true;
        }
        final exposing = _relations.exposingSubpackages[usageFile]!;
        final subpackageDependencyDirectories = dependenciesOfSubpacks
            .whereType<SubpackageDependency>()
            .map((subpackDependency) => subpackDependency.subpackDirectory)
            .toISet();

        final intersection = exposing.intersection(
          subpackageDependencyDirectories,
        );

        if (intersection.isEmpty) {
          _errors.add(
            UndependedLocalUsageError(
              packageRoot: _packageRoot,
              dartFile: file,
              usage: usage,
              fileContainingSubpacks: subpacksContainingFile,
              usageExposingSubpacks: exposing,
            ),
          );
          return false;
        }

      case PackageUsage(:final packageName):
        final dartPackageDependencyNames = dependenciesOfSubpacks
            .whereType<DartPackageDependency>()
            .map((packageDependency) => packageDependency.name)
            .toISet();
        if (!dartPackageDependencyNames.contains(packageName)) {
          _errors.add(
            UndependedPackageUsageError(
              packageRoot: _packageRoot,
              dartFile: file,
              usage: usage,
              fileContainingSubpacks: subpacksContainingFile,
            ),
          );
          return false;
        }
    }
    return true;
  }

  bool _isInSameSrcDir(DartFile a, DartFile b) {
    final deepesrSrcA = _relations.deepestSrcDirectory[a];
    final deepestSrcB = _relations.deepestSrcDirectory[b];
    if (deepesrSrcA == null || deepestSrcB == null) {
      return false;
    }
    return deepesrSrcA == deepestSrcB;
  }
}
