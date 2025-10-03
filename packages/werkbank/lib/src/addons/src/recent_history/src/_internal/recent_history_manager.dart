import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/global_state/global_state.dart';

class RecentHistoryManager extends StatefulWidget {
  const RecentHistoryManager({
    required this.child,
    super.key,
  });

  final Widget child;

  static List<WerkbankHistoryEntry> recentHistoryOf(BuildContext context) {
    return _InheritedRecentHistory.of(context).recentHistory;
  }

  @override
  State<RecentHistoryManager> createState() => _RecentHistoryManagerState();
}

class _RecentHistoryManagerState extends State<RecentHistoryManager> {
  List<WerkbankHistoryEntry>? recentHistory;
  Set<String> descendantsPaths = {};
  HistoryController? historyController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    descendantsPaths = ApplicationOverlayLayerEntry.access
        .rootDescriptorOf(context)
        .descendants
        .map((e) => e.path)
        .toSet();
    final newHistoryController = ApplicationOverlayLayerEntry.access.historyOf(
      context,
    );
    if (newHistoryController != historyController) {
      historyController?.removeListener(_historyListener);
      historyController = newHistoryController;
      historyController!.addListener(_historyListener);
    }
    _updateRecentHistory();
  }

  void _historyListener() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _updateRecentHistory();
      }
    });
  }

  void _updateRecentHistory() {
    final newRecent = _calcRecent(
      historyController!.unsafeHistory,
    );

    if (newRecent != recentHistory) {
      setState(() {
        recentHistory = newRecent;
      });
    }
  }

  List<WerkbankHistoryEntry> _calcRecent(
    WerkbankHistory unsafeHistory,
  ) {
    final safeEntries = unsafeHistory.entries.where((entry) {
      return descendantsPaths.contains(entry.path);
    }).toIList();

    final recent = <WerkbankHistoryEntry>[];
    final seenPaths = <String>{};
    for (final e in safeEntries) {
      if (seenPaths.add(e.path)) {
        recent.add(e);
      }
    }

    return recent;
  }

  @override
  void dispose() {
    historyController?.removeListener(_historyListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedRecentHistory(
      recentHistory: recentHistory!,
      child: widget.child,
    );
  }
}

class _InheritedRecentHistory extends InheritedWidget {
  const _InheritedRecentHistory({
    required this.recentHistory,
    required super.child,
  });

  static _InheritedRecentHistory of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedRecentHistory>()!;
  }

  final List<WerkbankHistoryEntry> recentHistory;

  @override
  bool updateShouldNotify(_InheritedRecentHistory oldWidget) {
    return recentHistory != oldWidget.recentHistory;
  }
}
