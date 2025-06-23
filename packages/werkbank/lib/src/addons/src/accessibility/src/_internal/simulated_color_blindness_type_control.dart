import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/colorblindness_overlay/colorblindness_type.dart';
import 'package:werkbank/werkbank.dart';

/// A control widget that allows users to toggle
/// between different colorblindness modes
class SimulatedColorBlindnessTypeControl extends StatelessWidget {
  /// Creates a colorblindness mode control widget
  const SimulatedColorBlindnessTypeControl({super.key});

  static final List<ColorBlindnessType> _options = [
    ColorBlindnessType.inverted,
    ColorBlindnessType.grayscale,
    ColorBlindnessType.protanopia,
    ColorBlindnessType.protanomaly,
    ColorBlindnessType.deuteranopia,
    ColorBlindnessType.deuteranomaly,
    ColorBlindnessType.tritanopia,
    ColorBlindnessType.tritanomaly,
  ];

  @override
  Widget build(BuildContext context) {
    return WControlItem(
      title: Text(
        context.sL10n.addons.accessibility.controls.colorMode.name,
      ),
      control: WDropdown<ColorBlindnessType?>(
        value: AccessibilityManager.simulatedColorBlindnessTypeOf(context),
        items: [
          WDropdownMenuItem<ColorBlindnessType?>(
            value: null,
            child: Text(
              context.sL10n.addons.accessibility.controls.colorMode.values.none,
            ),
          ),
          for (final mode in _options)
            WDropdownMenuItem<ColorBlindnessType>(
              value: mode,
              child: Text(
                switch (mode) {
                  ColorBlindnessType.protanopia =>
                    context
                        .sL10n
                        .addons
                        .accessibility
                        .controls
                        .colorMode
                        .values
                        .protanopia,
                  ColorBlindnessType.protanomaly =>
                    context
                        .sL10n
                        .addons
                        .accessibility
                        .controls
                        .colorMode
                        .values
                        .protanomaly,
                  ColorBlindnessType.deuteranopia =>
                    context
                        .sL10n
                        .addons
                        .accessibility
                        .controls
                        .colorMode
                        .values
                        .deuteranopia,
                  ColorBlindnessType.deuteranomaly =>
                    context
                        .sL10n
                        .addons
                        .accessibility
                        .controls
                        .colorMode
                        .values
                        .deuteranomaly,
                  ColorBlindnessType.tritanopia =>
                    context
                        .sL10n
                        .addons
                        .accessibility
                        .controls
                        .colorMode
                        .values
                        .tritanopia,
                  ColorBlindnessType.tritanomaly =>
                    context
                        .sL10n
                        .addons
                        .accessibility
                        .controls
                        .colorMode
                        .values
                        .tritanomaly,
                  ColorBlindnessType.inverted =>
                    context
                        .sL10n
                        .addons
                        .accessibility
                        .controls
                        .colorMode
                        .values
                        .inverted,
                  ColorBlindnessType.grayscale =>
                    context
                        .sL10n
                        .addons
                        .accessibility
                        .controls
                        .colorMode
                        .values
                        .grayscale,
                },
              ),
            ),
        ],
        onChanged: (value) {
          AccessibilityManager.setSimulatedColorBlindnessType(
            context,
            value,
          );
        },
      ),
    );
  }
}
