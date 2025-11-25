import 'package:analysis_server_plugin/plugin.dart';
import 'package:analysis_server_plugin/registry.dart';
import 'package:werkbank_lints/src/rules/consistent_argument_ordering_rule.dart';
import 'package:werkbank_lints/src/rules/consistent_initializing_formal_parameter_ordering_rule.dart';
import 'package:werkbank_lints/src/rules/consistent_super_parameter_ordering_rule.dart';

final plugin = WerkbankLintsPlugin();

class WerkbankLintsPlugin extends Plugin {
  @override
  void register(PluginRegistry registry) {
    registry.registerWarningRule(
      ConsistentInitializingFormalParameterOrderingRule(),
    );
    registry.registerWarningRule(
      ConsistentSuperParameterOrderingRule(),
    );
    registry.registerWarningRule(
      ConsistentArgumentOrderingRule(),
    );
  }

  @override
  String get name => 'werkbank_lints_plugin';
}
