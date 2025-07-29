import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;
import 'package:subpack_analyzer/src/core/dependencies/dependencies_error_model.dart';
import 'package:subpack_analyzer/src/core/dependencies/dependencies_model.dart';
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';
import 'package:subpack_analyzer/src/core/utils/emotes.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_error_collector.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_logger.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_utils.dart';
import 'package:yaml/yaml.dart';

class DependenciesBuilder with SubpackLogger {
  DependenciesBuilder({
    required PackageRoot packageRoot,
  }) : _packageRoot = packageRoot,
       _errors = SubpackErrorCollector<DependenciesError>();

  static Future<DependenciesModel> buildDependencies({
    required PackageRoot packageRoot,
    required Logger logger,
  }) async {
    final dependenciesBuilder = DependenciesBuilder(
      packageRoot: packageRoot,
    );
    return await dependenciesBuilder._buildDependenciesModel();
  }

  final PackageRoot _packageRoot;
  final SubpackErrorCollector<DependenciesError> _errors;
  final _subpackDependencies = <SubpackDirectory, Set<Dependency>>{};

  Future<DependenciesModel> _buildDependenciesModel() async {
    logVerbose('\n\n>> Looking for dependencies...');

    for (final directory in _packageRoot.subpackDirectories) {
      await _handleDirectory(
        directory: directory,
      );
    }

    if (_errors.isEmpty) {
      return DependenciesSuccessModel(
        subpackDependencies: {
          for (final MapEntry(:key, :value) in _subpackDependencies.entries)
            key: value.lock,
        }.lockUnsafe,
      );
    } else {
      return DependenciesFailiureModel(errors: _errors.toISet());
    }
  }

  Future<void> _handleDirectory({
    required TreeDirectory directory,
  }) async {
    if (directory is SubpackDirectory && directory.subpackFile != null) {
      await _handleSubpackFile(
        directory,
        directory.subpackFile!,
      );
    }

    for (final directory in directory.directories) {
      await _handleDirectory(
        directory: directory,
      );
    }
  }

  Future<void> _handleSubpackFile(
    SubpackDirectory subpackDirectory,
    SubpackFile file,
  ) async {
    logVerbose('\n${Emotes.magGlass} Analyzing ${file.file.uri} ...');
    final absoluteFilePath = p.join(
      _packageRoot.rootDirectory.path,
      file.file.path,
    );
    final subpackContent = await SubpackUtils.readYaml(absoluteFilePath);
    final dependenciesList = subpackContent?['dependencies'] as YamlList?;

    if (dependenciesList == null || dependenciesList.isEmpty) {
      logVerbose('${Emotes.chains}  Subpack has no dependencies');
      return;
    }

    final dependencies = _getSubpackDependencies(
      packageRoot: _packageRoot,
      subpackDirectory: subpackDirectory,
      dependenciesList: dependenciesList,
    );
    if (dependencies == null) {
      return;
    }
    _subpackDependencies[subpackDirectory] = dependencies;

    logVerbose('${Emotes.chains}  Dependencies:');
    for (final entry in dependencies) {
      switch (entry) {
        case SubpackageDependency():
          logVerbose(
            '  - ${SubpackUtils.getFileUri(
              rootDirectory: _packageRoot.rootDirectory,
              relativePath: entry.subpackDirectory.directory.path,
            )}',
          );

        case DartPackageDependency(:final name):
          logVerbose('  - $name');
      }
    }
  }

  Set<Dependency>? _getSubpackDependencies({
    required PackageRoot packageRoot,
    required SubpackDirectory subpackDirectory,
    required YamlList dependenciesList,
  }) {
    final dependencies = <Dependency>{};
    for (final dependency in dependenciesList.cast<String>()) {
      final subpackDependency = _getDependency(subpackDirectory, dependency);
      if (subpackDependency == null) {
        return null;
      } else {
        dependencies.add(subpackDependency);
      }
    }
    return dependencies;
  }

  Dependency? _getDependency(
    SubpackDirectory subpackDirectory,
    String dependency,
  ) {
    if (dependency.startsWith('.')) {
      // This must remain so that, for example, packages/subpack_analyzer/lib/src/,
      // which is a self-dependency, is also correctly treated as such.
      // Otherwise, it throws a SubpackFromPathDoesNotExistError.
      if (dependency == '.') {
        // self-dependency
        return SubpackageDependency(
          subpackDirectory: subpackDirectory,
        );
      }
      final combinedPath = p.join(
        subpackDirectory.directory.path,
        dependency,
      );
      final subpack = _packageRoot.fromPath(combinedPath);
      if (subpack is! SubpackDirectory) {
        _errors.add(
          SubpackFromPathDoesNotExistError(
            falsePath: combinedPath,
            packageRoot: _packageRoot,
          ),
        );
        return null;
      } else {
        return SubpackageDependency(subpackDirectory: subpack);
      }
    } else if (p.isAbsolute(dependency)) {
      // absolute, root relative
      final subpackPath = subpackDirectory.directory.path;
      final relativeDependencyPath = p.relative(dependency, from: '/');
      final splitRelativeDependencyPath = p.split(relativeDependencyPath);
      final parallelPath = _getParallelPath(
        sourcePath: subpackPath,
        targetDirectory: splitRelativeDependencyPath.first,
        relativePath: relativeDependencyPath,
      );
      if (parallelPath == null) {
        _errors.add(
          DirectoryIsNotPartOfPathError(
            packageRoot: _packageRoot,
            sourcePath: subpackPath,
            targetDirectory: splitRelativeDependencyPath.first,
          ),
        );
        return null;
      }
      final subpack = _packageRoot.fromPath(parallelPath);
      if (subpack is! SubpackDirectory) {
        _errors.add(
          SubpackFromPathDoesNotExistError(
            falsePath: parallelPath,
            packageRoot: _packageRoot,
          ),
        );
        return null;
      } else {
        return SubpackageDependency(subpackDirectory: subpack);
      }
    } else {
      if (dependency == _packageRoot.name) {
        _errors.add(
          DependencyOnOwnPackageError(
            dependency: dependency,
            packageRoot: _packageRoot,
          ),
        );
        return null;
      }
      // Dart package
      final isValidPackageName = SubpackUtils.isValidPackageName(dependency);
      if (!isValidPackageName) {
        _errors.add(InvalidPackageNameError(invalidPackageName: dependency));
      }
      return DartPackageDependency(name: dependency);
    }
  }

  /// Returns a new path by trimming `sourcePath` up to (but not including)
  /// `targetDirectory`, then appending `relativePath`.
  /// Returns null if `targetDirectory` is not found in `sourcePath`.
  String? _getParallelPath({
    required String sourcePath,
    required String targetDirectory,
    required String relativePath,
  }) {
    final segments = p.split(sourcePath);
    final index = segments.indexOf(targetDirectory);
    if (index == -1) {
      return null;
    }

    final basePath = p.joinAll(segments.sublist(0, index));
    final parallelPath = p.join(basePath, relativePath);
    return parallelPath;
  }
}
