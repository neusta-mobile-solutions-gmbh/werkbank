import 'dart:io';

import 'package:analyzer/dart/analysis/features.dart';
import 'package:analyzer/dart/analysis/utilities.dart';
import 'package:analyzer/dart/ast/ast.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;
import 'package:subpack_analyzer/src/core/utils/subpack_logger.dart';
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';
import 'package:subpack_analyzer/src/core/usages/usages_model.dart';
import 'package:subpack_analyzer/src/core/utils/emotes.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_utils.dart';

class DirectiveExtractor with SubpackLogger {
  DirectiveExtractor({
    required Logger logger,
    required this.packageRoot,
  }) {
    logger = logger;
  }

  final PackageRoot packageRoot;

  ISet<Usage> extractDirectives({
    required DartFile file,
  }) {
    logVerbose(
      '\n${Emotes.directiveOther}  Extracting directives from '
      '${SubpackUtils.getFileUri(
        rootDirectory: packageRoot.rootDirectory,
        relativePath: file.file.path,
      )}:',
    );
    return extractWithDartAnalyzer(file);
  }

  ISet<Usage> extractWithDartAnalyzer(DartFile file) {
    // For now this is fine
    final featureSet = FeatureSet.latestLanguageVersion();
    final result = parseFile(path: file.file.path, featureSet: featureSet);

    final usages = <Usage>{};

    final directives = result.unit.directives;
    for (final directive in directives) {
      if (directive is NamespaceDirective) {
        // TODO(jwolyniec): Differentiate import/export
        // switch (directive){
        //   case ExportDirective():
        //     // TODO: Handle this case.
        //     throw UnimplementedError();
        //   case ImportDirective():
        //     // TODO: Handle this case.
        //     throw UnimplementedError();
        // }
        final usage = handleNamespaceDirective(directive, file);
        if (usage != null) {
          logVerbose(
            '  - ${Emotes.directiveImport}'
            '  import: ${SubpackUtils.getFileUri(
              rootDirectory: packageRoot.rootDirectory,
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

  Usage? handleNamespaceDirective(
    NamespaceDirective namespaceDirective,
    DartFile file,
  ) {
    final uri = Uri.parse(namespaceDirective.uri.stringValue!);

    final String path;

    if (uri.scheme == 'dart') {
      return null;
    } else if (uri.scheme == 'package') {
      final packageName = uri.pathSegments.first;
      if (packageName == packageRoot.name) {
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
    final treeNode = packageRoot.fromPath(rootRelativePath);
    if (treeNode is DartFile) {
      return LocalUsage(dartFile: treeNode, usageType: LocalUsageType.import);
    } else {
      // TODO(jwolyniec): Finde was besseres statt der Exception
      throw FileSystemException(
        '',
      );
    }
  }
}
