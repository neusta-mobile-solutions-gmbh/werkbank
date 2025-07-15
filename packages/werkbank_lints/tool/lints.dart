import 'dart:io';

import 'package:yaml/yaml.dart';

// ignore_for_file: avoid_print, avoid_dynamic_calls

final allLints = getLinterRulesFromPath('tool/lints/all.yaml');

final blacklistedLints = getLinterRulesFromPath('tool/lints/blacklisted.yaml');

final lintsFlutterPackageLints =
    getLinterRulesFromPath('tool/lints/lints_flutter/flutter.yaml')
        .union(getLinterRulesFromPath('tool/lints/lints/recommended.yaml'))
        .union(getLinterRulesFromPath('tool/lints/lints/core.yaml'));

final werkbankLintsPackageLints = getLinterRulesFromPath(
  'lib/werkbank_lints.yaml',
);

Set<String> getLinterRulesFromPath(String path) {
  return getLinterRules(File(path).readAsStringSync());
}

Set<String> getLinterRules(String yaml) {
  return (loadYaml(yaml)['linter']['rules'] as YamlList)
      .map((dynamic e) => e as String)
      .toSet();
}

void printLintSet(Set<String> lints) {
  for (final l in lints.toList()..sort()) {
    print('- $l');
  }
}
