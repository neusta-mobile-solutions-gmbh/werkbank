import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/tree/tree.dart';

class AcknowledgedController extends GlobalStateController {
  static const _fieldFirstPresentKey = 'firstPresent';
  static const _fieldHasBeenVisitedKey = 'hasBeenVisited';

  Map<String, _AcknowledgedDescriptorEntry>? _acknowledgedMap;

  @override
  Object? toJson() {
    final acknowledgedMap = _acknowledgedMap;
    if (acknowledgedMap == null) {
      return null;
    }
    return {
      for (final MapEntry(key: path, value: entry) in acknowledgedMap.entries)
        path: {
          _fieldFirstPresentKey: entry.firstPresent.toIso8601String(),
          _fieldHasBeenVisitedKey: entry.hasBeenVisited,
        },
    };
  }

  @override
  void tryLoadFromJson(Object? json, {required bool isWarmStart}) {
    if (json is Map<String, Object?>) {
      final acknowledgedMap = <String, _AcknowledgedDescriptorEntry>{};
      for (final MapEntry(key: path, value: entryJson) in json.entries) {
        if (entryJson case {
          _fieldFirstPresentKey: final String firstPresentString,
          _fieldHasBeenVisitedKey: final bool hasBeenVisited,
        }) {
          final firstPresent = DateTime.tryParse(firstPresentString);
          if (firstPresent == null) {
            continue;
          }
          acknowledgedMap[path] = _AcknowledgedDescriptorEntry(
            firstPresent: firstPresent,
            hasBeenVisited: hasBeenVisited,
          );
        }
      }
      _acknowledgedMap = acknowledgedMap;
    }
  }

  void logRootDescriptorChange(RootDescriptor rootDescriptor) {
    final now = DateTime.timestamp();
    final isFirstStartup = _acknowledgedMap == null;
    final acknowledgedMap = _acknowledgedMap ??= {};

    for (final descriptor in rootDescriptor.useCases) {
      final path = descriptor.path;
      acknowledgedMap[path] ??= _AcknowledgedDescriptorEntry(
        firstPresent: now,
        // We pretend like we have already visited the descriptors
        // that are present on the first startup, because there
        // is no point in telling the user that everything is new.
        hasBeenVisited: isFirstStartup,
      );
    }
    notifyListeners();
  }

  void logDescriptorVisit(UseCaseDescriptor descriptor) {
    final path = descriptor.path;
    final acknowledgedMap = _acknowledgedMap;
    if (acknowledgedMap == null) {
      return;
    }
    final entry = acknowledgedMap[path];
    if (entry == null) {
      return;
    }
    if (!entry.hasBeenVisited) {
      acknowledgedMap[path] = _AcknowledgedDescriptorEntry(
        firstPresent: entry.firstPresent,
        hasBeenVisited: true,
      );
      notifyListeners();
    }
  }

  /// Returns the list of use cases that have not been visited yet.
  /// The list is sorted by the time they were first presented,
  /// with the most recently added use cases first.
  List<UseCaseDescriptor> getNewUseCases(
    RootDescriptor rootDescriptor,
  ) {
    final acknowledgedMap = _acknowledgedMap;
    if (acknowledgedMap == null) {
      return [];
    }
    final items = <(UseCaseDescriptor, DateTime)>[];
    for (final descriptor in rootDescriptor.useCases) {
      final entry = acknowledgedMap[descriptor.path];
      if (entry != null && !entry.hasBeenVisited) {
        items.add((descriptor, entry.firstPresent));
      }
    }
    items.sort((a, b) => b.$2.compareTo(a.$2));
    return [for (final (descriptor, _) in items) descriptor];
  }
}

class _AcknowledgedDescriptorEntry {
  _AcknowledgedDescriptorEntry({
    required this.firstPresent,
    required this.hasBeenVisited,
  });

  final DateTime firstPresent;
  final bool hasBeenVisited;
}
