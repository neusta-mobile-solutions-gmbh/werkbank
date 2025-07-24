import 'package:args/command_runner.dart';
import 'package:meta/meta.dart';

abstract class SubpackCommand extends Command<void> {
  SubpackCommand() {
    initialize();
  }

  @mustCallSuper
  void initialize() {}
}
