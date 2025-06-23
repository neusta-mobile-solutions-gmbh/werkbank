import 'package:flutter/material.dart';

class DebuggingRepaintChildren extends StatefulWidget {
  const DebuggingRepaintChildren({
    super.key,
    required this.child,
  });

  static void repaintAllChildren(BuildContext context) {
    context
        .findAncestorStateOfType<_DebuggingRepaintChildrenState>()!
        .repaint();
  }

  final Widget child;

  @override
  State<DebuggingRepaintChildren> createState() =>
      _DebuggingRepaintChildrenState();
}

class _DebuggingRepaintChildrenState extends State<DebuggingRepaintChildren> {
  void repaint() {
    (context as Element).visitChildren(_recrusiveRepaint);
  }

  void _recrusiveRepaint(Element el) {
    el.findRenderObject()?.markNeedsPaint();
    el.visitChildren(_recrusiveRepaint);
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
