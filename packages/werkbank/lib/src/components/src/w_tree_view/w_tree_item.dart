import 'dart:math';

import 'package:flutter/material.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/theme/theme.dart';

/// {@category Werkbank Components}
class WTreeItem extends StatefulWidget {
  const WTreeItem({
    super.key,
    this.leading,
    required this.label,
    this.trailing,
    this.nestingLevel = 0,
    this.isSelected = false,
    this.initExpanded = false,
    this.onExpansionChanged,
    this.onTap,
  });

  final Widget? leading;
  final Widget label;
  final Widget? trailing;
  final int nestingLevel;
  final bool initExpanded;
  final bool isSelected;
  final ValueChanged<bool>? onExpansionChanged;
  final VoidCallback? onTap;

  @override
  State<WTreeItem> createState() => _WTreeItemState();
}

class _WTreeItemState extends State<WTreeItem> {
  late bool expanded;

  @override
  void initState() {
    super.initState();
    expanded = widget.initExpanded;
  }

  double _calculateIndentation(double nestingLevel) {
    return (1 - (pow(2, -1.0 * nestingLevel / 4.0))) * 64.0;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.werkbankTextTheme;
    final colorScheme = context.werkbankColorScheme;
    final color = widget.isSelected
        ? context.werkbankColorScheme.textActive
        : context.werkbankColorScheme.text;
    return WButtonBase(
      onPressed: widget.onTap,
      backgroundColor: Colors.transparent,
      borderRadius: BorderRadius.circular(8),
      showBorder: !widget.isSelected,
      isActive: widget.isSelected,
      activeBackgroundColor: colorScheme.backgroundActive,
      child: IconTheme.merge(
        data: IconThemeData(
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 12),
          child: Row(
            children: [
              SizedBox(
                width: _calculateIndentation(widget.nestingLevel.toDouble()),
              ),
              if (widget.onExpansionChanged != null)
                WButtonBase(
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    setState(() {
                      expanded = !expanded;
                    });
                    widget.onExpansionChanged!(expanded);
                  },
                  child: WExpandedIndicator(
                    isExpanded: expanded,
                    iconColor: color,
                  ),
                )
              else
                const SizedBox(width: 16),
              const SizedBox(width: 4),
              if (widget.leading != null)
                SizedBox(
                  width: 16,
                  child: widget.leading,
                ),
              const SizedBox(width: 8),
              Expanded(
                child: DefaultTextStyle.merge(
                  style: textTheme.detail.apply(
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  child: widget.label,
                ),
              ),
              if (widget.trailing != null) widget.trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
