import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class AcknowledgedManager extends StatefulWidget {
  const AcknowledgedManager({
    required this.child,
    super.key,
  });

  final Widget child;

  static List<AcknowledgedDescriptorEntry> useCaseEntriesOf(
    BuildContext context,
  ) {
    return _InheritedAcknowledged.of(context).useCaseEntries;
  }

  @override
  State<AcknowledgedManager> createState() => _AcknowledgedManagerState();
}

class _AcknowledgedManagerState extends State<AcknowledgedManager> {
  List<AcknowledgedDescriptorEntry>? useCaseEntries;
  Set<String> useCasesPaths = {};
  AcknowledgedController? acknowledgedController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    useCasesPaths = ApplicationOverlayLayerEntry.access
        .rootDescriptorOf(context)
        .useCases
        .map((e) => e.path)
        .toSet();

    final newAcknowledgedController = ApplicationOverlayLayerEntry.access
        .acknowledgedController(context);

    if (newAcknowledgedController != acknowledgedController) {
      acknowledgedController?.removeListener(_acknowledgedListener);
      acknowledgedController = newAcknowledgedController;
      acknowledgedController!.addListener(_acknowledgedListener);
    }
    _update();
  }

  void _acknowledgedListener() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _update();
      }
    });
  }

  void _update() {
    final newEntries = _calcEntries(
      acknowledgedController!.descriptors,
    );

    if (newEntries != useCaseEntries) {
      setState(() {
        useCaseEntries = newEntries;
      });
    }
  }

  List<AcknowledgedDescriptorEntry> _calcEntries(
    AcknowledgedDescriptors descriptors,
  ) {
    final safeSortedFilteredUseCaseEntries =
        (descriptors.entries.where((entry) {
              return useCasesPaths.contains(entry.path);
            }).toList()..sort((a, b) => b.firstSeen.compareTo(a.firstSeen)))
            .where((e) => !e.availableSinceFirstStart)
            .toList();

    return safeSortedFilteredUseCaseEntries;
  }

  @override
  void dispose() {
    acknowledgedController?.removeListener(_acknowledgedListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedAcknowledged(
      useCaseEntries: useCaseEntries!,
      child: widget.child,
    );
  }
}

class _InheritedAcknowledged extends InheritedWidget {
  const _InheritedAcknowledged({
    required this.useCaseEntries,
    required super.child,
  });

  static _InheritedAcknowledged of(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedAcknowledged>()!;
  }

  final List<AcknowledgedDescriptorEntry> useCaseEntries;

  @override
  bool updateShouldNotify(_InheritedAcknowledged oldWidget) {
    return useCaseEntries != oldWidget.useCaseEntries;
  }
}
