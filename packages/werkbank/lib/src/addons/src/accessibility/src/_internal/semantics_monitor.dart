import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:werkbank/src/utils/utils.dart';

class SemanticsMonitor extends StatefulWidget {
  const SemanticsMonitor({
    super.key,
    this.clip = true,
    this.onlyListenToIncluded = false,
    required this.controller,
    required this.child,
  });

  final SemanticsMonitorController controller;

  /// Whether to clip this widget. This will also clip the
  /// descendant semantics nodes to the bounds of this widget.
  final bool clip;

  /// Whether to only report changes on semantic nodes that are explicitly
  /// wrapped in an [IncludeInSemanticsMonitor] widget.
  /// If `false`, all semantic nodes defined by descendants this
  /// [SemanticsMonitor] are included.
  final bool onlyListenToIncluded;
  final Widget child;

  @override
  State<SemanticsMonitor> createState() => _SemanticsMonitorState();
}

class _SemanticsMonitorState extends State<SemanticsMonitor> {
  static var _nextSemanticsMonitorId = 0;

  final int _id = _nextSemanticsMonitorId++;

  final _childKey = GlobalKey();

  PipelineOwner? _pipelineOwner;
  SemanticsHandle? _semanticsHandle;
  bool? _listen;

  void _updateListen() {
    final listen = widget.controller._subscriptions.isNotEmpty;
    if (_listen != listen) {
      _listen = listen;
      if (listen) {
        _semanticsHandle = SemanticsBinding.instance.ensureSemantics();
        _pipelineOwner!.semanticsOwner!.addListener(_update);
        _update();
      } else {
        _pipelineOwner?.semanticsOwner?.removeListener(_update);
        _semanticsHandle?.dispose();
        _semanticsHandle = null;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller._attach(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newPipelineOwner = View.pipelineOwnerOf(context);
    if (newPipelineOwner != _pipelineOwner) {
      if (_listen ?? false) {
        _pipelineOwner?.semanticsOwner?.removeListener(_update);
        newPipelineOwner.semanticsOwner!.addListener(_update);
      }
      _pipelineOwner = newPipelineOwner;
    }
    _updateListen();
  }

  @override
  void dispose() {
    widget.controller._detach(this);
    _pipelineOwner?.semanticsOwner?.removeListener(_update);
    _semanticsHandle?.dispose();
    super.dispose();
  }

  void _update() {
    // Semantic information are only available at the end of a frame and our
    // only chance to paint them on the screen is the next frame. To achieve
    // this, we call setState() in a post-frame callback.
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        // If we got disposed this frame, we will still get an update,
        // because the inactive list is flushed after the semantics updates
        // are transmitted to the semantics clients.
        if (mounted && _listen!) {
          _updateNodes();
        }
      },
      debugLabel: 'SemanticsMonitor.update',
    );
  }

  void _updateNodes() {
    final semanticsOwner = _pipelineOwner!.semanticsOwner!;
    SemanticsNode? semanticsMonitorRoot;
    bool findMonitorRootVisitor(SemanticsNode node) {
      if (node.identifier == _semanticsMonitorRootIdentifier) {
        semanticsMonitorRoot = node;
        return false;
      }
      node.visitChildren(findMonitorRootVisitor);
      return semanticsMonitorRoot == null;
    }

    semanticsOwner.rootSemanticsNode?.visitChildren(findMonitorRootVisitor);

    final includedNodes = <SemanticsNode>[];
    bool addChildrenVisitor(SemanticsNode node) {
      includedNodes.add(node);
      return true;
    }

    bool findIncludedNodesVisitor(SemanticsNode node) {
      if (node.identifier ==
          IncludeInSemanticsMonitor._semanticsNodeIdentifier) {
        node.visitChildren(addChildrenVisitor);
      } else {
        node.visitChildren(findIncludedNodesVisitor);
      }
      return true;
    }

    if (widget.onlyListenToIncluded) {
      semanticsMonitorRoot?.visitChildren(findIncludedNodesVisitor);
    } else {
      semanticsMonitorRoot?.visitChildren(addChildrenVisitor);
    }

    final newNodeSnapshots = <SemanticsNodeSnapshot>[];
    for (final node in includedNodes) {
      final pathToMonitorRoot = <SemanticsNode>[];
      var current = node;
      while (current != semanticsMonitorRoot) {
        pathToMonitorRoot.add(current);
        current = current.parent!;
      }
      final transform = Matrix4.identity();
      for (final node in pathToMonitorRoot.reversed) {
        final nodeTransform = node.transform;
        if (nodeTransform != null) {
          transform.multiply(nodeTransform);
        }
      }
      SemanticsNodeSnapshot toNodeSnapshot(
        SemanticsNode node, {
        required bool isMergedIntoAncestor,
        Matrix4? transformOverride,
      }) {
        final children = <SemanticsNodeSnapshot>[];
        bool addChildrenVisitor(SemanticsNode childNode) {
          children.add(
            toNodeSnapshot(
              childNode,
              isMergedIntoAncestor:
                  isMergedIntoAncestor || node.mergeAllDescendantsIntoThisNode,
            ),
          );
          return true;
        }

        node.visitChildren(addChildrenVisitor);

        return SemanticsNodeSnapshot(
          id: node.id,
          transform: transformOverride ?? node.transform ?? Matrix4.identity(),
          data: node.getSemanticsData(),
          isMergedIntoAncestor: isMergedIntoAncestor,
          children: children.lockUnsafe,
        );
      }

      newNodeSnapshots.add(
        toNodeSnapshot(
          node,
          isMergedIntoAncestor: false,
          transformOverride: transform,
        ),
      );
    }

    widget.controller._nodeSnapshotsNotifier.value =
        newNodeSnapshots.lockUnsafe;
  }

  String get _semanticsMonitorRootIdentifier => 'semantics_monitor_root_$_id';

  @override
  Widget build(BuildContext context) {
    Widget result = Semantics(
      identifier: _semanticsMonitorRootIdentifier,
      container: true,
      explicitChildNodes: true,
      hidden: true,
      child: KeyedSubtree(
        key: _childKey,
        child: widget.child,
      ),
    );
    if (widget.clip) {
      result = ClipRect(
        child: result,
      );
    }
    return result;
  }
}

class SemanticsMonitorController
    with SingleAttachmentMixin<_SemanticsMonitorState> {
  final List<SemanticsMonitoringSubscription> _subscriptions = [];
  final ValueNotifier<IList<SemanticsNodeSnapshot>?> _nodeSnapshotsNotifier =
      ValueNotifier(null);

  void _attach(_SemanticsMonitorState state) {
    attach(state);
  }

  void _detach(_SemanticsMonitorState state) {
    detach(state);
  }

  // We can use private types here, since the method is protected.
  @override
  void onAttachmentChanged(
    // ignore: library_private_types_in_public_api
    _SemanticsMonitorState? oldEntity,
    // ignore: library_private_types_in_public_api
    _SemanticsMonitorState? newEntity,
  ) {
    if (newEntity == null) {
      _nodeSnapshotsNotifier.value = null;
    }
  }

  SemanticsMonitoringSubscription subscribe() {
    final subscription = SemanticsMonitoringSubscription._(this);
    _subscriptions.add(subscription);
    entity?._updateListen();
    return subscription;
  }

  void _cancelSubscription(SemanticsMonitoringSubscription subscription) {
    _subscriptions.remove(subscription);
    entity?._updateListen();
  }

  void dispose() {
    assert(
      _subscriptions.isEmpty,
      'All subscriptions to the controller should have been canceled before '
      'disposing the controller.',
    );
    // TODO(lzuttermeister): Extract to SingleAttachmentMixin?
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        assert(
          entity == null,
          'The controller cannot be disposed while '
          'attached to a SemanticsMonitor.',
        );
      },
    );
    _subscriptions.clear();
    _nodeSnapshotsNotifier.dispose();
  }
}

class SemanticsMonitoringSubscription {
  SemanticsMonitoringSubscription._(this._controller);

  final SemanticsMonitorController _controller;

  ValueListenable<IList<SemanticsNodeSnapshot>?> get nodes =>
      _controller._nodeSnapshotsNotifier;

  void cancel() {
    _controller._cancelSubscription(this);
  }
}

class SemanticsNodeSnapshot with EquatableMixin {
  SemanticsNodeSnapshot({
    required this.id,
    required this.transform,
    required this.data,
    required this.isMergedIntoAncestor,
    required this.children,
  });

  final int id;
  final Matrix4 transform;
  final SemanticsData data;
  final bool isMergedIntoAncestor;
  final IList<SemanticsNodeSnapshot> children;

  Rect get rect => data.rect;

  @override
  List<Object?> get props => [id, transform, data, children];
}

class IncludeInSemanticsMonitor extends StatelessWidget {
  const IncludeInSemanticsMonitor({
    super.key,
    required this.child,
  });

  static const String _semanticsNodeIdentifier = 'include_in_semantics_monitor';

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      container: true,
      explicitChildNodes: true,
      identifier: _semanticsNodeIdentifier,
      hidden: true,
      child: child,
    );
  }
}
