import 'dart:io';

import 'package:mason_logger/mason_logger.dart';
import 'package:path/path.dart' as p;
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';
import 'package:subpack_analyzer/src/core/utils/emotes.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_logger.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_utils.dart';

/// Creates a file structure tree of all directories and files contained
/// in the Directory rootDirectory for the analysis.
class FileStructureTreeBuilder with SubpackLogger {
  FileStructureTreeBuilder._fileStructureTreeBuilder({
    required Directory rootDirectory,
    required Set<String> rootDirectories,
  }) : _rootDirectories = rootDirectories,
       _rootDirectory = rootDirectory;

  static Future<PackageRoot> buildFileStructureTree({
    required Directory rootDirectory,
    required Set<String> rootDirectories,
    required Logger logger,
  }) {
    final fileStructureBuilder =
        FileStructureTreeBuilder._fileStructureTreeBuilder(
          rootDirectory: rootDirectory,
          rootDirectories: rootDirectories,
        );
    return fileStructureBuilder._buildFileStructureTree();
  }

  final String _dartExtension = '.dart';
  final Directory _rootDirectory;
  final Set<String> _rootDirectories;

  /// Initializes build of a tree structure for the subpackage analysis.
  Future<PackageRoot> _buildFileStructureTree() async {
    logVerbose('\n${Emotes.hammer} Building file tree structure...');
    final directories = <Directory>[];

    for (final dirPath in _rootDirectories) {
      final dirExists = await Directory(
        p.join(_rootDirectory.path, dirPath),
      ).exists();
      if (dirExists) {
        final dir = Directory(dirPath);
        directories.add(dir);
      } else {
        logVerboseWarning(
          '${Emotes.indexFinger} Directory "$dirPath" '
          'does not exist in $_rootDirectory.',
        );
      }
    }

    final treeDirectories = <TreeDirectory>[];

    for (final directory in directories) {
      final treeDirectory = await _handleDirectory(directory, isToplevel: true);
      treeDirectories.add(treeDirectory);
    }

    final packageRoot = PackageRoot(
      subpackDirectories: treeDirectories.cast(),
      rootDirectory: _rootDirectory,
    );
    await _printFileTree(packageRoot);
    return packageRoot;
  }

  /// Lists all file entities of the entry directory and records all relevant
  /// files, then handles nested directories as well, and finallty returns
  /// - A: a subpackage
  /// - B: a normal tree directory
  ///
  /// with all the collected data.
  Future<TreeDirectory> _handleDirectory(
    Directory entry, {
    bool isToplevel = false,
  }) async {
    final directories = <Directory>[];
    final treeFiles = <DartFile>[];
    final treeDirectories = <TreeDirectory>[];

    SubpackFile? subpackFile;

    // Split files from directories, handle them separately
    await for (final entity in entry.list(followLinks: false)) {
      if (entity is Directory) {
        directories.add(entity);
      }
      if (entity is File) {
        final treeNode = _handleFile(entity);
        if (treeNode != null) {
          switch (treeNode) {
            case SubpackFile():
              assert(
                subpackFile == null,
                'There must only be one subpack.yaml file!',
              );
              subpackFile = treeNode;
            case DartFile():
              treeFiles.add(treeNode);
          }
        }
      }
    }

    // Now process each subdirectory
    for (final dir in directories) {
      final treeDirectory = await _handleDirectory(dir);
      treeDirectories.add(treeDirectory);
    }

    // Directory has a subpackage, therefore is a subpack directory
    if (isToplevel || subpackFile != null) {
      return SubpackDirectory(
        directories: treeDirectories,
        dartFiles: treeFiles,
        directory: entry,
        subpackFile: subpackFile,
      );
    }

    // Not a subpackage directory
    return DirectoryNode(
      directories: treeDirectories,
      dartFiles: treeFiles,
      directory: entry,
    );
  }

  TreeFile? _handleFile(File file) {
    if (p.extension(file.path) == _dartExtension) {
      return DartFile(file: file);
    } else if (p.basename(file.path) == subpackFileName) {
      return SubpackFile(file: file);
    }
    return null;
  }

  Future<void> _printFileTree(PackageRoot filetree) async {
    logVerbose('\n- - - ${Emotes.tree} File Tree - - -\n');
    for (final directory in filetree.subpackDirectories) {
      await _printSubDirectory(directory, 1);
    }
    logVerbose('\n- - - - - - - - - - -\n');
  }

  Future<void> _printSubDirectory(
    TreeDirectory filetree,
    int level,
  ) async {
    final levelIndent = StringBuffer();
    for (var i = 0; i < level - 1; i++) {
      levelIndent.write('  ');
    }
    logVerbose(
      '$levelIndent${Emotes.folder} '
      '${SubpackUtils.getFileUriFromPath(filetree.directory.path)}:',
    );
    levelIndent.write('  ');
    for (final file in filetree.dartFiles) {
      logVerbose('$levelIndent${Emotes.file} ${file.file.uri}');
    }
    for (final directory in filetree.directories) {
      await _printSubDirectory(directory, level + 1);
    }
  }
}
