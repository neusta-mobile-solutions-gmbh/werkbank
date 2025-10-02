import 'package:flutter/material.dart';

class WTreeNode {
  WTreeNode({
    required this.key,
    required this.title,
    // this.pathSegments,
    this.leading,
    this.trailing,
    this.body,
    this.isInitiallyExpanded = false,
    this.children,
    this.onTap,
    this.isSelected = false,
    this.isVisible = true,
  });

  final LocalKey key;
  final Widget title;

  // // For automatic expansion and scrolling
  // final List<String>? pathSegments;

  final Widget? leading;
  final Widget? trailing;
  final Widget? body;
  final bool isInitiallyExpanded;
  final List<WTreeNode>? children;
  final VoidCallback? onTap;
  final bool isSelected;

  // Can be invisible due to filtering
  final bool isVisible;
}
