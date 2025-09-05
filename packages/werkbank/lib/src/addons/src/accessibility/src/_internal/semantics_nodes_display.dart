import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:vector_math/vector_math_64.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/accessibility/accessibility.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_monitor.dart';
import 'package:werkbank/src/components/components.dart';

class SemanticsNodesDisplay extends StatefulWidget {
  const SemanticsNodesDisplay({
    super.key,
    required this.controller,
    required this.includeNodePredicate,
    required this.semanticsBoxBuilder,
  });

  final SemanticsMonitorController controller;

  final bool Function(SemanticsNodeSnapshot node) includeNodePredicate;
  final Widget Function(BuildContext context, SemanticsDisplayData data)
  semanticsBoxBuilder;

  @override
  State<SemanticsNodesDisplay> createState() => _SemanticsNodesDisplayState();
}

class _SemanticsNodesDisplayState extends State<SemanticsNodesDisplay> {
  late SemanticsMonitoringSubscription subscription;

  @override
  void initState() {
    super.initState();
    subscription = widget.controller.subscribe();
  }

  @override
  void didUpdateWidget(SemanticsNodesDisplay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      subscription.cancel();
      subscription = widget.controller.subscribe();
    }
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  /// Provides an estimate of the factor by which a small shape should be
  /// scaled to have the same area as the shape at the given point after
  /// applying the given transform.
  /// Note that is not the same as the factor the area is scaled, since
  /// scaling a shape by a factor of `scale` scales the area by `scale^2`.
  /// Returns null if the area of the transformed shape cannot be
  /// computed.
  double? _estimatePointScale(Offset point, Matrix4 transform) {
    final transformedPoint = MatrixUtils.transformPoint(transform, point);
    final transformedUp =
        MatrixUtils.transformPoint(transform, point + const Offset(0, 1)) -
        transformedPoint;
    final transformedRight =
        MatrixUtils.transformPoint(transform, point + const Offset(1, 0)) -
        transformedPoint;
    // Area of the parallelogram spanned by the transformed vectors
    final area =
        transformedUp.dx * transformedRight.dy -
        transformedUp.dy * transformedRight.dx;
    if (area.isNaN) {
      return null;
    }
    return sqrt(area.abs());
  }

  List<Widget> _buildWidgetsForNodes(
    BuildContext context,
    Iterable<SemanticsNodeSnapshot> nodes,
    ValueListenable<int?> activeNodeId,
  ) {
    final widgets = <Widget>[];
    void addWidgets(SemanticsNodeSnapshot node, Matrix4 transform) {
      final nodeTransform = transform.clone()..multiply(node.transform);
      void addNodeWidget() {
        if (!widget.includeNodePredicate(node)) {
          return;
        }
        final rect = node.rect;
        if (rect.isEmpty) {
          return;
        }
        final boxTransform = nodeTransform.clone()
          ..translateByVector3(Vector3(rect.topLeft.dx, rect.topLeft.dy, 0));
        final centerScale = _estimatePointScale(rect.center, boxTransform);
        widgets.add(
          Transform(
            key: ValueKey(node.id),
            transform: boxTransform,
            child: Align(
              alignment: Alignment.topLeft,
              child: SizedBox.fromSize(
                size: node.rect.size,
                child: WScaledBox(
                  scale: 1 / (centerScale ?? 1),
                  child: MappingValueListenableBuilder(
                    valueListenable: activeNodeId,
                    mapper: (value) => value == node.id,
                    builder: (context, isActive, _) {
                      final displayData = SemanticsDisplayData(
                        id: node.id,
                        isActive: isActive,
                        size: node.rect.size,
                        data: node.data,
                      );
                      return widget.semanticsBoxBuilder(context, displayData);
                    },
                  ),
                ),
              ),
            ),
          ),
        );
      }

      addNodeWidget();
      for (final child in node.children) {
        addWidgets(child, nodeTransform);
      }
    }

    for (final node in nodes) {
      addWidgets(node, Matrix4.identity());
    }
    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    final semanticsInspectorController = UseCaseOverlayLayerEntry.access
        .compositionOf(context)
        .accessibility
        .semanticsInspectorController;
    return RepaintBoundary(
      child: ValueListenableBuilder(
        valueListenable: subscription.nodes,
        builder: (context, nodes, _) {
          return Stack(
            fit: StackFit.expand,
            children: nodes != null
                ? _buildWidgetsForNodes(
                    context,
                    nodes,
                    semanticsInspectorController.activeSemanticsNodeId,
                  )
                : const <Widget>[],
          );
        },
      ),
    );
  }
}

class SemanticsDisplayData {
  SemanticsDisplayData({
    required this.id,
    required this.isActive,
    required this.size,
    required this.data,
  });

  final int id;
  final bool isActive;
  final Size size;
  final SemanticsData data;
}
