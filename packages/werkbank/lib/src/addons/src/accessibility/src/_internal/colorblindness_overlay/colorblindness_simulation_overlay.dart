import 'package:flutter/widgets.dart';
import 'package:werkbank/src/addons/src/accessibility/accessibility.dart';

class ColorBlindnessSimulationOverlay extends StatefulWidget {
  const ColorBlindnessSimulationOverlay({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<ColorBlindnessSimulationOverlay> createState() =>
      _ColorBlindnessSimulationOverlayState();
}

class _ColorBlindnessSimulationOverlayState
    extends State<ColorBlindnessSimulationOverlay> {
  final _childKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final simulatedColorBlindnessType =
        AccessibilityManager.simulatedColorBlindnessTypeOf(context);
    Widget result = KeyedSubtree(
      key: _childKey,
      child: widget.child,
    );
    if (simulatedColorBlindnessType != null) {
      result = ColorFiltered(
        colorFilter: const ColorFilter.linearToSrgbGamma(),
        child: ColorFiltered(
          colorFilter: ColorFilter.matrix(
            simulatedColorBlindnessType.matrix,
          ),
          child: ColorFiltered(
            colorFilter: const ColorFilter.srgbToLinearGamma(),
            child: result,
          ),
        ),
      );
    }
    return result;
  }
}
