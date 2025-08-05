import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:werkbank/src/_internal/src/filter/src/search_cluster_result.dart';
import 'package:werkbank/src/_internal/src/filter/src/search_result.dart';
import 'package:werkbank/src/tree/tree.dart';

class FilterResult {
  const FilterResult({
    required IMap<Descriptor, DescriptorFilterResult> filterResult,
  }) : results = filterResult,
       filterIsApplied = true;

  const FilterResult.notApplied()
    : results = const IMap.empty(),
      filterIsApplied = false;

  final bool filterIsApplied;

  // If filterIsApplied is false, this is an empty map.
  final IMap<Descriptor, DescriptorFilterResult> results;

  DescriptorFilterResult? resultFor(Descriptor descriptor) {
    return filterIsApplied ? results[descriptor] : null;
  }

  bool descriptorVisibleInTree(
    Descriptor descriptor,
  ) {
    if (!filterIsApplied) return true;

    return resultFor(descriptor)!.isMatch;
  }

  List<Descriptor> filteredDescriptors(List<Descriptor> descriptors) {
    return descriptors.where(descriptorVisibleInTree).toList();
  }
}

sealed class DescriptorFilterResult implements SearchResult {
  const DescriptorFilterResult({
    required this.matchingDescendants,
    required this.matchingAncestors,
  });

  final IList<Descriptor> matchingDescendants;
  final IList<Descriptor> matchingAncestors;
}

class NoClustersResult extends DescriptorFilterResult {
  const NoClustersResult({
    required super.matchingDescendants,
    required super.matchingAncestors,
  });

  @override
  bool get isMatch =>
      matchingDescendants.isNotEmpty || matchingAncestors.isNotEmpty;

  @override
  String toString() {
    return 'NoClustersResult{isMatch: $isMatch, '
        'matchingDescendants: ${matchingDescendants.map((e) => e.path)}, '
        'matchingAncestors: ${matchingAncestors.map((e) => e.path)}';
  }
}

class WithClustersResult extends DescriptorFilterResult
    implements SearchResult {
  WithClustersResult({
    required this.clusters,
    required super.matchingDescendants,
    required super.matchingAncestors,
  }) : assert(
         clusters.isNotEmpty,
         'clusters must not be empty',
       );

  final IList<SearchClusterResult> clusters;

  @override
  late final bool isMatch =
      matchingAncestors.isNotEmpty ||
      matchingDescendants.isNotEmpty ||
      isMatchItself;

  late final bool isMatchItself = clusters.any((e) => e.isMatch);

  @override
  String toString() {
    return 'WithClustersResult{isMatch: $isMatch, '
        'isMatchItself: $isMatchItself, '
        'clusters: $clusters, '
        'matchingDescendants: ${matchingDescendants.map((e) => e.path)}}, '
        'matchingAncestors: ${matchingAncestors.map((e) => e.path)}';
  }
}
