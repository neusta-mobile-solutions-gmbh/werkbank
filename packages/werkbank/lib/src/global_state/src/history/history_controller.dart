import 'dart:collection';

import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/tree/tree.dart';

// TODO: Move to somewhere else. (non _internal)
class HistoryController extends GlobalStateController {
  static const int maxHistorySize = 100;

  final Map<String, DateTime> _lastVisitTimeMap = {};
  final SplayTreeSet<(String, DateTime)> _sortedVisits = SplayTreeSet(
    (a, b) {
      final dateComparison = b.$2.compareTo(a.$2);
      if (dateComparison != 0) {
        return dateComparison;
      }
      return a.$1.compareTo(b.$1);
    },
  );

  String? get lastVisitedPath {
    return _sortedVisits.isNotEmpty ? _sortedVisits.first.$1 : null;
  }

  DateTime? get lastVisitedTime {
    return _sortedVisits.isNotEmpty ? _sortedVisits.first.$2 : null;
  }

  List<(String path, DateTime visitTime)> get recentlyVisitedPaths {
    return _sortedVisits.toList(growable: false);
  }

  List<(Descriptor descriptor, DateTime visitTime)>
  getRecentlyVisitedDescriptors(
    RootDescriptor rootDescriptor,
  ) {
    final visitedDescriptors = <(Descriptor, DateTime)>[];
    for (final (path, visitTime) in _sortedVisits) {
      final descriptor = rootDescriptor.maybeFromPath(path);
      if (descriptor != null) {
        visitedDescriptors.add((descriptor, visitTime));
      }
    }
    return visitedDescriptors;
  }

  void _logVisit(
    String descriptorPath,
    DateTime dateTime, {
    bool notify = true,
  }) {
    final previousVisitTime = _lastVisitTimeMap[descriptorPath];
    if (previousVisitTime != null) {
      _sortedVisits.remove((descriptorPath, previousVisitTime));
    } else if (_lastVisitTimeMap.length >= maxHistorySize) {
      final oldestVisit = _sortedVisits.last;
      _sortedVisits.remove(oldestVisit);
      _lastVisitTimeMap.remove(oldestVisit.$1);
    }
    _lastVisitTimeMap[descriptorPath] = dateTime;
    _sortedVisits.add((descriptorPath, dateTime));
    if (notify) {
      notifyListeners();
    }
  }

  void logPathVisit(String descriptorPath) {
    _logVisit(descriptorPath, DateTime.timestamp());
  }

  void logDescriptorVisit(Descriptor descriptor) {
    logPathVisit(descriptor.path);
  }

  @override
  Object? toJson() {
    return {
      for (final entry in _sortedVisits) entry.$1: entry.$2.toIso8601String(),
    };
  }

  @override
  void tryLoadFromJson(Object? json, {required bool isWarmStart}) {
    if (json is Map<String, dynamic>) {
      _lastVisitTimeMap.clear();
      _sortedVisits.clear();
      for (final MapEntry(key: path, value: dateTimeString) in json.entries) {
        if (dateTimeString is! String) {
          continue;
        }
        final dateTime = DateTime.tryParse(dateTimeString);
        if (dateTime == null) {
          continue;
        }
        _logVisit(path, dateTime, notify: false);
      }
      notifyListeners();
    }
  }
}
