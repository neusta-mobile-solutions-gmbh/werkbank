import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mason_logger/mason_logger.dart';

import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';
import 'package:subpack_analyzer/src/core/usages/usages_model.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_error.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_utils.dart';

sealed class AnalyzerError extends SubpackError {}

class SubpackageIsReferencingOwnPackageError implements AnalyzerError {
  SubpackageIsReferencingOwnPackageError({
    required this.subpackDirectory,
    required this.packageName,
  });

  final SubpackDirectory subpackDirectory;
  final String packageName;

  @override
  String get errorMessage {
    final subpackUri = SubpackUtils.getFileUriFromPath(
      subpackDirectory.directory.path,
    );
    final subpackLink = link(uri: subpackUri, message: 'subpackage');

    return '\nThe $subpackLink references the containing package $packageName'
        " in it's dependencies.";
  }
}

class UndependedPackageUsageError extends AnalyzerError {
  UndependedPackageUsageError({
    required this.packageRoot,
    required this.dartFile,
    required this.usage,
    required this.fileContainingSubpacks,
  });

  final PackageRoot packageRoot;
  final DartFile dartFile;
  final PackageUsage usage;
  final ISet<SubpackDirectory> fileContainingSubpacks;

  @override
  String get errorMessage {
    final relativePath = dartFile.file.path;

    final dartFileLink = link(
      message: relativePath,
      uri: SubpackUtils.getFileUri(
        rootDirectory: packageRoot.rootDirectory,
        relativePath: relativePath,
        isRunningInVSCodeTerminal: SubpackUtils.isRunningInVSCodeTerminal(),
      ),
    );

    final containingSubpacks = SubpackUtils.createSubpackLinks(
      packageRoot.rootDirectory,
      fileContainingSubpacks,
    );

    return '\nThe file $dartFileLink uses the ${usage.packageName} package but'
        ' the usage is not depended on.\n'
        'To fix this error depend on one of the subpacks that are exposing the'
        ' usage. The dependency has to be added in one of the subpacks'
        ' containing the file.\n'
        'The file is contained in these subpacks:\n$containingSubpacks';
  }
}

class UndependedLocalUsageError implements AnalyzerError {
  UndependedLocalUsageError({
    required this.packageRoot,
    required this.dartFile,
    required this.usage,
    required this.fileContainingSubpacks,
    required this.usageExposingSubpacks,
  });

  final PackageRoot packageRoot;
  final DartFile dartFile;
  final LocalUsage usage;
  final ISet<SubpackDirectory> fileContainingSubpacks;
  final ISet<SubpackDirectory> usageExposingSubpacks;

  @override
  String get errorMessage {
    final relativePath = dartFile.file.path;

    final dartFileLink = link(
      message: relativePath,
      uri: SubpackUtils.getFileUri(
        rootDirectory: packageRoot.rootDirectory,
        relativePath: relativePath,
        isRunningInVSCodeTerminal: SubpackUtils.isRunningInVSCodeTerminal(),
      ),
    );

    final usageUri = SubpackUtils.getLocalUsageUri(
      packageRoot: packageRoot,
      usage: usage,
    );

    final usageLink = link(uri: usageUri, message: usage.dartFile.file.path);

    final containingSubpacks = SubpackUtils.createSubpackLinks(
      packageRoot.rootDirectory,
      fileContainingSubpacks,
    );

    final localUsageTypeString = switch (usage.usageType) {
      LocalUsageType.import => 'imported',
      LocalUsageType.export => 'exported',
    };

    final exposingSubpacks = usageExposingSubpacks.isEmpty
        ? '\nThe usage is not esposed in any subpacks.'
        : 'The $localUsageTypeString file is exposed in the following subpacks:'
              '\n${SubpackUtils.createSubpackLinks(
                packageRoot.rootDirectory,
                usageExposingSubpacks,
              )}';

    return '\nThe file $dartFileLink uses $usageLink but the usage is not'
        ' depended on.\n'
        'To fix this error depend on one of the subpacks that expose the '
        'used file. The dependency has to be added in one of the subpacks '
        'containing the file.\n'
        'The file is contained in these subpacks:\n$containingSubpacks'
        '$exposingSubpacks';
  }
}
