import 'package:flutter/foundation.dart';

/// {@category Search for Use Cases}
sealed class DebugWerkbankFilter {
  const DebugWerkbankFilter(
    this.name,
  );

  static const disabled = DebugWerkbankFilterDisabled._();
  static const displayMatches = DebugWerkbankFilterDisplayMatches._();
  static const displayAllResults = DebugWerkbankFilterDisplayAllResults._();

  static Set<DebugWerkbankFilter> get mostValues => {
    disabled,
    displayMatches,
    displayAllResults,
  };

  static DebugWerkbankFilter displayOnly(Set<String> childDescriptorNames) =>
      DebugWerkbankFilterDisplayOnly._(
        childDescriptorNames: childDescriptorNames,
      );

  final String name;
}

class DebugWerkbankFilterDisabled extends DebugWerkbankFilter {
  const DebugWerkbankFilterDisabled._() : super('Disabled');
}

class DebugWerkbankFilterDisplayMatches extends DebugWerkbankFilter {
  const DebugWerkbankFilterDisplayMatches._() : super('Display Matches');
}

class DebugWerkbankFilterDisplayAllResults extends DebugWerkbankFilter {
  const DebugWerkbankFilterDisplayAllResults._() : super('Display All Results');
}

class DebugWerkbankFilterDisplayOnly extends DebugWerkbankFilter {
  DebugWerkbankFilterDisplayOnly._({
    required this.childDescriptorNames,
  }) : super('Display Only');

  final Set<String> childDescriptorNames;
}

ValueNotifier<DebugWerkbankFilter> _debugWerkbankFilter = ValueNotifier(
  DebugWerkbankFilter.disabled,
);

ValueListenable<DebugWerkbankFilter> get debugWerkbankFilter =>
    _debugWerkbankFilter;

void updateDebugWerkbankFilter(DebugWerkbankFilter value) {
  if (!kDebugMode) {
    return;
  }

  if (_debugWerkbankFilter.value == value) {
    return;
  }

  debugPrint('Setting debugWerkbankFilter to $value');

  _debugWerkbankFilter.value = value;
}
