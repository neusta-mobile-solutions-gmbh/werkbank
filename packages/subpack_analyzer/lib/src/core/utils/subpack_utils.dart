import 'dart:async';
import 'dart:io';

import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';
import 'package:subpack_analyzer/src/core/usages/usages_model.dart';
import 'package:yaml/yaml.dart';

const String subpackFileName = 'subpack.yaml';
const String src = 'src';

class SubpackUtils {
  SubpackUtils._();

  static RegExp validPackageNamePattern = RegExp(r'^[a-z_][a-z0-9_]*$');

  /// Returns the content read from a yaml file.
  static Future<YamlMap?> readYaml(String filePath) async {
    final subpackFile = File(filePath);
    final content = await subpackFile.readAsString();
    final doc = loadYaml(content) as YamlMap?;
    return doc;
  }

  /// Returns the absolute path to the system file for the relativePath
  static String getAbsoluteFilePath({
    required Directory rootDirectory,
    required String relativePath,
  }) {
    return p.join(rootDirectory.path, relativePath);
  }

  /// Returns a file Uri with path.
  static Uri getFileUriFromPath(String path) {
    return Uri(
      path: path,
      scheme: 'file',
    );
  }

  /// Returns an Uri with an absolute file path build from the relative path.
  /// Optional: Creates the Uri with the vscode-scheme if
  /// isRunningInVSCodeTerminal is true, which enables links that are using
  /// this uri to open files in the same vscode editor window.
  static Uri getFileUri({
    required Directory rootDirectory,
    required String relativePath,
    bool isRunningInVSCodeTerminal = false,
  }) {
    final absoluteFilePath = getAbsoluteFilePath(
      rootDirectory: rootDirectory,
      relativePath: relativePath,
    );
    return isRunningInVSCodeTerminal
        ? Uri.parse('vscode://file$absoluteFilePath')
        : Uri(path: absoluteFilePath, scheme: 'file');
  }

  /// Returns a Uri for a local usage.
  static Uri getLocalUsageUri({
    required PackageRoot packageRoot,
    required LocalUsage usage,
  }) {
    return SubpackUtils.getFileUri(
      rootDirectory: packageRoot.rootDirectory,
      relativePath: usage.dartFile.file.path,
    );
  }

  /// Returns whether the program runs in vscode
  static bool isRunningInVSCodeTerminal() {
    final env = Platform.environment;
    return env.containsKey('TERM_PROGRAM') && env['TERM_PROGRAM'] == 'vscode' ||
        env.containsKey('VSCODE_PID');
  }

  /// Creates a string listing all relative subpack paths in subpacks.
  static String createSubpackLinks(
    Directory rootDirectory,
    ISet<SubpackDirectory> subpacks,
  ) {
    final subpackLinks = StringBuffer();
    for (final subpackDir in subpacks) {
      final relativePath = subpackDir.directory.path;

      if (subpackDir.subpackFile == null) {
        subpackLinks.writeln('- $relativePath');
      } else {
        subpackLinks.writeln(
          '- ${link(
            message: relativePath,
            uri: SubpackUtils.getFileUri(
              rootDirectory: rootDirectory,
              relativePath: p.join(relativePath, subpackFileName),
              isRunningInVSCodeTerminal: isRunningInVSCodeTerminal(),
            ),
          )}',
        );
      }
    }
    return subpackLinks.toString();
  }

  /// Returns wether packageName is valid by [this definition](https://dart.dev/tools/linter-rules/package_names).
  /// Does not check for reserved words!
  static bool isValidPackageName(String packageName) {
    return validPackageNamePattern.hasMatch(packageName);
  }

  static bool get isVerbose => Zone.current[#verbose] == true;
}
