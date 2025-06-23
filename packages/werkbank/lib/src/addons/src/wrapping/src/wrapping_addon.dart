import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/wrapping/src/_internal/wrapping_applier.dart';
import 'package:werkbank/src/addons/src/wrapping/src/_internal/wrapping_state_entry.dart';
import 'package:werkbank/werkbank.dart';

// Maximum integer that is also safe to use when compiling to JavaScript.
const _maxInt = 9007199254740991;

/// {@category Configuring Addons}
///
/// An addon that allows use cases to wrap widgets around the [WidgetBuilder]
/// returned by a [UseCaseBuilder].
///
/// See [WrappingComposerExtension.wrapUseCase] form more information.
class WrappingAddon extends Addon {
  const WrappingAddon() : super(id: addonId);

  static const addonId = 'wrapping';

  @override
  List<AnyTransientUseCaseStateEntry> createTransientUseCaseStateEntries() => [
    WrappingStateEntry(),
  ];

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      useCase: [
        UseCaseLayerEntry(
          id: 'use_case_layer_wrapper',
          sortHint: const SortHint(_maxInt),
          builder: (context, child) {
            return WrappingApplier(
              layer: WrappingLayer.surrounding,
              access: UseCaseLayerEntry.access,
              child: child,
            );
          },
        ),
      ],
      useCaseFitted: [
        UseCaseFittedLayerEntry(
          id: 'use_case_fitted_layer_wrapper',
          sortHint: const SortHint(_maxInt),
          builder: (context, child) {
            return WrappingApplier(
              layer: WrappingLayer.fitted,
              access: UseCaseFittedLayerEntry.access,
              child: child,
            );
          },
        ),
      ],
    );
  }
}
