import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

class CurveKnobWidget extends StatelessWidget {
  const CurveKnobWidget({
    required this.currentCurve,
    required this.allCurves,
    required this.onChanged,
    super.key,
  });

  final NamedCurve currentCurve;
  final List<NamedCurve> allCurves;
  final ValueChanged<NamedCurve?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WDropdown<NamedCurve>(
          onChanged: onChanged,
          value: currentCurve,
          items: [
            for (final curve in allCurves)
              WDropdownMenuItem(
                value: curve,
                child: RichText(
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  text: TextSpan(
                    style: context.werkbankTextTheme.defaultText.apply(
                      color: context.werkbankColorScheme.text,
                    ),
                    text: curve.name,
                    children: curve.trailing != null
                        ? [
                            TextSpan(
                              text: ' ${curve.trailing}',
                              style: context.werkbankTextTheme.textLight,
                            ),
                          ]
                        : null,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}
