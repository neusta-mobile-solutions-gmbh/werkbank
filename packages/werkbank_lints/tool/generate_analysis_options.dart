import 'dart:io';
import 'lints.dart';

final instantLintsFile = File('./lib/werkbank_lints.yaml');

Future<void> main() async {
  final oldLints = werkbankLintsPackageLints;

  final newLints = allLints
      .difference(blacklistedLints)
      .difference(lintsFlutterPackageLints);
  print('Added Lints:');
  printLintSet(newLints.difference(oldLints));

  print('\nRemoved Lints:');
  printLintSet(oldLints.difference(newLints));

  await instantLintsFile.writeAsString(generateYaml(newLints), flush: true);
}

String generateYaml(Set<String> lints) {
  return '''
include: package:flutter_lints/flutter.yaml

formatter:
  trailing_commas: preserve

analyzer:
  language:
    strict-casts: true
    strict-inference: true
    strict-raw-types: true

linter:
  rules:
${(lints.toList()..sort()).map((l) => '    - $l').join('\n')}
  ''';
}
