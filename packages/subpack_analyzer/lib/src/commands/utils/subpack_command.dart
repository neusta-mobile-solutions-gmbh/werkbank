import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';
import 'package:subpack_analyzer/src/commands/utils/exit_code.dart';

abstract class SubpackCommand extends Command<SubpackExitCode> {
  SubpackCommand() {
    initialize();
  }

  @mustCallSuper
  void initialize() {}

  // For some reason, this cannot be abstract.
  @override
  FutureOr<SubpackExitCode> run() => throw UnimplementedError();
}
