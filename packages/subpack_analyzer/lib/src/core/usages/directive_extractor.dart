import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:path/path.dart' as p;
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';
import 'package:subpack_analyzer/src/core/usages/usages_model.dart';
import 'package:subpack_analyzer/src/core/utils/emotes.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_logger.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_utils.dart';

class DirectiveExtractor with SubpackLogger {
  DirectiveExtractor._directiveExtractor({required PackageRoot packageRoot})
    : _packageRoot = packageRoot;

  static ISet<Usage> extractDirectives({
    required PackageRoot packageRoot,
    required DartFile file,
  }) {
    final directiveExtractor = DirectiveExtractor._directiveExtractor(
      packageRoot: packageRoot,
    );
    return directiveExtractor._extractWithDartAnalyzer(file: file);
  }

  final PackageRoot _packageRoot;

  ISet<Usage> _extractWithDartAnalyzer({required DartFile file}) {
    logVerbose(
      '\n${Emotes.directiveOther}  Extracting directives from '
      '${SubpackUtils.getFileUri(
        rootDirectory: _packageRoot.rootDirectory,
        relativePath: file.file.path,
      )}:',
    );

    // TODO(lzuttermeister): Read version from pubspec.yaml
    final featureSet = FeatureSet.latestLanguageVersion();
    final result = parseFile(path: file.file.path, featureSet: featureSet);

    final usages = <Usage>{};

    final directives = result.unit.directives;
    for (final directive in directives) {
      if (directive is NamespaceDirective) {
        final usage = _handleNamespaceDirective(directive, file);
        if (usage != null) {
          logVerbose(
            '  - ${Emotes.directiveImport}'
            '  import: ${SubpackUtils.getFileUri(
              rootDirectory: _packageRoot.rootDirectory,
              relativePath: usage.toString(),
            )}',
          );
          usages.add(usage);
        }
      }
    }
    if (usages.isEmpty) {
      logVerbose('  ${Emotes.whiteExMark} File has no usages.');
    }
    return usages.lockUnsafe;
  }

  Usage? _handleNamespaceDirective(
    NamespaceDirective namespaceDirective,
    DartFile file,
  ) {
    final uri = Uri.parse(namespaceDirective.uri.stringValue!);

    final String path;

    if (uri.scheme == 'dart') {
      return null;
    } else if (uri.scheme == 'package') {
      final packageName = uri.pathSegments.first;
      if (packageName == _packageRoot.name) {
        path = p.joinAll(['/lib', ...uri.pathSegments.skip(1)]);
      } else {
        return PackageUsage(packageName: packageName);
      }
    } else {
      final directivePath = uri.path;
      if (p.isAbsolute(directivePath)) {
        return null;
      }
      path = directivePath;
    }

    final rootRelativePath = p.join(p.dirname(file.file.path), path);
    final treeNode = _packageRoot.fromPath(rootRelativePath);
    final localUsageType = switch (namespaceDirective) {
      ExportDirective() => LocalUsageType.export,
      ImportDirective() => LocalUsageType.import,
    };
    switch (treeNode) {
      case null:
        return null;
      case DartFile():
        return LocalUsage(dartFile: treeNode, usageType: localUsageType);
      case TreeNode():
        throw const FileSystemException(
          'If this exception is thrown '
          'somehing must be terribly wrong ☕🔥',
        );
    }
  }
}
