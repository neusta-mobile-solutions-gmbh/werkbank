import 'package:flutter/material.dart';
import 'package:graphs/graphs.dart';

class AddonLayerBuilder extends StatefulWidget {
  const AddonLayerBuilder({
    super.key,
    required this.layer,
    required this.child,
  });

  final AddonLayer layer;
  final Widget child;

  @override
  State<AddonLayerBuilder> createState() => _AddonLayerBuilderState();
}

class _AddonLayerBuilderState extends State<AddonLayerBuilder> {
  final _childKey = GlobalKey();
  List<_LayerEntryBundle> _layerBundles = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _updateLayer();
  }

  @override
  void reassemble() {
    super.reassemble();
    _updateLayer();
  }

  void _updateLayer() {
    final addons = AddonConfigProvider.addonsOf(context);
    final environment = WerkbankEnvironmentProvider.of(context);
    // This needs to be late, since it is not valid to call this in every layer.
    late final useCaseEnvironment = UseCaseEnvironmentProvider.of(context);
    final layerEntryBundlesById = <FullLayerEntryId, _LayerEntryBundle>{};
    bool shouldIncludeLayerEntry(AddonLayerEntry entry) {
      switch (environment) {
        case WerkbankEnvironment.app:
          if (!entry.includeInOverlay) {
            return switch (useCaseEnvironment) {
              UseCaseEnvironment.regular => true,
              UseCaseEnvironment.overview => false,
            };
          }
          return true;
        case WerkbankEnvironment.display:
          return !entry.appOnly;
      }
    }

    for (final addon in addons) {
      FullLayerEntryId? prevFullLayerEntryId;

      for (final entry in addon.layers.entriesByLayer(widget.layer)) {
        if (!shouldIncludeLayerEntry(entry)) {
          continue;
        }
        final fullLayerId = FullLayerEntryId(
          addonId: addon.id,
          entryId: entry.id,
        );
        layerEntryBundlesById[fullLayerId] = _LayerEntryBundle(
          entry,
          fullLayerEntryId: fullLayerId,
          prevFullLayerEntryId: prevFullLayerEntryId,
        );
        prevFullLayerEntryId = fullLayerId;
      }
    }
    final edges = <FullLayerEntryId, List<FullLayerEntryId>>{};
    for (final layerBundle in layerEntryBundlesById.values) {
      final entry = layerBundle.entry;
      final fullLayerId = layerBundle.fullLayerEntryId;
      final prevFullLayerId = layerBundle.prevFullLayerEntryId;
      if (prevFullLayerId != null) {
        (edges[prevFullLayerId] ??= []).add(fullLayerId);
      }
      for (final before in entry.before) {
        if (layerEntryBundlesById.containsKey(before)) {
          (edges[fullLayerId] ??= []).add(before);
        }
      }
      for (final after in entry.after) {
        if (layerEntryBundlesById.containsKey(after)) {
          (edges[after] ??= []).add(fullLayerId);
        }
      }
    }

    try {
      final sortedLayerEntries = topologicalSort(
        layerEntryBundlesById.keys,
        (v) => edges[v] ?? const Iterable.empty(),
        secondarySort: (a, b) {
          final aSortHint = layerEntryBundlesById[a]!.entry.sortHint;
          final bSortHint = layerEntryBundlesById[b]!.entry.sortHint;
          return aSortHint.compareTo(bSortHint);
        },
      );
      _layerBundles = [
        for (final layer in sortedLayerEntries) layerEntryBundlesById[layer]!,
      ];
    } on CycleException<FullLayerEntryId> catch (e) {
      throw AddonLayerEntryCycleError(e.cycle);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget result = KeyedSubtree(
      // Technically we should not need a GlobalKey here, since the addons are
      // required to preserve the state of the child. But this is a safe guard
      // in case an addon does not do that.
      key: _childKey,
      child: widget.child,
    );
    for (final layerEntryBundle in _layerBundles.reversed) {
      // We need to store this, because result will have changed by the type
      // the builder is called.
      final child = result;
      result = Builder(
        builder: (context) {
          return layerEntryBundle.entry.builder(context, child);
        },
      );
    }
    return result;
  }
}

class _LayerEntryBundle {
  _LayerEntryBundle(
    this.entry, {
    required this.fullLayerEntryId,
    required this.prevFullLayerEntryId,
  });

  final AddonLayerEntry entry;
  final FullLayerEntryId fullLayerEntryId;
  final FullLayerEntryId? prevFullLayerEntryId;
}

class AddonLayerEntryCycleError extends Error {
  AddonLayerEntryCycleError(this.cycle);

  final List<FullLayerEntryId> cycle;

  @override
  String toString() {
    return 'Cycle detected in addon layer entries: '
        '${cycle.map((l) => l.toString()).join(' -> ')}';
  }
}
