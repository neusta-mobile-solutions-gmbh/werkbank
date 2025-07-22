import 'lints.dart';

// ignore_for_file: avoid_print

Future<void> main() async {
  final goalLints = allLints.difference(blacklistedLints);
  print('The flutter_lints package is missing:');
  printLintSet(goalLints.difference(lintsFlutterPackageLints));
  print('\nThe flutter_lints package has extra lints:');
  printLintSet(lintsFlutterPackageLints.difference(goalLints));
}
