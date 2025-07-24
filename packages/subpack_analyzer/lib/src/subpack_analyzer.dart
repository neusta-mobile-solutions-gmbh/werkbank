import 'dart:io';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:subpack_analyzer/src/core/analyzer/analyzer.dart';
import 'package:subpack_analyzer/src/core/analyzer/analyzer_model.dart';
import 'package:subpack_analyzer/src/core/dependencies/dependencies_model.dart';
import 'package:subpack_analyzer/src/core/dependencies/depenencies_builder.dart';
import 'package:subpack_analyzer/src/core/relations/relations_builder.dart';
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_builder.dart';
import 'package:subpack_analyzer/src/core/usages/usages_builder.dart';
import 'package:subpack_analyzer/src/core/utils/emotes.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_error.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_logger.dart';

Set<String> _defaultAnalysisDirectories = {'lib', 'bin'};
String _banner = r"""

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

class SubpackAnalyzer with SubpackLogger {
  SubpackAnalyzer._subpackAnalyzer({
    Set<String> optionalDirectories = const {},
    required Directory rootDirectory,
  }) : _rootDirectory = rootDirectory,
       _topLevelDirectories = {
         ..._defaultAnalysisDirectories,
         ...optionalDirectories,
       };

  final Directory _rootDirectory;

  /// All top-level directories that are taken into consideration
  /// for the subpackage analysis.
  final Set<String> _topLevelDirectories;

  static Future<int> startSubpackAnalyzer({
    required Directory rootDirectory,
    Set<String> optionalDirectories = const {},
  }) {
    final subpackAnalyzer = SubpackAnalyzer._subpackAnalyzer(
      optionalDirectories: optionalDirectories,
      rootDirectory: rootDirectory,
    );
    return subpackAnalyzer._startAnalyzing();
  }

  Future<int> _startAnalyzing() async {
    logInfo(_banner);
    logInfo('\n\n>> Starting analysis...');

    final packageRoot = await FileStructureTreeBuilder.buildFileStructureTree(
      rootDirectory: _rootDirectory,
      rootDirectories: _topLevelDirectories,
      logger: logger,
    );

    final dependenciesModel = await DependenciesBuilder.buildDependencies(
      packageRoot: packageRoot,
      logger: logger,
    );
    switch (dependenciesModel) {
      case DependenciesFailiureModel():
        return finalizeAnalysis(exitCode: 1, errors: dependenciesModel.errors);
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
        return finalizeAnalysis(exitCode: 1, errors: result.errors);
      case AnalyzerSuccessModel():
    }

    return finalizeAnalysis(exitCode: 0, errors: null);
  }

  Future<int> finalizeAnalysis({
    required int exitCode,
    required ISet<SubpackError>? errors,
  }) async {
    logFinish('\n${Emotes.finishFlag} Finished!');

    if (errors != null) {
      for (final error in errors) {
        logError(error.errorMessage);
      }
      final errorCountString = errors.length == 1
          ? '1 error has been found!'
          : '${errors.length} errors have been found!';
      logAttention(
        '\n${Emotes.redExMark} $errorCountString',
      );
    } else {
      logSuccess('\n${Emotes.checkmark} No errors have been found!');
    }
    return exitCode;
  }
}
