import 'package:flutter/material.dart';

/// {@category Werkbank Components}
class WDivider extends StatelessWidget {
  const WDivider({
    super.key,
    this.thickness = 2,
    required this.axis,
    this.color,
  });

  const WDivider.horizontal({
    super.key,
    this.thickness = 2,
    this.color,
  }) : axis = Axis.horizontal;

  const WDivider.vertical({
    super.key,
    this.thickness = 2,
    this.color,
  }) : axis = Axis.vertical;

  final double thickness;
  final Axis axis;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: color ?? context.werkbankColorScheme.divider,
      child: switch (axis) {
        Axis.horizontal => SizedBox(height: thickness, width: double.infinity),
        Axis.vertical => SizedBox(height: double.infinity, width: thickness),
      },
    );
  }
}
