import 'package:flutter/material.dart' hide Element;
import 'package:werkbank/src/addons/src/state/src/_internal/element.dart';
import 'package:werkbank/src/addons/src/state/src/_internal/element_snapshot.dart';

class BuildableElement<T> implements Element<T> {
  BuildableElement({
    required this.label,
    required T initialValue,
  }) : notifier = ValueNotifier<T>(initialValue);

  @override
  final String label;

  @override
  late final ValueNotifier<T> notifier;

  void prepareForBuild(BuildContext context) {}

  ElementSnapshot createSnapshot() {
    return ElementSnapshot(value: notifier.value);
  }

  void tryLoadSnapshot(ElementSnapshot snapshot) {
    final snapshotValue = snapshot.value;
    if (snapshotValue is T) {
      notifier.value = snapshotValue;
    }
  }

  void dispose() {
    notifier.dispose();
  }
}

// TODO(lwiedekamp): Do we need something like ValueGuardingKnobMixin,
// ValueGuardingWritableKnobMixin or BuildableWritableKnob?
