import 'package:flutter/material.dart';

/// {@category Werkbank Components}
class WExpandedIndicator extends StatelessWidget {
  const WExpandedIndicator({
    required this.isExpanded,
    this.iconColor,
    super.key,
  });

  final bool isExpanded;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedRotation(
      duration: Durations.short3,
      turns: isExpanded ? 0 : -0.25,
      curve: Curves.easeInOutCubic,
      child: Icon(
        // TODO(jthranitz): Replace with own icon.
        Icons.arrow_drop_down,
        color: iconColor,
        size: 16,
      ),
    );
  }
}
