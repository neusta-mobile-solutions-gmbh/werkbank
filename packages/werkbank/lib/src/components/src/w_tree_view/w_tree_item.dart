import 'dart:math';

import 'package:flutter/material.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/theme/theme.dart';

/// {@category Werkbank Components}
class WTreeItem extends StatelessWidget {
  const WTreeItem({
    super.key,
    this.leading,
    required this.label,
    this.trailing,
    this.nestingLevel = 0,
    this.isSelected = false,
    required this.isExpanded,
    this.onExpansionChanged,
    this.onTap,
  });

  final Widget? leading;
  final Widget label;
  final Widget? trailing;
  final int nestingLevel;
  final bool isExpanded;
  final bool isSelected;
  final ValueChanged<bool>? onExpansionChanged;
  final VoidCallback? onTap;

  double _calculateIndentation(double nestingLevel) {
    return (1 - (pow(2, -1.0 * nestingLevel / 4.0))) * 64.0;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.werkbankTextTheme;
    final colorScheme = context.werkbankColorScheme;
    final color = isSelected
        ? context.werkbankColorScheme.textActive
        : context.werkbankColorScheme.text;
    return WButtonBase(
      onPressed: onTap,
      backgroundColor: Colors.transparent,
      borderRadius: BorderRadius.circular(4),
      showBorder: !isSelected,
      isActive: isSelected,
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
                width: _calculateIndentation(nestingLevel.toDouble()),
              ),
              if (onExpansionChanged != null)
                WButtonBase(
                  backgroundColor: Colors.transparent,
                  onPressed: () {
                    onExpansionChanged!(!isExpanded);
                  },
                  child: WExpandedIndicator(
                    isExpanded: isExpanded,
                    iconColor: color,
                  ),
                )
              else
                const SizedBox(width: 16),
              const SizedBox(width: 4),
              if (leading != null)
                SizedBox(
                  width: 16,
                  child: leading,
                ),
              const SizedBox(width: 8),
              Expanded(
                child: DefaultTextStyle.merge(
                  style: textTheme.detail.apply(
                    color: color,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  child: label,
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
