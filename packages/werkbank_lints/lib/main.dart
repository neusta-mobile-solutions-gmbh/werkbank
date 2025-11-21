import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:werkbank_lints/src/rules/consistent_initializing_formal_parameter_ordering_rule.dart';
import 'package:werkbank_lints/src/rules/consistent_super_parameter_ordering_rule.dart';

final plugin = SimplePlugin();

class SimplePlugin extends Plugin {
  @override
  void register(PluginRegistry registry) {
    registry.registerWarningRule(
      ConsistentInitializingFormalParameterOrderingRule(),
    );
    registry.registerWarningRule(
      ConsistentSuperParameterOrderingRule(),
    );
  }

  @override
  String get name => 'werkbank_lints_plugin';
}
