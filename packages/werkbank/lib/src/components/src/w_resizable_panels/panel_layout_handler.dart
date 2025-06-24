import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

typedef WidgetLayoutBuilder =
    Widget Function(
      BuildContext context,
      double leftPanelWidth,
      double rightPanelWidth,
    );

/// Sizes the panels and
/// decides, if the panels need to be shrunk.
/// Tells the [PanelController] to do so.
class PanelLayoutHandler extends StatelessWidget {
  const PanelLayoutHandler({
    required this.builder,
    super.key,
  });

  final WidgetLayoutBuilder builder;

  @override
  Widget build(BuildContext context) {
    return _PanelShrinking(
      child: _AutoVisibilityChange(
        child: _PanelLayout(
          builder: builder,
        ),
      ),
    );
  }
}

class _PanelShrinking extends StatelessWidget with PanelCalcMixin {
  const _PanelShrinking({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final panelController = PanelControllerProvider.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final newMaxPanelWidth = maxPanelWidth(constraints.maxWidth);

        // This would be problematic, if we would update State in
        // some inherited widget, since this happens in the build phase.
        // But since we use ValueNotifiers, this is fine for now.
        if (panelController.maxWidth.value != newMaxPanelWidth) {
          panelController.updateMaxWidth(
            newMaxPanelWidth,
          );
        }

        return child;
      },
    );
  }
}

class _PanelLayout extends StatefulWidget {
  const _PanelLayout({
    required this.builder,
  });

  final WidgetLayoutBuilder builder;

  @override
  State<_PanelLayout> createState() => _PanelLayoutState();
}

class _PanelLayoutState extends State<_PanelLayout> with PanelCalcMixin {
  @override
  Widget build(BuildContext context) {
    final panelController = PanelControllerProvider.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge([
        panelController.preferredLeft,
        panelController.preferredRight,
      ]),
      builder: (context, _) {
        final leftPanelWidth = panelController.preferredLeft.value;
        final rightPanelWidth = panelController.preferredRight.value;

        return widget.builder(
          context,
          leftPanelWidth,
          rightPanelWidth,
        );
      },
    );
  }
}

/// If the application becomes
/// too small, the panels automatically hide for once.
/// You can still toggle them manually to make the visible again.
/// In that case, this wouldn't be triggered again.
/// Vice versa, if the application becomes bigger again,
/// the panels will be shown again, and you can of course
/// hide them manually.
class _AutoVisibilityChange extends StatefulWidget {
  const _AutoVisibilityChange({
    required this.child,
  });

  final Widget child;

  @override
  State<_AutoVisibilityChange> createState() => _AutoVisibilityChangeState();
}

class _AutoVisibilityChangeState extends State<_AutoVisibilityChange>
    with PanelCalcMixin {
  late PanelController controller;
  late bool previousVisibilityAutoSetting;
  bool initialized = false;
  double? previousMaxWidth;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    controller = PanelControllerProvider.of(context);
    if (!initialized) {
      previousVisibilityAutoSetting = controller.atLeastOneIsCurrentlyVisible;
      initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidthChanged = previousMaxWidth != constraints.maxWidth;
        if (maxWidthChanged) {
          final visibilityAutoSetting = visibleWithThreshold(
            constraints.maxWidth,
            currentlyVisible: controller.atLeastOneIsCurrentlyVisible,
          );
          final automaticVisibilityChanged =
              visibilityAutoSetting != previousVisibilityAutoSetting;
          if (automaticVisibilityChanged) {
            if (visibilityAutoSetting) {
              controller.show();
            } else {
              controller.hide();
            }
            previousVisibilityAutoSetting = visibilityAutoSetting;
          }
        }
        previousMaxWidth = constraints.maxWidth;
        return widget.child;
      },
    );
  }
}
