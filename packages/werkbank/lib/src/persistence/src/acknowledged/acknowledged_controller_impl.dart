import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/persistence/src/acknowledged/acknowledged_controller.dart';
import 'package:werkbank/src/persistence/src/acknowledged/acknowledged_descriptors.dart';
import 'package:werkbank/src/persistence/src/persistent_controller.dart';

class AcknowledgedControllerImpl extends PersistentController
    implements AcknowledgedController {
  AcknowledgedControllerImpl({
    required super.prefsWithCache,
    required Set<String> descendantsPaths,
  }) : _descendantsPaths = descendantsPaths;

  @override
  String get id => 'acknowledged';

  final Set<String> _descendantsPaths;

  @override
  void init(String? unsafeJson) {
    try {
      AcknowledgedDescriptors oldAcknowledgedDescriptors;
      oldAcknowledgedDescriptors = unsafeJson != null
          ? AcknowledgedDescriptors.fromJson(unsafeJson)
          : AcknowledgedDescriptors.fromPaths(
              _descendantsPaths,
            );

      // We don't throw entries away that disappeared from the validPaths.
      // They might come back later for example because the user was switching
      // between branches.
      final entries = oldAcknowledgedDescriptors.entries.toList();
      final entriesPaths = entries.map((entry) => entry.path).toSet();

      for (final candidate in _descendantsPaths) {
        final candidateIsNew = !entriesPaths.contains(candidate);
        if (candidateIsNew) {
          entries.add(
            AcknowledgedDescriptorEntry(
              availableSinceFirstStart: false,
              firstSeen: DateTime.now(),
              path: candidate,
              visitedCount: 0,
            ),
          );
        }
      }

      _descriptors = AcknowledgedDescriptors(
        entries: entries.lockUnsafe,
      );
    } on FormatException {
      debugPrint(
        'Restoring AcknowledgedDescriptors failed. Throwing it away. '
        'This can happen if changes to werkbank were made. '
        "It's not backwards compatible on purpose.",
      );

      _descriptors = AcknowledgedDescriptors.fromPaths(
        _descendantsPaths,
      );
    }

    setJson(
      _descriptors.toJson(),
    );
  }

  late AcknowledgedDescriptors _descriptors;

  @override
  AcknowledgedDescriptors get descriptors => _descriptors;

  @override
  void log(String descriptorPath) {
    final entries = descriptors.entries.toList();
    final entryIndex = entries.indexWhere(
      (entry) => entry.path == descriptorPath,
    );
    final candidateIsNew = entryIndex == -1;

    if (candidateIsNew) {
      entries.add(
        AcknowledgedDescriptorEntry(
          availableSinceFirstStart: false,
          firstSeen: DateTime.now(),
          path: descriptorPath,
          visitedCount: 1,
        ),
      );
    } else {
      final entry = entries[entryIndex];
      final updatedEntry = entry.copyWith(
        visitedCount: entry.visitedCount + 1,
      );

      entries[entryIndex] = updatedEntry;
    }

    _descriptors = AcknowledgedDescriptors(
      entries: entries.lockUnsafe,
    );

    setJson(
      _descriptors.toJson(),
    );

    notifyListeners();
  }

  @override
  void clear() {
    _descriptors = AcknowledgedDescriptors.fromPaths(
      _descendantsPaths,
    );
    setJson(
      _descriptors.toJson(),
    );
    notifyListeners();
  }
}
