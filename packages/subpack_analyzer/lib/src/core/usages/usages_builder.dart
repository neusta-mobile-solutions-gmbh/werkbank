import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';
import 'package:subpack_analyzer/src/core/usages/usages_model.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_logger.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_utils.dart';
import 'package:subpack_analyzer/src/directive_extractor.dart';

/// Builds a model of all import and export usages within a package by
/// traversing its directory tree. Collects usage information for each
/// Dart file and tracks the deepest source directory for each file.
class UsagesBuilder with SubpackLogger {
  UsagesBuilder._usagesBuilder({
    required PackageRoot packageRoot,
  }) : _packageRoot = packageRoot;

  /// Builds and returns a [UsagesModel] for the given [packageRoot].
  /// This function analyzes all Dart files in the package and collects their import/export usages.
  static Future<UsagesModel> buildUsages({
    required PackageRoot packageRoot,
    required Logger logger,
  }) {
    final usagesBuilder = UsagesBuilder._usagesBuilder(
      packageRoot: packageRoot,
    );
    return usagesBuilder._buildUsagesModel();
  }

  final PackageRoot _packageRoot;

  final _usingDirectives = <DartFile, ISet<Usage>>{};
  final _deepestSrcDirectory = <DartFile, TreeDirectory?>{};

  Future<UsagesModel> _buildUsagesModel() async {
    logVerbose('\n\n>> Collecting usages...');
    for (final directory in _packageRoot.subpackDirectories) {
      await _handleDirectory(
        directory: directory,
        isDirInSubpack: true,
        srcDirectory: null,
      );
    }

    return UsagesModel(
      usingDirectives: _usingDirectives.lock,
      deepestSrcDirectory: _deepestSrcDirectory.lock,
    );
  }

  Future<void> _handleDirectory({
    required TreeDirectory directory,
    required bool isDirInSubpack,
    required TreeDirectory? srcDirectory,
  }) async {
    final splitPath = p.split(directory.directory.path);
    final currentIsSrcDirectory = isDirInSubpack && splitPath.last == src;

    final TreeDirectory? newSrcDirectory;
    if (currentIsSrcDirectory) {
      newSrcDirectory = directory;
    } else if (directory is! SubpackDirectory) {
      newSrcDirectory = srcDirectory;
    } else {
      newSrcDirectory = null;
    }

    for (final file in directory.dartFiles) {
      _handleDartFile(
        file: file,
        srcDirectory: newSrcDirectory,
      );
    }

    for (final directory in directory.directories) {
      await _handleDirectory(
        directory: directory,
        isDirInSubpack: directory is SubpackDirectory,
        srcDirectory: newSrcDirectory,
      );
    }
  }

  void _handleDartFile({
    required DartFile file,
    required TreeDirectory? srcDirectory,
  }) {
    final usages = DirectiveExtractor.extractDirectives(
      packageRoot: _packageRoot,
      file: file,
    );

    _usingDirectives[file] = usages;

    if (srcDirectory != null) _deepestSrcDirectory[file] = srcDirectory;
  }
}
