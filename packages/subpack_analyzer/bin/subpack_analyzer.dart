import 'package:args/command_runner.dart';
import 'package:subpack_analyzer/src/commands/run/run_command.dart';

void main(List<String> args) {
  void runCommand() {
    CommandRunner(
        "analyzer",
        "A super duper nice tool to analyzer your package's subpackages.",
      )
      ..addCommand(RunCommand())
      ..run(args);
  }

  runCommand();
}
