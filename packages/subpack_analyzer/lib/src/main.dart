import 'package:args/command_runner.dart';
import 'package:subpack_analyzer/src/commands/run/run_command.dart';

Future<void> main(List<String> args) async {
  Future<void> runCommand() async {
    // TODO(jwolyniec): Is void the corect type?
    final runner = CommandRunner<void>(
      'analyzer',
      "A super duper nice tool to analyzer your package's subpackages.",
    );
    runner.addCommand(RunCommand());
    await runner.run(args);
  }

  await runCommand();
}
