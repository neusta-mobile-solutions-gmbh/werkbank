import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart' hide Element;
import 'package:werkbank/src/addons/src/state/src/_internal/buildable_element.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/element.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/element_snapshot.dart';
import 'package:werkbank/werkbank.dart';

class ElementsStateEntry
    extends TransientUseCaseStateEntry<ElementsStateEntry, ElementsSnapshot> {
  final Map<ElementId, BuildableElement<Object?>> _elementsById = {};

  @override
  void prepareForBuild(
    UseCaseComposition composition,
    BuildContext context,
  ) {
    super.prepareForBuild(composition, context);
    for (final element in _elementsById.values) {
      element.prepareForBuild(context);
    }
  }

  @override
  Listenable? createRebuildListenable() {
    return Listenable.merge([
      for (final element in _elementsById.values) element.notifier,
    ]);
  }

  void addElement(BuildableElement<Object?> element) {
    assert(
      !_elementsById.containsKey(element.id),
      'Element with label "${element.id}" already exists',
    );
    _elementsById[element.id] = element;
  }

  List<BuildableElement<Object?>> get elements =>
      UnmodifiableListView(_elementsById.values);

  @override
  void loadSnapshot(ElementsSnapshot snapshot) {
    for (final element in _elementsById.values) {
      if (snapshot.elementSnapshots.containsKey(element.id)) {
        final elementSnapshot = snapshot.elementSnapshots[element.id];
        if (elementSnapshot != null) {
          element.tryLoadSnapshot(elementSnapshot);
        }
      }
    }
  }

  @override
  ElementsSnapshot saveSnapshot() {
    return ElementsSnapshot(
      elementSnapshots: {
        for (final MapEntry(:key, :value) in _elementsById.entries)
          key: value.createSnapshot(),
      }.lockUnsafe,
    );
  }

  @override
  void dispose() {
    for (final element in _elementsById.values) {
      element.dispose();
    }
    super.dispose();
  }
}

class ElementsSnapshot extends TransientUseCaseStateSnapshot {
  const ElementsSnapshot({
    required this.elementSnapshots,
  });

  final IMap<ElementId, ElementSnapshot> elementSnapshots;
}
