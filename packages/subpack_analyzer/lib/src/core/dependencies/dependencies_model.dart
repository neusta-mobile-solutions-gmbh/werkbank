import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:subpack_analyzer/src/core/dependencies/dependencies_error_model.dart';
import 'package:subpack_analyzer/src/core/tree_structure/file_structure_tree_model.dart';

sealed class DependenciesModel {}

class DependenciesSuccessModel extends DependenciesModel {
  DependenciesSuccessModel({
    required IMap<SubpackDirectory, ISet<Dependency>> subpackDependencies,
  }) : _subpackDependencies = subpackDependencies;

  /// Dependencies on other subpackages
  final IMap<SubpackDirectory, ISet<Dependency>> _subpackDependencies;

  ISet<Dependency> getSubpackDependencies(SubpackDirectory subpackDirectory) {
    return _subpackDependencies[subpackDirectory] ?? const ISet.empty();
  }
}

class DependenciesFailiureModel extends DependenciesModel {
  DependenciesFailiureModel({required this.errors});

  final ISet<DependenciesError> errors;
}

sealed class Dependency {}

class SubpackageDependency extends Dependency with EquatableMixin {
  SubpackageDependency({required this.subpackDirectory});

  final SubpackDirectory subpackDirectory;

  @override
  String toString() {
    return subpackDirectory.directory.path;
  }

  @override
  List<Object?> get props => [subpackDirectory];
}

class DartPackageDependency extends Dependency {
  DartPackageDependency({required this.name});

  final String name;

  @override
  String toString() {
    return name;
  }
}
