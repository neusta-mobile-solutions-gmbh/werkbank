import 'package:args/command_runner.dart';
import 'package:subpack_analyzer/src/commands/graph/nested_dependencies.dart';

class GraphCommand extends Command<void> {
  GraphCommand() {
    addSubcommand(NestedDependenciesCommand());
  }

  @override
  String get name => 'graph';

  @override
  String get description =>
      'Gernerates a graph representation information about the subpackages.';
}
