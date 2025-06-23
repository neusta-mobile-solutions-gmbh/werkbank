import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

/// {@category Werkbank Components}
class WSwitch extends StatelessWidget {
  const WSwitch({
    super.key,
    required this.value,
    required this.onChanged,
    required this.falseLabel,
    required this.trueLabel,
  });

  final bool value;
  final ValueChanged<bool>? onChanged;
  final Widget falseLabel;
  final Widget trueLabel;

  @override
  Widget build(BuildContext context) {
    return WTempDisabler(
      enabled: onChanged != null,
      child: WButtonBase(
        onPressed: onChanged == null ? null : () => onChanged!(!value),
        child: Stack(
          fit: StackFit.passthrough,
          children: [
            _SwitchContent(
              leftLabel: falseLabel,
              rightLabel: trueLabel,
              textColor: context.werkbankColorScheme.fieldContent,
            ),
            ExcludeSemantics(
              child: TweenAnimationBuilder<double>(
                duration: Durations.short2,
                curve: Curves.easeInOut,
                tween: Tween<double>(
                  begin: value ? 1 : 0,
                  end: value ? 1 : 0,
                ),
                builder: (context, value, child) {
                  return ClipRRect(
                    clipper: _SwitchClipper(value),
                    child: child,
                  );
                },
                child: ColoredBox(
                  color: context.werkbankColorScheme.fieldContent,
                  child: _SwitchContent(
                    leftLabel: falseLabel,
                    rightLabel: trueLabel,
                    textColor: context.werkbankColorScheme.field,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SwitchClipper extends CustomClipper<RRect> {
  const _SwitchClipper(this.position);

  final double position;

  @override
  RRect getClip(Size size) {
    return RRect.fromRectAndRadius(
      Rect.fromLTWH(
        size.width * (position / 2),
        0,
        size.width / 2,
        size.height,
      ),
      const Radius.circular(2),
    );
  }

  @override
  bool shouldReclip(_SwitchClipper oldClipper) {
    return oldClipper.position != position;
  }
}

class _SwitchContent extends StatelessWidget {
  const _SwitchContent({
    required this.leftLabel,
    required this.rightLabel,
    required this.textColor,
  });

  final Widget leftLabel;
  final Widget rightLabel;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    const textPadding = EdgeInsets.symmetric(vertical: 10, horizontal: 12);
    final textStyle = context.werkbankTextTheme.interaction.apply(
      color: textColor,
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Padding(
            padding: textPadding,
            child: DefaultTextStyle.merge(
              style: textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              child: leftLabel,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: textPadding,
            child: DefaultTextStyle.merge(
              style: textStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.end,
              child: rightLabel,
            ),
          ),
        ),
      ],
    );
  }
}
