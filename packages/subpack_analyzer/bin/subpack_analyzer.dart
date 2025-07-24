import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:subpack_analyzer/src/commands/graph/graph.dart';
import 'package:subpack_analyzer/src/commands/run/run_command.dart';

Future<void> main(List<String> args) async {
  final runner = CommandRunner<void>(
    'subpack_analyzer',
    "A tool to analyzer your dart package's subpackages.",
  );
  runner.addCommand(RunCommand());
  runner.addCommand(GraphCommand());
  try {
    await runner.run(args);
  } on UsageException catch (e) {
    stdout.writeln(e.message);
    exit(64);
  }
}
