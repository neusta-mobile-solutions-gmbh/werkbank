import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';

enum LocalUsageType { import, export }

class UsagesModel {
  UsagesModel({
    required this.usingDirectives,
  });

  /// Imports of dart files
  final IMap<DartFile, ISet<Usage>> usingDirectives;
}

/// Import/Export classes
// TODO(jwolyniec): Implement Equatable
sealed class Usage {}

/// Represents an import to a path within the same package.
/// Ignores all Dart SDK and external package usages.
class LocalUsage extends Usage {
  LocalUsage({
    required this.dartFile,
    required this.usageType,
  });

  final DartFile dartFile;
  final LocalUsageType usageType;

  @override
  String toString() {
    return dartFile.file.uri.toString();
  }
}

/// Dart package import
class PackageUsage extends Usage {
  PackageUsage({required this.packageName});

  final String packageName;

  @override
  String toString() {
    return 'package:$packageName';
  }
}
