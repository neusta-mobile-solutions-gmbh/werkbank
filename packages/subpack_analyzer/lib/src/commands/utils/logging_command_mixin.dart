import 'dart:async';
import 'dart:io';
import 'package:mason_logger/mason_logger.dart';
import 'package:subpack_analyzer/src/commands/utils/exit_code.dart';
import 'package:subpack_analyzer/src/commands/utils/subpack_command.dart';

mixin LoggingCommandMixin on SubpackCommand {
  @override
  void initialize() {
    super.initialize();
    argParser.addFlag(
      'verbose',
      abbr: 'v',
      negatable: false,
      help: 'Enables additional log messages during the analysis process.',
    );
  }

  @override
  Future<SubpackExitCode> run() async {
    final argResults = this.argResults!;
    final verbose = argResults.flag('verbose');
    bool? supportAnsi;
    if (Platform.environment['MELOS_ROOT_PATH'] != null) {
      // Melos seems to disable Ansi support even though it is supported.
      supportAnsi = true;
    }
    if (Platform.environment['CI'] == 'true') {
      // CI environments usually do not support Ansi codes.
      supportAnsi = false;
    }

    return await runZoned(
      () => super.run(),
      zoneValues: {
        #verbose: verbose,
        if (supportAnsi != null) AnsiCode: supportAnsi,
      },
    );
  }
}
