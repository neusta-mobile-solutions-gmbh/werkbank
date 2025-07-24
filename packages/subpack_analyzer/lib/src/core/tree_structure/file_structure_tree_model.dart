import 'dart:io';

import 'package:path/path.dart' as p;

sealed class TreeNode {
  TreeNode? _fromPath(Iterable<String> pathSegments);

  FileSystemEntity get _fileSystemEntity;

  String get name => p.basename(_fileSystemEntity.path);
}

sealed class TreeFile extends TreeNode {
  TreeFile({required this.file});

  final File file;

  @override
  TreeNode? _fromPath(Iterable<String> pathSegments) {
    if (pathSegments.isEmpty) {
      return this;
    } else {
      return null;
    }
  }

  @override
  FileSystemEntity get _fileSystemEntity => file;
}

/// A tree node holding a dart file
class DartFile extends TreeFile {
  DartFile({required super.file});
}

class SubpackFile extends TreeFile {
  SubpackFile({required super.file});
}

/// Generic directory in the tree
sealed class TreeDirectory extends TreeNode {
  TreeDirectory({
    required this.directories,
    required this.dartFiles,
    required this.directory,
  });

  final List<TreeDirectory> directories;
  final List<DartFile> dartFiles;
  final Directory directory;

  @override
  TreeNode? _fromPath(Iterable<String> pathSegments) {
    if (pathSegments.isEmpty) return this;

    final firstSegment = pathSegments.first;

    for (final treeNode in [...directories, ...dartFiles]) {
      if (treeNode.name == firstSegment) {
        return treeNode._fromPath(pathSegments.skip(1));
      }
    }
    return null;
  }

  @override
  FileSystemEntity get _fileSystemEntity => directory;
}

/// A normal directory in the tree
class DirectoryNode extends TreeDirectory {
  DirectoryNode({
    required super.directories,
    required super.dartFiles,
    required super.directory,
  });
}

/// A subpack directory in the tree
class SubpackDirectory extends TreeDirectory {
  SubpackDirectory({
    required super.directories,
    required super.dartFiles,
    required super.directory,
    required this.subpackFile,
  });

  /// Nullable because directories like lib, bin, and test do not have a subpack file,
  /// but are still considered subpack directories by default.
  final SubpackFile? subpackFile;
}

/// The root directory of the tree
class PackageRoot {
  PackageRoot({
    required this.subpackDirectories,
    required this.rootDirectory,
  });

  final List<SubpackDirectory> subpackDirectories;
  final Directory rootDirectory;

  /// Returns the [TreeNode] corresponding to the given [path] within the package tree,
  /// or null if the path does not exist. The path is resolved relative to [rootDirectory].
  TreeNode? fromPath(String path) {
    final pathSegments = Uri.file(path).pathSegments;
    return DirectoryNode(
      directories: subpackDirectories,
      dartFiles: [],
      directory: rootDirectory,
    )._fromPath(pathSegments);
  }

  String get name => p.basename(rootDirectory.path);
}
