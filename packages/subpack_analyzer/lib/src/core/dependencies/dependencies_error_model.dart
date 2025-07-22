import 'package:mason_logger/mason_logger.dart';

import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_error.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_utils.dart';

sealed class DependenciesError extends SubpackError {}

class DirectoryIsNotPartOfPathError extends DependenciesError {
  DirectoryIsNotPartOfPathError({
    required this.packageRoot,
    required this.sourcePath,
    required this.targetDirectory,
  });

  final PackageRoot packageRoot;
  final String sourcePath;
  final String targetDirectory;

  @override
  String get errorMessage {
    final targetDirectoryLink = link(
      uri: SubpackUtils.getFileUri(
        rootDirectory: packageRoot.rootDirectory,
        relativePath: targetDirectory,
      ),
      message: targetDirectory,
    );
    return '\nTarget directory $targetDirectoryLink '
        'is not part of the sourcePath $sourcePath, '
        'so no parallel path could be constructed.';
  }
}

class SubpackFromPathDoesNotExistError extends DependenciesError {
  SubpackFromPathDoesNotExistError({
    required this.packageRoot,
    required this.falsePath,
  });

  final PackageRoot packageRoot;
  final String falsePath;

  @override
  String get errorMessage {
    final falsePathLink = link(
      uri: SubpackUtils.getFileUri(
        rootDirectory: packageRoot.rootDirectory,
        relativePath: falsePath,
        isRunningInVSCodeTerminal: SubpackUtils.isRunningInVSCodeTerminal(),
      ),
      message: falsePath,
    );
    return '\nThe path $falsePathLink does not lead to a subpack directory and '
        'should not be used as a subpack dependency.';
  }
}

class DependencyOnOwnPackageError extends DependenciesError {
  DependencyOnOwnPackageError({
    required this.dependency,
    required this.packageRoot,
  });

  final String dependency;
  final PackageRoot packageRoot;

  @override
  String get errorMessage {
    final dependencyLink = link(
      uri: SubpackUtils.getFileUri(
        rootDirectory: packageRoot.rootDirectory,
        relativePath: dependency,
      ),
      message: dependency,
    );
    return '\nThe dependency $dependencyLink should not be referencing the '
        "package it's being used in, which is ${packageRoot.name}.";
  }
}
