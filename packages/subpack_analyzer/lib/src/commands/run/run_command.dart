import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason_logger/mason_logger.dart';

import 'package:subpack_analyzer/src/subpack_analyzer.dart';

class RunCommand extends Command<void> {
  RunCommand() {
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
  String get name => 'run';

  @override
  String get description => 'Runs the analyzer.';

  @override
  Future<void> run() async {
    final argResults = this.argResults!;
    final rootPath = argResults.option('root');
    final optionalDirectories = argResults.multiOption('analysisDirs');
    final verbose = argResults.flag('verbose');
    final useAnsi = (Platform.environment['MELOS_ROOT_PATH'] != null);

    return await runZoned(
      () async {
        final exitCode = await SubpackAnalyzer.startSubpackAnalyzer(
          rootDirectory: rootPath == null
              ? Directory.current
              : Directory(rootPath),
          optionalDirectories: optionalDirectories.toSet(),
        );
        exit(exitCode);
      },
      zoneValues: {
        #verbose: verbose,
        AnsiCode: useAnsi, // Make this true by default?
        // Also pass rootDirectory in here for 'global' access?
      },
    );
  }
}
