import 'dart:async';
import 'dart:io';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:subpack_analyzer/src/commands/utils/analyzing_command_mixin.dart';
import 'package:subpack_analyzer/src/commands/utils/subpack_command.dart';
import 'package:subpack_analyzer/src/core/dependencies/dependencies_model.dart';
import 'package:subpack_analyzer/src/core/dependencies/depenencies_builder.dart';
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_builder.dart';
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_logger.dart';

class NestedDependenciesCommand extends SubpackCommand
    with AnalyzingCommandMixin, SubpackLogger {
  @override
  String get name => 'nested-dependencies';

  @override
  String get description =>
      'Creates a nested dependencies graph of the subpackages.';

  void _addPackages(TreeDirectory directory, StringBuffer buffer) {
    if (directory is SubpackDirectory) {
      buffer.writeln('subgraph ${directory.name}');
      for (final child in directory.directories) {
        _addPackages(child, buffer);
      }
      buffer.writeln('end');
    } else {
      for (final child in directory.directories) {
        _addPackages(child, buffer);
      }
    }
  }

  void _addDependencies(
    SubpackDirectory directory,
    StringBuffer buffer,
    ISet<Dependency> dependencies,
  ) {
    for (final dependency in dependencies) {
      // TODO: Use switch
      if (dependency is SubpackageDependency) {
        buffer.writeln(
          '${directory.name} --> ${dependency.subpackDirectory.name}',
        );
      } else if (dependency is DartPackageDependency) {
        buffer.writeln('${directory.name} --> ${dependency.name}');
      }
    }
  }

  // TODO: Improve this.
  Iterable<SubpackDirectory> _getAllSubpackDirectories(
    Iterable<TreeDirectory> directories,
  ) sync* {
    for (final directory in directories) {
      if (directory is SubpackDirectory) {
        yield directory;
      }
      yield* _getAllSubpackDirectories(directory.directories);
    }
  }

  @override
  Future<void> run() async {
    final packageRoot = await FileStructureTreeBuilder.buildFileStructureTree(
      rootDirectory: analysisParameters.rootDirectory,
      // TODO: Rename parameter.
      rootDirectories: analysisParameters.directories,
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
      _addPackages(directory, buffer);
    }
    for (final directory in _getAllSubpackDirectories(
      packageRoot.subpackDirectories,
    )) {
      final dependencies = dependenciesModel.getSubpackDependencies(
        directory,
      );
      _addDependencies(directory, buffer, dependencies);
    }
    stdout.write(buffer);
  }
}
