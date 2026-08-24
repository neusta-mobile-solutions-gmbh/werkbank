import 'package:flutter/material.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/components/src/w_resizable_panels/_internal/draggable_divider.dart';
import 'package:werkbank/src/components/src/w_resizable_panels/_internal/panel_controller_provider.dart';
import 'package:werkbank/src/components/src/w_resizable_panels/_internal/panel_layout_handler.dart';

/// {@category Werkbank Components}
class WResizablePanels extends StatelessWidget {
  const WResizablePanels({
    super.key,
    required this.controller,
    required this.leftPanel,
    required this.rightPanel,
    required this.child,
  });

  final WPanelController controller;
  final Widget leftPanel;
  final Widget rightPanel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return WPanelControllerProvider(
      controller: controller,
      child: PanelLayoutHandler(
        child: Row(
          children: [
            _LeftPanelLayout(
              child: leftPanel,
            ),
            const _LeftSeparator(),
            Expanded(
              child: child,
            ),
            const _RightSeparator(),
            _RightPanelLayout(
              child: rightPanel,
            ),
          ],
        ),
      ),
    );
  }
}

class _LeftPanelLayout extends StatelessWidget {
  const _LeftPanelLayout({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = PanelLayoutHandler.leftAnimationOf(context);
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        axisAlignment: 1,
        fixedCrossAxisSizeFactor: 1,
        axis: Axis.horizontal,
        child: SizedBox(
          width: PanelLayoutHandler.leftWidthOf(context),
          child: child,
        ),
      ),
    );
  }
}

class _RightPanelLayout extends StatelessWidget {
  const _RightPanelLayout({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final animation = PanelLayoutHandler.rightAnimationOf(context);
    return FadeTransition(
      opacity: animation,
      child: SizeTransition(
        sizeFactor: animation,
        axisAlignment: -1,
        fixedCrossAxisSizeFactor: 1,
        axis: Axis.horizontal,
        child: SizedBox(
          width: PanelLayoutHandler.rightWidthOf(context),
          child: child,
        ),
      ),
    );
  }
}

class _LeftSeparator extends StatelessWidget {
  const _LeftSeparator();

  @override
  Widget build(BuildContext context) {
    return DraggableDivider(
      getInitial: () =>
          PanelLayoutHandler.leftWidthOf(context) *
          PanelLayoutHandler.leftAnimationOf(context).value,
      onUpdate: (value) => PanelLayoutHandler.updateLeftWidthOf(context, value),
    );
  }
}

class _RightSeparator extends StatelessWidget {
  const _RightSeparator();

  @override
  Widget build(BuildContext context) {
    return DraggableDivider(
      direction: DraggableDividerDirection.endToStart,
      getInitial: () =>
          PanelLayoutHandler.rightWidthOf(context) *
          PanelLayoutHandler.rightAnimationOf(context).value,
      onUpdate: (value) =>
          PanelLayoutHandler.updateRightWidthOf(context, value),
    );
  }
}
