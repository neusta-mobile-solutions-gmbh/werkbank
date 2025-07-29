import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:subpack_analyzer/src/commands/utils/subpack_command.dart';

mixin AnalyzingCommandMixin on SubpackCommand {
  @override
  void initialize() {
    super.initialize();
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
        help: 'Adds optional directories to the analysis.',
        defaultsTo: ['lib', 'bin'],
        // TODO: Better help message.
        valueHelp: '["lib", "bin"]',
      );
  }

  late final AnalysisParameters analysisParameters = () {
    final argResults = this.argResults!;
    final rootPath = argResults.option('root');
    final analysisDirs = argResults.multiOption('analysisDirs');
    final rootDirectory = rootPath == null
        ? Directory.current
        : Directory(rootPath);
    final directories = {
      for (final dir in analysisDirs)
        Directory(p.join(rootDirectory.path, dir)),
    };

    return AnalysisParameters(
      rootDirectory: rootDirectory,
      directories: directories,
    );
  }();
}

class AnalysisParameters {
  AnalysisParameters({
    required this.rootDirectory,
    required this.directories,
  });

  final Directory rootDirectory;
  final Set<Directory> directories;
}
