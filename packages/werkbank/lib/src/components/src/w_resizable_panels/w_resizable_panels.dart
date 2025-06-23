import 'package:flutter/material.dart';
import 'package:werkbank/src/components/src/w_resizable_panels/_internal/draggable_divider.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Werkbank Components}
class WResizablePanels extends StatelessWidget {
  const WResizablePanels({
    super.key,
    required this.leftPanel,
    required this.rightPanel,
    required this.child,
  });

  final Widget leftPanel;
  final Widget rightPanel;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PanelLayoutHandler(
      builder: (context, leftPanelWidth, rightPanelWidth) {
        return Row(
          children: [
            _LeftPanelLayout(
              width: leftPanelWidth,
              child: leftPanel,
            ),
            const _LeftSeparator(),
            Expanded(
              child: child,
            ),
            const _RightSeparator(),
            _RightPanelLayout(
              width: rightPanelWidth,
              child: rightPanel,
            ),
          ],
        );
      },
    );
  }
}

class _LeftPanelLayout extends StatelessWidget {
  const _LeftPanelLayout({
    required this.width,
    required this.child,
  });

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final panelController = PanelControllerProvider.of(context);
    return FadeTransition(
      opacity: panelController.leftAnimation,
      child: SizeTransition(
        sizeFactor: panelController.leftAnimation,
        axisAlignment: 1,
        fixedCrossAxisSizeFactor: 1,
        axis: Axis.horizontal,
        child: SizedBox(
          width: width,
          child: child,
        ),
      ),
    );
  }
}

class _RightPanelLayout extends StatelessWidget {
  const _RightPanelLayout({
    required this.width,
    required this.child,
  });

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final panelController = PanelControllerProvider.of(context);
    return FadeTransition(
      opacity: panelController.rightAnimation,
      child: SizeTransition(
        sizeFactor: panelController.rightAnimation,
        axisAlignment: -1,
        fixedCrossAxisSizeFactor: 1,
        axis: Axis.horizontal,
        child: SizedBox(
          width: width,
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
    final panelController = PanelControllerProvider.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge([
        panelController.preferredLeft,
        panelController.leftAnimation,
      ]),
      builder: (context, child) {
        return DraggableDivider(
          initial:
              panelController.preferredLeft.value *
              panelController.leftAnimation.value,
          onUpdate: panelController.proposePreferredLeft,
        );
      },
    );
  }
}

class _RightSeparator extends StatelessWidget {
  const _RightSeparator();

  @override
  Widget build(BuildContext context) {
    final panelController = PanelControllerProvider.of(context);
    return ListenableBuilder(
      listenable: Listenable.merge([
        panelController.preferredRight,
        panelController.rightAnimation,
      ]),
      builder: (context, child) {
        return DraggableDivider(
          initial:
              panelController.preferredRight.value *
              panelController.rightAnimation.value,
          onUpdate: panelController.proposePreferredRight,
          direction: DraggableDividerDirection.endToStart,
        );
      },
    );
  }
}
