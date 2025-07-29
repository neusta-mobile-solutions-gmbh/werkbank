import 'dart:async';
import 'dart:io';

import 'package:subpack_analyzer/src/commands/utils/analyzing_command_mixin.dart';
import 'package:subpack_analyzer/src/commands/utils/logging_command_mixin.dart';
import 'package:subpack_analyzer/src/commands/utils/subpack_command.dart';

import 'package:subpack_analyzer/src/subpack_analyzer.dart';

class RunCommand extends SubpackCommand
    with AnalyzingCommandMixin, LoggingCommandMixin {
  @override
  String get name => 'run';

  @override
  String get description => 'Runs the analyzer.';

  @override
  Future<void> run() async {
    final exitCode = await SubpackAnalyzer.startSubpackAnalyzer(
      rootDirectory: analysisParameters.rootDirectory,
      analysisDirectories: analysisParameters.directories,
    );
    exit(exitCode);
  }
}
