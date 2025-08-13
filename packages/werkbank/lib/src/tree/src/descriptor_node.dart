import 'package:collection/collection.dart';
import 'package:werkbank/src/_internal/src/use_case/use_case.dart';
import 'package:werkbank/src/addon_config/addon_config.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/use_case.dart';

sealed class Descriptor {
  Descriptor._({
    required this.nodePath,
  });

  /// Gets the node path from root to this node, including the root node.
  final List<WerkbankNode> nodePath;

  /// Gets the node path from root to this node, excluding the root node.
  Iterable<WerkbankChildNode> get childNodePath =>
      nodePath.skip(1).cast<WerkbankChildNode>();

  List<String> get pathSegments => [
    for (final node in childNodePath) Uri.encodeComponent(node.name),
  ];

  List<String> get nameSegments => [
    for (final node in childNodePath) node.name,
  ];

  WerkbankNode get node;

  /// Gets the depth of the node within the tree.
  int get depth => nodePath.length;

  bool get isInRoot => nodePath.length == 2;

  String get path => '/${Uri(pathSegments: pathSegments)}';
}

sealed class ParentDescriptor<T extends ChildDescriptor> extends Descriptor {
  ParentDescriptor._({
    required super.nodePath,
    required this.children,
  }) : super._();

  final List<T> children;

  late final List<UseCaseDescriptor> useCases = () {
    final List<ChildDescriptor> children = this.children;
    final result = <UseCaseDescriptor>[];
    for (final child in children) {
      switch (child) {
        case ParentDescriptor(:final useCases):
          result.addAll(useCases);
        case UseCaseDescriptor():
          result.add(child);
      }
    }
    return result;
  }();

  late final List<ChildDescriptor> descendants = () {
    final List<ChildDescriptor> children = this.children;
    final result = <ChildDescriptor>[];
    for (final child in children) {
      result.add(child);
      switch (child) {
        case ParentDescriptor(:final descendants):
          result.addAll(descendants);
        case UseCaseDescriptor():
          break;
      }
    }
    return result;
  }();

  Descriptor? maybeFromPath(String path) {
    final segments = Uri.parse(path).pathSegments;
    if (segments.isEmpty) {
      return this;
    }
    final node = children.firstWhereOrNull(
      (child) => child.pathSegments.last == segments.first,
    );
    if (node == null) {
      return null;
    }
    if (segments.length == 1) {
      return node;
    }
    if (node is ParentDescriptor<ChildDescriptor>) {
      final parentNode = node as ParentDescriptor<ChildDescriptor>;
      return parentNode.maybeFromPath(
        Uri(pathSegments: segments.skip(1)).toString(),
      );
    }
    return null;
  }
}

sealed class ChildDescriptor extends Descriptor {
  ChildDescriptor._({
    required super.nodePath,
  }) : super._();

  @override
  WerkbankChildNode get node;
}

void _checkForDuplicates(
  WerkbankParentNode node,
  List<WerkbankNode> nodePath,
) {
  final currentInstances = <String>{};

  final duplicateInstances = node.children
      .map((uc) => uc.name)
      .where((name) => !currentInstances.add(name))
      .toList(growable: false);

  if (duplicateInstances.isNotEmpty) {
    final path = nodePath
        .skip(1)
        .map((node) => (node as WerkbankChildNode).name);
    throw DuplicateDescriptorPathsException(
      [
        for (final name in duplicateInstances)
          [
            ...path,
            name,
          ],
      ],
    );
  }
}

class RootDescriptor extends ParentDescriptor<ChildDescriptor> {
  RootDescriptor._({
    required super.nodePath,
    required super.children,
  }) : super._();

  factory RootDescriptor.fromWerkbankRoot(
    WerkbankRoot root,
  ) {
    final nodePath = [root];

    _checkForDuplicates(root, nodePath);

    return RootDescriptor._(
      nodePath: nodePath,
      children: [
        for (final child in root.children)
          switch (child) {
            WerkbankFolder() => _convertFolder(
              child,
              nodePath,
            ),
            WerkbankComponent() => _convertComponent(
              child,
              nodePath,
            ),
            WerkbankUseCase() => _convertUseCase(
              child,
              nodePath,
            ),
          },
      ],
    );
  }

  static FolderDescriptor _convertFolder(
    WerkbankFolder folder,
    List<WerkbankNode> path,
  ) {
    final nodePath = [...path, folder];

    _checkForDuplicates(folder, nodePath);

    return FolderDescriptor._(
      nodePath: nodePath,
      children: [
        for (final child in folder.children)
          switch (child) {
            WerkbankFolder() => _convertFolder(
              child,
              nodePath,
            ),
            WerkbankComponent() => _convertComponent(
              child,
              nodePath,
            ),
            WerkbankUseCase() => _convertUseCase(
              child,
              nodePath,
            ),
          },
      ],
    );
  }

  static ComponentDescriptor _convertComponent(
    WerkbankComponent component,
    List<WerkbankNode> path,
  ) {
    final nodePath = [...path, component];

    _checkForDuplicates(component, nodePath);

    return ComponentDescriptor._(
      nodePath: nodePath,
      children: [
        for (final child in component.children)
          _convertUseCase(
            child,
            nodePath,
          ),
      ],
    );
  }

  static UseCaseDescriptor _convertUseCase(
    WerkbankUseCase useCase,
    List<WerkbankNode> path,
  ) {
    return UseCaseDescriptor._(
      nodePath: [...path, useCase],
    );
  }

  @override
  WerkbankRoot get node => nodePath.last as WerkbankRoot;
}

class FolderDescriptor extends ParentDescriptor<ChildDescriptor>
    implements ChildDescriptor {
  FolderDescriptor._({
    required super.nodePath,
    required super.children,
  }) : assert(nodePath.isNotEmpty, 'nodePath must not be empty'),
       super._();

  @override
  WerkbankFolder get node => nodePath.last as WerkbankFolder;
}

class ComponentDescriptor extends ParentDescriptor<UseCaseDescriptor>
    implements ChildDescriptor {
  ComponentDescriptor._({
    required super.nodePath,
    required super.children,
  }) : assert(nodePath.isNotEmpty, 'nodePath must not be empty'),
       super._();

  @override
  WerkbankComponent get node => nodePath.last as WerkbankComponent;
}

class UseCaseDescriptor extends Descriptor implements ChildDescriptor {
  UseCaseDescriptor._({
    required super.nodePath,
  }) : assert(nodePath.isNotEmpty, 'nodePath must not be empty'),
       super._();

  @override
  WerkbankUseCase get node => nodePath.last as WerkbankUseCase;

  UseCaseMetadata computeMetadata(AddonConfig addonConfig) =>
      UseCaseMetadataCollector.collect(
        useCaseDescriptor: this,
        addonConfig: addonConfig,
      );
}
