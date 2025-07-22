mixin OrderExecutor {
  List<Descriptor> orderFlattenedTree(
    Descriptor descriptor,
    OrderOption orderOption, {
    required bool includeParents,
  }) {
    final orderedChilden = switch (descriptor) {
      ParentDescriptor(:final children) => orderChildren(children, orderOption),
      UseCaseDescriptor() => null,
    };
    return [
      if (includeParents || orderedChilden == null) descriptor,
      if (orderedChilden != null)
        for (final child in orderedChilden)
          ...orderFlattenedTree(
            child,
            orderOption,
            includeParents: includeParents,
          ),
    ];
  }

  List<T> orderChildren<T extends ChildDescriptor>(
    List<T> descriptors,
    OrderOption orderOption,
  ) {
    switch (orderOption) {
      case OrderOption.alphabetic:
        return _orderChildrenAlphabetically(descriptors);
      case OrderOption.code:
        return descriptors;
    }
  }

  List<T> _orderChildrenAlphabetically<T extends ChildDescriptor>(
    List<T> descriptors,
  ) {
    final results = descriptors.toList()
      ..sort(
        (a, b) {
          int getTypePriority(T item) {
            if (item is RootDescriptor) return 1;
            if (item is FolderDescriptor) return 2;
            if (item is ComponentDescriptor) return 3;
            if (item is UseCaseDescriptor) return 3;
            throw Exception('Unknown type');
          }

          final priorityA = getTypePriority(a);
          final priorityB = getTypePriority(b);

          if (priorityA != priorityB) {
            return priorityA.compareTo(priorityB);
          } else {
            return a.node.name.compareTo(b.node.name);
          }
        },
      );
    return results;
  }
}
