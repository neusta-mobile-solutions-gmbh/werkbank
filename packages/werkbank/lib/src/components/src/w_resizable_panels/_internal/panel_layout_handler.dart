import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/components/src/w_resizable_panels/_internal/panel_controller_provider.dart';
import 'package:werkbank/src/components/src/w_resizable_panels/_internal/panel_utils.dart';

// TODO: Unused. Remove?
typedef PanelLayoutBuilder =
    Widget Function(
      BuildContext context,
      double leftPanelWidth,
      double rightPanelWidth,
      Animation<double> leftAnimation,
      Animation<double> rightAnimation,
    );

class PanelLayoutHandler extends StatelessWidget {
  const PanelLayoutHandler({
    super.key,
    // TODO: Unused. Remove?
    // required this.builder,
    required this.child,
  });

  static double leftWidthOf(BuildContext context) =>
      _InheritedPanelLayout.of(context).leftWidth;

  static double rightWidthOf(BuildContext context) =>
      _InheritedPanelLayout.of(context).rightWidth;

  static Animation<double> leftAnimationOf(BuildContext context) =>
      _InheritedPanelLayout.of(context).leftAnimation;

  static Animation<double> rightAnimationOf(BuildContext context) =>
      _InheritedPanelLayout.of(context).rightAnimation;

  static void updateLeftWidthOf(BuildContext context, double leftWidth) =>
      _InheritedPanelLayout.of(context).updateLeftWidth(leftWidth);

  static void updateRightWidthOf(BuildContext context, double rightWidth) =>
      _InheritedPanelLayout.of(context).updateRightWidth(rightWidth);

  static const _minWidth = 200.0;
  static const _verySmallWidth = 10.0;
  static const _minGap = 100;

  // TODO: Unused. Remove?
  // final PanelLayoutBuilder builder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final panelController = WPanelControllerProvider.of(context);
    return LayoutBuilder(
      builder: (context, constrains) {
        final maxWidth = (constrains.maxWidth - _minGap) / 2;
        return ListenableBuilder(
          listenable: Listenable.merge([
            panelController.leftWidth,
            panelController.rightWidth,
            panelController.leftExpanded,
            panelController.rightExpanded,
          ]),
          builder: (context, _) {
            var leftWidth = panelController.leftWidth.value;
            var rightWidth = panelController.rightWidth.value;
            leftWidth = min(leftWidth, maxWidth);
            rightWidth = min(rightWidth, maxWidth);
            leftWidth = max(leftWidth, _minWidth);
            rightWidth = max(rightWidth, _minWidth);

            void update(
              ValueNotifier<double> width,
              ValueNotifier<bool> expanded,
              double value,
            ) {
              if (value < _verySmallWidth) {
                expanded.value = false;
              }
              if (value > _minWidth) {
                expanded.value = true;
              }
              if (maxWidth >= _minWidth) {
                width.value = value.clamp(
                  _minWidth,
                  maxWidth,
                );
              }
            }

            return _ExpansionAnimations(
              isLeftExpanded:
                  panelController.leftExpanded.value && maxWidth >= _minWidth,
              isRightExpanded:
                  panelController.rightExpanded.value && maxWidth >= _minWidth,
              builder: (context, leftAnimation, rightAnimation) {
                return _InheritedPanelLayout(
                  leftWidth: leftWidth,
                  rightWidth: rightWidth,
                  leftAnimation: leftAnimation,
                  rightAnimation: rightAnimation,
                  updateLeftWidth: (value) {
                    update(
                      panelController.leftWidth,
                      panelController.leftExpanded,
                      value,
                    );
                  },
                  updateRightWidth: (value) {
                    update(
                      panelController.rightWidth,
                      panelController.rightExpanded,
                      value,
                    );
                  },
                  child: child,
                  // TODO: Unused. Remove?
                  // child: builder(
                  //   context,
                  //   leftWidth,
                  //   rightWidth,
                  //   leftAnimation,
                  //   rightAnimation,
                  // ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _ExpansionAnimations extends StatefulWidget {
  const _ExpansionAnimations({
    required this.isLeftExpanded,
    required this.isRightExpanded,
    required this.builder,
  });

  final bool isLeftExpanded;
  final bool isRightExpanded;
  final Widget Function(
    BuildContext context,
    Animation<double> leftAnimation,
    Animation<double> rightAnimation,
  )
  builder;

  @override
  State<_ExpansionAnimations> createState() => _ExpansionAnimationsState();
}

class _InheritedPanelLayout extends InheritedWidget {
  const _InheritedPanelLayout({
    required this.leftWidth,
    required this.rightWidth,
    required this.leftAnimation,
    required this.rightAnimation,
    required this.updateLeftWidth,
    required this.updateRightWidth,
    required super.child,
  });

  static _InheritedPanelLayout of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<_InheritedPanelLayout>();
    assert(result != null, 'No PanelLayoutHandler found in context');
    return result!;
  }

  final double leftWidth;
  final double rightWidth;
  final Animation<double> leftAnimation;
  final Animation<double> rightAnimation;
  final void Function(double leftWidth) updateLeftWidth;
  final void Function(double rightWidth) updateRightWidth;

  @override
  bool updateShouldNotify(_InheritedPanelLayout old) {
    return leftWidth != old.leftWidth ||
        rightWidth != old.rightWidth ||
        leftAnimation != old.leftAnimation ||
        rightAnimation != old.rightAnimation ||
        updateLeftWidth != old.updateLeftWidth ||
        updateRightWidth != old.updateRightWidth;
  }
}

class _ExpansionAnimationsState extends State<_ExpansionAnimations>
    with TickerProviderStateMixin {
  late final AnimationController _leftAnimation;
  late final AnimationController _rightAnimation;

  @override
  void initState() {
    super.initState();
    _leftAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.isLeftExpanded ? 1.0 : 0.0,
    );
    _rightAnimation = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.isRightExpanded ? 1.0 : 0.0,
    );
  }

  @override
  void didUpdateWidget(covariant _ExpansionAnimations oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLeftExpanded != widget.isLeftExpanded) {
      unawaited(
        _leftAnimation.animateWith(
          SpringSimulation(
            SpringDescription.withDurationAndBounce(),
            _leftAnimation.value,
            widget.isLeftExpanded ? 1.0 : 0.0,
            _leftAnimation.velocity,
          ),
        ),
      );
    }
    if (oldWidget.isRightExpanded != widget.isRightExpanded) {
      unawaited(
        _rightAnimation.animateWith(
          SpringSimulation(
            SpringDescription.withDurationAndBounce(),
            _rightAnimation.value,
            widget.isRightExpanded ? 1.0 : 0.0,
            _rightAnimation.velocity,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _leftAnimation,
      _rightAnimation,
    );
  }
}

// typedef WidgetLayoutBuilder =
//     Widget Function(
//       BuildContext context,
//       double leftPanelWidth,
//       double rightPanelWidth,
//     );
//
// /// Sizes the panels and
// /// decides, if the panels need to be shrunk.
// /// Tells the [WPanelController] to do so.
// class PanelLayoutHandler extends StatelessWidget {
//   const PanelLayoutHandler({
//     required this.builder,
//     super.key,
//   });
//
//   final WidgetLayoutBuilder builder;
//
//   @override
//   Widget build(BuildContext context) {
//     return _PanelShrinking(
//       child: _AutoVisibilityChange(
//         child: _PanelLayout(
//           builder: builder,
//         ),
//       ),
//     );
//   }
// }
//
// class _PanelShrinking extends StatelessWidget with PanelCalcMixin {
//   const _PanelShrinking({
//     required this.child,
//   });
//
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     final panelController = WPanelControllerProvider.of(context);
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final newMaxPanelWidth = maxPanelWidth(constraints.maxWidth);
//
//         // This would be problematic, if we would update State in
//         // some inherited widget, since this happens in the build phase.
//         // But since we use ValueNotifiers, this is fine for now.
//         if (panelController.maxWidth.value != newMaxPanelWidth) {
//           panelController.updateMaxWidth(
//             newMaxPanelWidth,
//           );
//         }
//
//         return child;
//       },
//     );
//   }
// }
//
// class _PanelLayout extends StatefulWidget {
//   const _PanelLayout({
//     required this.builder,
//   });
//
//   final WidgetLayoutBuilder builder;
//
//   @override
//   State<_PanelLayout> createState() => _PanelLayoutState();
// }
//
// class _PanelLayoutState extends State<_PanelLayout> with PanelCalcMixin {
//   @override
//   Widget build(BuildContext context) {
//     final panelController = WPanelControllerProvider.of(context);
//     return ListenableBuilder(
//       listenable: Listenable.merge([
//         panelController.leftWidth,
//         panelController.rightWidth,
//       ]),
//       builder: (context, _) {
//         final leftPanelWidth = panelController.leftWidth.value;
//         final rightPanelWidth = panelController.rightWidth.value;
//
//         return widget.builder(
//           context,
//           leftPanelWidth,
//           rightPanelWidth,
//         );
//       },
//     );
//   }
// }
//
// /// If the application becomes
// /// too small, the panels automatically hide for once.
// /// You can still toggle them manually to make the visible again.
// /// In that case, this wouldn't be triggered again.
// /// Vice versa, if the application becomes bigger again,
// /// the panels will be shown again, and you can of course
// /// hide them manually.
// class _AutoVisibilityChange extends StatefulWidget {
//   const _AutoVisibilityChange({
//     required this.child,
//   });
//
//   final Widget child;
//
//   @override
//   State<_AutoVisibilityChange> createState() => _AutoVisibilityChangeState();
// }
//
// class _AutoVisibilityChangeState extends State<_AutoVisibilityChange>
//     with PanelCalcMixin {
//   late WPanelController controller;
//   late bool previousVisibilityAutoSetting;
//   bool initialized = false;
//   double? previousMaxWidth;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     controller = WPanelControllerProvider.of(context);
//     if (!initialized) {
//       previousVisibilityAutoSetting = controller.atLeastOneIsCurrentlyVisible;
//       initialized = true;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final maxWidthChanged = previousMaxWidth != constraints.maxWidth;
//         if (maxWidthChanged) {
//           final visibilityAutoSetting = visibleWithThreshold(
//             constraints.maxWidth,
//             currentlyVisible: controller.atLeastOneIsCurrentlyVisible,
//           );
//           final automaticVisibilityChanged =
//               visibilityAutoSetting != previousVisibilityAutoSetting;
//           if (automaticVisibilityChanged) {
//             if (visibilityAutoSetting) {
//               unawaited(controller.show());
//             } else {
//               unawaited(controller.hide());
//             }
//             previousVisibilityAutoSetting = visibilityAutoSetting;
//           }
//         }
//         previousMaxWidth = constraints.maxWidth;
//         return widget.child;
//       },
//     );
//   }
// }
