import 'dart:async';
import 'dart:io';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:subpack_analyzer/src/commands/utils/analyzing_command_mixin.dart';
import 'package:subpack_analyzer/src/commands/utils/logging_command_mixin.dart';
import 'package:subpack_analyzer/src/commands/utils/subpack_command.dart';
import 'package:subpack_analyzer/src/core/dependencies/dependencies_model.dart';
import 'package:subpack_analyzer/src/core/dependencies/depenencies_builder.dart';
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_builder.dart';
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_logger.dart';

class NestedDependenciesCommand extends SubpackCommand
    with AnalyzingCommandMixin, LoggingCommandMixin, SubpackLogger {
  @override
  String get name => 'nested-dependencies';

  @override
  String get description =>
      'Creates a nested dependencies graph of the subpackages.';

  final Map<SubpackDirectory, int> _idForSubpackDirectory = {};
  int _nextSubpackDirectoryId = 0;

  int getSubpackDirectoryId(SubpackDirectory directory) =>
      _idForSubpackDirectory[directory] ??= _nextSubpackDirectoryId++;

  void _addPackages(
    TreeDirectory directory,
    StringBuffer buffer,
    int level,
  ) {
    if (directory is SubpackDirectory) {
      final indent = '  ' * level;
      final id = getSubpackDirectoryId(directory);
      buffer.writeln('${indent}subgraph $id[${directory.name}]');
      for (final child in directory.directories) {
        _addPackages(child, buffer, level + 1);
      }
      buffer.writeln('${indent}end');
    } else {
      for (final child in directory.directories) {
        _addPackages(child, buffer, level + 1);
      }
    }
  }

  void _addDependencies(
    SubpackDirectory directory,
    StringBuffer buffer,
    ISet<Dependency> dependencies,
  ) {
    final id = getSubpackDirectoryId(directory);
    for (final dependency in dependencies) {
      switch (dependency) {
        case SubpackageDependency():
          final dependencyId = getSubpackDirectoryId(
            dependency.subpackDirectory,
          );
          buffer.writeln(
            '  $id --> $dependencyId',
          );
        case DartPackageDependency():
          buffer.writeln('  $id --> ${dependency.name}');
      }
    }
  }

  @override
  Future<void> run() async {
    final packageRoot = await FileStructureTreeBuilder.buildFileStructureTree(
      rootDirectory: analysisParameters.rootDirectory,
      analysisDirectories: analysisParameters.directories,
      logger: logger,
    );

    final dependenciesModel = await DependenciesBuilder.buildDependencies(
      packageRoot: packageRoot,
      logger: logger,
    );
    switch (dependenciesModel) {
      case DependenciesFailiureModel():
        // TODO: Handle the same as for analysis.
        throw Exception();
      // return finalizeAnalysis(
      //   exitCode: 1,
      //   errors: dependenciesModel.errors,
      // );
      case DependenciesSuccessModel():
    }
    final buffer = StringBuffer();
    buffer.writeln('flowchart TD');
    for (final directory in packageRoot.subpackDirectories) {
      _addPackages(directory, buffer, 1);
    }
    for (final directory in packageRoot.allSubpackDirectories) {
      final dependencies = dependenciesModel.getSubpackDependencies(
        directory,
      );
      _addDependencies(directory, buffer, dependencies);
    }
    stdout.write(buffer);
  }
}
