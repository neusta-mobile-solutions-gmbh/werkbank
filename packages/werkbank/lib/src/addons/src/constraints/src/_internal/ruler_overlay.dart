import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/constraints_gestures.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/constraints_shortcuts.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/constraints_state_entry.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/guide_lines.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/ruler.dart';
import 'package:werkbank/src/addons/src/constraints/src/_internal/ruler_corner.dart';
import 'package:werkbank/werkbank.dart';

class RulerOverlay extends StatefulWidget {
  const RulerOverlay({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<RulerOverlay> createState() => RulerOverlayState();
}

class RulerOverlayState extends State<RulerOverlay> {
  ConstraintsMode constraintsMode = ConstraintsMode.tightOneAxis;
  late ConstraintsComposition constraintsComposition;

  late ValueNotifier<ViewConstraints> viewConstraintsNotifier;
  late ValueNotifier<Size?> sizeNotifier;
  final ValueNotifier<LayoutInfo?> layoutChangedNotifier = ValueNotifier(null);
  bool currentlyChangingConstraints = false;
  final layoutReferenceLink = LayoutReferenceLink();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final composition = UseCaseOverlayLayerEntry.access.compositionOf(context);
    viewConstraintsNotifier = composition.constraints.viewConstraintsNotifier;
    // We get the sizeNotifier from the ConstraintsStateEntry, since
    // composition.constraints.sizeListenable is a ValueListenable
    // because external users should not be able to change the value.
    sizeNotifier = composition
        .getTransientStateEntry<ConstraintsStateEntry>()
        .sizeNotifier;
  }

  // ignore: use_setters_to_change_properties
  void _updateViewConstraints(ViewConstraints viewConstraints) {
    viewConstraintsNotifier.value = viewConstraints;
  }

  void _resetConstraints(Axis? axis) {
    final oldViewConstraints = viewConstraintsNotifier.value;
    final newViewConstraints = switch (axis) {
      Axis.horizontal => ViewConstraints(
        minWidth: 0,
        maxWidth: null,
        minHeight: oldViewConstraints.minHeight,
        maxHeight: oldViewConstraints.maxHeight,
      ),
      Axis.vertical => ViewConstraints(
        minWidth: oldViewConstraints.minWidth,
        maxWidth: oldViewConstraints.maxWidth,
        minHeight: 0,
        maxHeight: null,
      ),
      null => ViewConstraints.looseViewLimited,
    };
    _updateViewConstraints(newViewConstraints);
  }

  @override
  void dispose() {
    layoutChangedNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget result = WLayoutReference(
      link: layoutReferenceLink,
      child: widget.child,
    );
    final supportedSizes = UseCaseOverlayLayerEntry.access
        .metadataOf(context)
        .supportedSizes;

    BoxConstraints viewConstraintsToBoxConstraints(
      ViewConstraints viewConstraints,
    ) {
      return viewConstraints
          .toBoxConstraints(viewSize: Size.infinite)
          .enforce(supportedSizes);
    }

    switch (UseCaseOverlayLayerEntry.access.environmentOf(context)) {
      case WerkbankEnvironment.app:
        result = ConstraintsShortcuts(
          onModeChange: (mode) {
            final endBothAxesMode =
                !mode.supportsBothAxes &&
                constraintsMode.supportsBothAxes &&
                currentlyChangingConstraints;
            setState(() {
              if (endBothAxesMode) {
                currentlyChangingConstraints = false;
              }
              constraintsMode = mode;
            });
          },
          child: ConstraintsGestures(
            viewConstraintsListenable: viewConstraintsNotifier,
            layoutChangedListenable: layoutChangedNotifier,
            onStartUpdatingViewConstraints: (viewConstraints) {
              _updateViewConstraints(viewConstraints);
              setState(() {
                currentlyChangingConstraints = true;
              });
            },
            onViewConstraintsUpdate: _updateViewConstraints,
            onReset: _resetConstraints,
            constraintsMode: constraintsMode,
            onEndOrCancel: () {
              setState(() {
                currentlyChangingConstraints = false;
              });
            },
            rulerCorner: const RulerCorner(),
            hRuler: ValueListenableBuilder(
              valueListenable: viewConstraintsNotifier,
              builder: (context, value, _) {
                return Ruler(
                  constraints: viewConstraintsToBoxConstraints(value),
                  axis: Axis.horizontal,
                  notifier: layoutChangedNotifier,
                );
              },
            ),
            vRuler: ValueListenableBuilder(
              valueListenable: viewConstraintsNotifier,
              builder: (context, value, _) {
                return Ruler(
                  constraints: viewConstraintsToBoxConstraints(value),
                  axis: Axis.vertical,
                  notifier: layoutChangedNotifier,
                );
              },
            ),
            child: ValueListenableBuilder(
              valueListenable: viewConstraintsNotifier,
              builder: (context, value, child) {
                return GuideLines(
                  constraints: viewConstraintsToBoxConstraints(value),
                  notifier: layoutChangedNotifier,
                  constraintsMode: constraintsMode,
                  currentlyChangingConstraints: currentlyChangingConstraints,
                  child: child!,
                );
              },
              child: result,
            ),
          ),
        );
      case WerkbankEnvironment.display:
        break;
    }

    return NotificationListener<RelativeLayoutChangedNotification>(
      onNotification: (notification) {
        layoutChangedNotifier.value = notification.layoutInfo;
        sizeNotifier.value = notification.layoutInfo.size;
        return true;
      },
      child: RulerLayoutReferenceLinkProvider(
        link: layoutReferenceLink,
        child: result,
      ),
    );
  }
}

enum ConstraintsMode {
  // default.
  // Only one axis is resized tight by dragging the ruler
  tightOneAxis,
  // While holding keys
  // Those modes support using both axes at the same time
  min,
  max,
  bothTight;

  bool get supportsBothAxes => this != ConstraintsMode.tightOneAxis;

  bool get modeSizesMin =>
      this == ConstraintsMode.min ||
      this == ConstraintsMode.bothTight ||
      this == ConstraintsMode.tightOneAxis;

  bool get modeSizesMax =>
      this == ConstraintsMode.max ||
      this == ConstraintsMode.bothTight ||
      this == ConstraintsMode.tightOneAxis;
}

class RelativeLayoutChangedNotification extends LayoutChangedNotification {
  RelativeLayoutChangedNotification({required this.layoutInfo});

  final LayoutInfo layoutInfo;
}

class RulerLayoutReferenceLinkProvider extends InheritedWidget {
  const RulerLayoutReferenceLinkProvider({
    super.key,
    required this.link,
    required super.child,
  });

  final LayoutReferenceLink link;

  static LayoutReferenceLink of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<RulerLayoutReferenceLinkProvider>();
    assert(
      result != null,
      'No RulerLayoutReferenceLinkProvider found in context',
    );
    return result!.link;
  }

  @override
  bool updateShouldNotify(RulerLayoutReferenceLinkProvider oldWidget) {
    return link != oldWidget.link;
  }
}
