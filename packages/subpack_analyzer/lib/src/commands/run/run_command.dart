import 'dart:async';
import 'dart:io';

import 'package:subpack_analyzer/src/commands/utils/analyzing_command_mixin.dart';
import 'package:subpack_analyzer/src/commands/utils/exit_code.dart';
import 'package:subpack_analyzer/src/commands/utils/logging_command_mixin.dart';
import 'package:subpack_analyzer/src/commands/utils/subpack_command.dart';
import 'package:subpack_analyzer/src/core/analyzer/analyzer.dart';
import 'package:subpack_analyzer/src/core/analyzer/analyzer_model.dart';
import 'package:subpack_analyzer/src/core/dependencies/dependencies_model.dart';
import 'package:subpack_analyzer/src/core/dependencies/depenencies_builder.dart';
import 'package:subpack_analyzer/src/core/relations/relations_builder.dart';
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_builder.dart';
import 'package:subpack_analyzer/src/core/usages/usages_builder.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_logger.dart';

class RunCommand extends SubpackCommand
    with LoggingCommandMixin, SubpackLogger, AnalyzingCommandMixin {
  @override
  String get name => 'run';

  @override
  String get description => 'Runs the analyzer.';

  static const String _banner = r"""

 ,-.      .               ,
(   `     |               |
 `-.  . . |-. ;-. ,-: ,-. | ,
.   ) | | | | | | | | |   |<
 `-'  `-` `-' |-' `-` `-' ' `
              '
       ,.          .
      /  \         |
      |--| ;-. ,-: | . . ,-, ,-. ;-.
      |  | | | | | | | |  /  |-' |
      '  ' ' ' `-` ' `-| '-' `-' '
                     `-'
                     """;

  @override
  Future<SubpackExitCode> run() async {
    logInfo(_banner);
    logInfo('\n\n>> Starting analysis...');

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
        return finalizeAnalysis(
          exitCode: SubpackExitCode.invalidDependencies,
          errors: dependenciesModel.errors,
        );
      case DependenciesSuccessModel():
    }

    final usagesModel = await UsagesBuilder.buildUsages(
      packageRoot: packageRoot,
      logger: logger,
    );

    final relations = await RelationsBuilder.buildRelations(
      logger: logger,
      packageRoot: packageRoot,
    );

    final result = await Analyzer.analyzeRelations(
      relations: relations,
      packageRoot: packageRoot,
      logger: logger,
      dependencies: dependenciesModel,
      usages: usagesModel,
    );
    switch (result) {
      case AnalyzerFailiureModel():
        return finalizeAnalysis(
          exitCode: SubpackExitCode.undependedUsages,
          errors: result.errors,
        );
      case AnalyzerSuccessModel():
    }

    return finalizeAnalysis(exitCode: SubpackExitCode.success, errors: null);
  }
}
