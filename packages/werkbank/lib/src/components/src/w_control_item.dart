import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

enum ControlItemLayout {
  compact,
  spacious,
}

/// {@category Werkbank Components}
class WControlItem extends StatefulWidget {
  const WControlItem({
    super.key,
    this.layout = ControlItemLayout.compact,
    required this.title,
    this.trailing,
    required this.control,
  });

  final ControlItemLayout layout;
  final Widget title;
  final Widget? trailing;
  final Widget control;

  @override
  State<WControlItem> createState() => _SControlItemState();
}

class _SControlItemState extends State<WControlItem> {
  final _controlKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    // TODO(lzuttermeister): Add tooltip in case it is cut off?
    var styledTitle = DefaultTextStyle.merge(
      style: context.werkbankTextTheme.detail.apply(
        color: context.werkbankColorScheme.text,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      child: widget.title,
    );

    if (widget.trailing != null) {
      styledTitle = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: styledTitle,
            ),
          ),
          widget.trailing!,
        ],
      );
    }

    final keyedControl = KeyedSubtree(
      key: _controlKey,
      child: widget.control,
    );

    late final compactLayout = Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: styledTitle,
          ),
        ),
        Expanded(child: keyedControl),
      ],
    );

    late final spaciousLayout = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: styledTitle,
        ),
        keyedControl,
      ],
    );

    switch (widget.layout) {
      case ControlItemLayout.compact:
        /* TODO(lzuttermeister): Replace this LayoutBuilder with custom
             RenderObjectWidget. This will also get rid of the global key. */
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth < 320) {
              return spaciousLayout;
            }
            return compactLayout;
          },
        );
      case ControlItemLayout.spacious:
        return spaciousLayout;
    }
  }
}
