import 'dart:math';

import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addons/src/accessibility/accessibility.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/theme/theme.dart';

class TextScaleFactorControl extends StatelessWidget {
  const TextScaleFactorControl({super.key});

  double _textScaleFactorToValue(double textScaleFactor) =>
      log(textScaleFactor) / ln10;

  double _valueToTextScaleFactor(double value) => pow(10, value).toDouble();

  @override
  Widget build(BuildContext context) {
    return WControlItem(
      title: Text(context.sL10n.addons.accessibility.controls.textScaleFactor),
      control: Row(
        children: [
          WIconButton(
            onPressed: () {
              AccessibilityManager.setTextScaleFactor(
                context,
                textScaleFactor: 1,
              );
            },
            icon: const Icon(
              WerkbankIcons.x,
            ),
          ),
          const SizedBox(width: 2),
          Expanded(
            child: WSlider(
              value: _textScaleFactorToValue(
                AccessibilityManager.textScaleFactorOf(context),
              ),
              onChanged: (value) {
                AccessibilityManager.setTextScaleFactor(
                  context,
                  textScaleFactor: _valueToTextScaleFactor(value),
                );
              },
              valueFormatter: (value) {
                final textScaleFactor = _valueToTextScaleFactor(value);
                return '× ${textScaleFactor.toStringAsFixed(2)}';
              },
              min: -1,
            ),
          ),
        ],
      ),
    );
  }
}
