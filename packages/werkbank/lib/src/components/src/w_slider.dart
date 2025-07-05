import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

/* TODO(lzuttermeister): This needs to be focusable,
     have hover states, a disabled state, semantics, shortcuts etc. */
/// {@category Werkbank Components}
class WSlider extends StatelessWidget {
  const WSlider({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 1,
    this.divisions,
    this.valueFormatter = defaultFormatter,
    required this.onChanged,
  }) : assert(min <= max, 'Min must be smaller or equal to max.'),
       assert(
         divisions == null || divisions > 0,
         'Divisions must be null or positive.',
       );

  static String defaultFormatter(double value) {
    return value.toStringAsFixed(2);
  }

  static const _minPositionOffset = 2.0;

  static double _mapRanges({
    required double value,
    required double fromMin,
    required double fromMax,
    required double toMin,
    required double toMax,
    bool clamp = false,
  }) {
    final result =
        (value - fromMin) / (fromMax - fromMin) * (toMax - toMin) + toMin;
    return clamp ? result.clamp(toMin, toMax) : result;
  }

  static double _snapToDivisions(double value, int divisions) {
    return (value * divisions).round() / divisions;
  }

  final double value;
  final double min;
  final double max;
  final int? divisions;
  final DoubleFormatter valueFormatter;
  final ValueChanged<double>? onChanged;

  void _onChanged(BuildContext context, Offset localPosition) {
    var newValue = _mapRanges(
      value: localPosition.dx,
      fromMin: _minPositionOffset,
      fromMax: context.size!.width,
      toMin: 0,
      toMax: 1,
    );
    if (divisions != null) {
      newValue = _snapToDivisions(newValue, divisions!);
    }
    newValue = _mapRanges(
      value: newValue,
      fromMin: 0,
      fromMax: 1,
      toMin: min,
      toMax: max,
      clamp: true,
    );
    onChanged!(newValue);
  }

  @override
  Widget build(BuildContext context) {
    final formattedValue = valueFormatter(value);
    return WTempDisabler(
      enabled: onChanged != null,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.werkbankColorScheme.field,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2),
          // This SizedBox also ensures that there is a RenderObject around
          // the builder with the correct size.
          child: SizedBox(
            width: double.infinity,
            child: Builder(
              builder: (context) {
                return GestureDetector(
                  onPanStart: onChanged != null
                      ? (details) => _onChanged(context, details.localPosition)
                      : null,
                  onPanUpdate: onChanged != null
                      ? (details) => _onChanged(context, details.localPosition)
                      : null,
                  child: AbsorbPointer(
                    child: Stack(
                      fit: StackFit.passthrough,
                      children: [
                        _SliderContent(
                          value: formattedValue,
                          textColor: context.werkbankColorScheme.fieldContent,
                        ),
                        ClipRRect(
                          clipper: _SliderClipper(
                            startOffset: _minPositionOffset,
                            factor: _mapRanges(
                              value: value,
                              fromMin: min,
                              fromMax: max,
                              toMin: 0,
                              toMax: 1,
                              clamp: true,
                            ),
                          ),
                          child: ColoredBox(
                            color: context.werkbankColorScheme.fieldContent,
                            child: _SliderContent(
                              value: formattedValue,
                              textColor: context.werkbankColorScheme.field,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _SliderClipper extends CustomClipper<RRect> {
  const _SliderClipper({
    required this.startOffset,
    required this.factor,
  });

  final double startOffset;
  final double factor;

  @override
  RRect getClip(Size size) {
    return RRect.fromRectAndRadius(
      Rect.fromLTWH(
        0,
        0,
        (size.width - startOffset) * factor + startOffset,
        size.height,
      ),
      const Radius.circular(2),
    );
  }

  @override
  bool shouldReclip(_SliderClipper oldClipper) {
    return oldClipper.factor != factor || oldClipper.startOffset != startOffset;
  }
}

class _SliderContent extends StatelessWidget {
  const _SliderContent({
    required this.value,
    required this.textColor,
  });

  final String value;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      child: Text(
        value,
        style: context.werkbankTextTheme.interaction.apply(color: textColor),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
