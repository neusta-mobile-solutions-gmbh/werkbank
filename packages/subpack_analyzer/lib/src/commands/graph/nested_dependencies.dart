import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:subpack_analyzer/src/core/dependencies/dependencies_model.dart';
import 'package:subpack_analyzer/src/core/dependencies/depenencies_builder.dart';
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_builder.dart';
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_logger.dart';

import 'package:subpack_analyzer/src/subpack_analyzer.dart';

class NestedDependenciesCommand extends Command<void> with SubpackLogger {
  NestedDependenciesCommand() {
    argParser
      ..addOption(
        'root',
        abbr: 'r',
        help:
            'Specifies the root directory where the subpack analysis begins. '
            'All paths used during the analysis will be resolved relative to'
            ' this directory.',
        valueHelp: './path/to/project',
      )
      ..addMultiOption(
        'analysisDirs',
        abbr: 'o',
        help:
            'Adds optional directories to the analysis. "lib" and "bin" are'
            ' included by default.',
        // TODO: Add this to analyzer as well.
        defaultsTo: ['lib', 'bin'],
        valueHelp: '["tool", "assets"]',
      )
      ..addFlag(
        'verbose',
        abbr: 'v',
        negatable: false,
        help: 'Enables additional log messages during the analysis process.',
      );
  }

  @override
  String get name => 'nested-dependencies';

  @override
  String get description =>
      'Creates a nested dependencies graph of the subpackages.';

  // Uses mermaid syntax.
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
    final argResults = this.argResults!;
    final rootPath = argResults.option('root');
    final rootDirectory = rootPath == null
        ? Directory.current
        : Directory(rootPath);
    final optionalDirectories = argResults.multiOption('analysisDirs');
    final verbose = argResults.flag('verbose');
    final useAnsi = (Platform.environment['MELOS_ROOT_PATH'] != null);

    return await runZoned(
      () async {
        final packageRoot =
            await FileStructureTreeBuilder.buildFileStructureTree(
              rootDirectory: rootDirectory,
              rootDirectories: optionalDirectories.toSet(),
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
        print(buffer.toString());
      },
      zoneValues: {
        #verbose: verbose,
        AnsiCode: useAnsi, // Make this true by default?
        // Also pass rootDirectory in here for 'global' access?
      },
    );
  }
}
