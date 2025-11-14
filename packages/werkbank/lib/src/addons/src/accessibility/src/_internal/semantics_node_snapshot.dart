import 'package:equatable/equatable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/rendering.dart';

class SemanticsNodeSnapshot with EquatableMixin {
  SemanticsNodeSnapshot({
    required this.id,
    required this.transform,
    required this.data,
    required this.isMergedIntoParent,
    required this.mergeAllDescendantsIntoThisNode,
    required this.areUserActionsBlocked,
    required this.indexInParent,
    required this.children,
  });

  final int id;
  final Matrix4 transform;
  final SemanticsData data;
  final bool isMergedIntoParent;
  final bool mergeAllDescendantsIntoThisNode;
  final bool areUserActionsBlocked;
  final int? indexInParent;
  final IList<SemanticsNodeSnapshot> children;

  Rect get rect => data.rect;

  @override
  List<Object?> get props => [
    id,
    transform,
    data,
    isMergedIntoParent,
    mergeAllDescendantsIntoThisNode,
    areUserActionsBlocked,
    indexInParent,
    children,
  ];
}
