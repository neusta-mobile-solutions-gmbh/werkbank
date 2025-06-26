import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

const _printResults = false;

mixin FilterExcecutor<T extends StatefulWidget> on State<T> {
  FilterResult doFilter({
    required String searchQuery,
    required RootDescriptor rootDescriptor,
  }) {
    final hasFilteringData = searchQuery.isNotEmpty;
    if (!hasFilteringData) {
      return const FilterResult.notApplied();
    }

    final descendants = rootDescriptor.descendants;
    final metadataMap = UseCaseMetadataProvider.metadataMapOf(context);

    final clustersForDescriptors = {
      for (final descendant in descendants)
        descendant: [
          ..._otherClustersFor(
            descendant,
            searchQueryLength: searchQuery.length,
          ),
          if (descendant is UseCaseDescriptor)
            ...metadataMap[descendant]!.searchClusters,
        ],
    }..removeWhere((key, value) => value.isEmpty);

    if (_printResults) {
      debugPrint(
        '----------\n'
        'searchQuery: $searchQuery\n'
        '----------\n',
      );
    }

    // These results represent if the descriptor itself has a match.
    final descriptorResultsWithoutRelatives = _calcDescriptorResults(
      clustersForDescriptors,
      searchQuery,
    );

    // These results represent if the descriptor has a matching relatives.
    final results = <Descriptor, DescriptorFilterResult>{};
    _askChildrenThanAddYourself(
      rootDescriptor,
      [],
      results,
      descriptorResultsWithoutRelatives,
    );

    if (_printResults) {
      final clusterResultEntries = results.entries
          .where((element) => element.value is WithClustersResult)
          .where((e) => e.value.isMatch);
      debugPrint(
        '----ClusterResults: ${clusterResultEntries.length} ->\n'
        // ignore: lines_longer_than_80_chars
        '${clusterResultEntries.map((e) => '${e.key.path} : ${e.value}').join('\n---\n')}'
        '\n--------------------',
      );
      final noClusterResultEntires = results.entries
          .where((element) => element.value is NoClustersResult)
          .where((e) => e.value.isMatch);
      debugPrint(
        '----NoClusterResults: ${noClusterResultEntires.length} ->\n'
        // ignore: lines_longer_than_80_chars
        '${noClusterResultEntires.map((e) => '${e.key.path} : ${e.value}').join('\n---\n')}'
        '\n--------------------',
      );
    }

    return FilterResult(
      filterResult: results.toIMap(),
    );
  }

  Map<Descriptor, DescriptorFilterResult> _calcDescriptorResults(
    Map<Descriptor, List<SearchCluster>> clustersForUseCases,
    String searchQuery,
  ) {
    final clusterResultsForUseCases = _calcClusterResults(
      clustersForUseCases,
      searchQuery,
    );
    final useCaseResults = _mapToUseCaseResult(clusterResultsForUseCases);
    return useCaseResults;
  }

  Map<Descriptor, List<SearchClusterResult>> _calcClusterResults(
    Map<Descriptor, List<SearchCluster>> clustersForUseCases,
    String searchQuery,
  ) {
    return clustersForUseCases.map((useCase, searchClusters) {
      final clusterResults = searchClusters.map((searchCluster) {
        final clusterResult = searchCluster.evaluate(query: searchQuery);
        return clusterResult;
      }).toList();

      return MapEntry(useCase, clusterResults);
    });
  }
}

Map<Descriptor, DescriptorFilterResult> _mapToUseCaseResult(
  Map<Descriptor, List<SearchClusterResult>> clusterResultsForUseCases,
) {
  return <Descriptor, DescriptorFilterResult>{
    for (final useCaseEntry in clusterResultsForUseCases.entries)
      useCaseEntry.key: WithClustersResult(
        clusters: useCaseEntry.value.toIList(),
        // A useCase cant have descendants
        matchingDescendants: const IList.empty(),
        // At this point, we dont know if a ancestor is a match
        matchingAncestors: const IList.empty(),
      ),
  };
}

void _askChildrenThanAddYourself(
  // The current descriptor we are looking at
  Descriptor current,
  // The already collected matching ancestors running this recursion
  List<Descriptor> matchingAncestors,
  // The result object that each current descriptor will be added to
  Map<Descriptor, DescriptorFilterResult> results,
  // The previously calculated results for each descriptor, that dont include
  // relatives
  Map<Descriptor, DescriptorFilterResult> resultsWithoutRelatives,
) {
  final children = switch (current) {
    ParentDescriptor() => current.children,
    UseCaseDescriptor() => <Descriptor>[],
  };
  final currentResultWithoutRelatives = resultsWithoutRelatives[current];
  final currentIsMatchItself = switch (currentResultWithoutRelatives) {
    NoClustersResult() || null => false,
    WithClustersResult(:final isMatchItself) => isMatchItself,
  };
  final ancestorsForChild = [
    ...matchingAncestors,
    if (currentIsMatchItself) current,
  ];

  // Ask children to add themselves to the results.
  for (final child in children) {
    _askChildrenThanAddYourself(
      child,
      ancestorsForChild,
      results,
      resultsWithoutRelatives,
    );
  }

  // Collect matchingDescendants
  // Consider children already know there matchingDescendants at this point.
  final matchingDescendants = <Descriptor>[];
  for (final child in children) {
    final childResult = results[child]!;

    // If this child is a parent, we can add all of its matchingDescendants,
    // because they are also matchingDescendants of the current descriptor.
    switch (child) {
      case ParentDescriptor():
        matchingDescendants.addAll(childResult.matchingDescendants);
      case UseCaseDescriptor():
        break;
    }

    // If the child is a match itself, we add it to the matchingDescendants.
    switch (childResult) {
      case NoClustersResult():
        // do nothing
        break;
      case WithClustersResult(:final isMatchItself):
        if (isMatchItself) {
          matchingDescendants.add(child);
        }
    }
  }

  results[current] = switch (currentResultWithoutRelatives) {
    NoClustersResult() || null => NoClustersResult(
      matchingDescendants: matchingDescendants.toIList(),
      matchingAncestors: matchingAncestors.toIList(),
    ),
    WithClustersResult(:final clusters) => WithClustersResult(
      clusters: clusters,
      matchingDescendants: matchingDescendants.toIList(),
      matchingAncestors: matchingAncestors.toIList(),
    ),
  };
}

// The Choices for a useCase that are not due to searchEntries
// but due to other features.
List<SearchCluster> _otherClustersFor(
  ChildDescriptor descriptor, {
  required int searchQueryLength,
}) {
  final node = descriptor.node;
  final nameWithSpaces = _withSpaces(node.name);
  final justTheUpperCaseChars = _justTheUpperCaseChars(node.name);
  final wordsInTheName = _wordsIn(node.name);
  return [
    // Name of the UseCase
    SearchCluster(
      semanticDescription: 'Name of the ${descriptor.runtimeType}',
      entries: [
        FuzzySearchEntry(
          // Name Of The Use Case
          searchString: nameWithSpaces,
          scoreThreshold: .5,
          ignoreCase: true,
        ),
        FuzzySearchEntry(
          // NameOfTheUseCase
          searchString: node.name,
          scoreThreshold: .5,
          ignoreCase: true,
        ),
        // NameOfTheUseCase -> NOTUC
        if (justTheUpperCaseChars.length > 1)
          FuzzySearchEntry(
            searchString: justTheUpperCaseChars,
            scoreThreshold: .25,
            ignoreCase: true,
          ),
        for (final word in wordsInTheName)
          FuzzySearchEntry(
            searchString: word,
            scoreThreshold: .5,
            ignoreCase: true,
          ),
      ],
    ),
  ];
}

/// Check if the string contains only letters (a-zA-Z).
bool _isAlpha(String str) {
  for (var i = 0; i < str.length; i++) {
    final codeUnit = str.codeUnitAt(i);
    if (!(codeUnit >= 65 && codeUnit <= 90) &&
        !(codeUnit >= 97 && codeUnit <= 122)) {
      return false;
    }
  }
  return true;
}

// Multiple Choice Dropdown -> MCD
String _justTheUpperCaseChars(String name) {
  return name
      .split('')
      .where(_isAlpha)
      .where((element) => element.toUpperCase() == element)
      .join();
}

String _withSpaces(String name) {
  final buffer = StringBuffer();
  var letterBefore = '';
  for (final char in name.split('')) {
    final isUpperCaseLetter = _isAlpha(char) && char.toUpperCase() == char;
    final letterBeforeWasNotSpace = letterBefore != ' ';
    if (isUpperCaseLetter && letterBeforeWasNotSpace) {
      buffer.write(' ');
    }
    buffer.write(char);
    letterBefore = char;
  }
  final newName = buffer.toString();
  return newName;
}

List<String> _wordsIn(String name, {int minLength = 2}) {
  final buffer = StringBuffer();
  for (final char in name.split('')) {
    final isUpperCaseLetter = _isAlpha(char) && char.toUpperCase() == char;
    if (isUpperCaseLetter) {
      buffer.write(' ');
    }
    buffer.write(char);
  }
  final words = buffer
      .toString()
      .split(' ')
      .where((element) => element.isNotEmpty)
      .where((element) => element.length >= minLength)
      .toList();
  return words;
}
