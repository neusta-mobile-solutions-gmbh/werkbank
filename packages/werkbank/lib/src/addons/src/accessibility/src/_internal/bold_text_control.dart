import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addons/src/accessibility/src/accessibility_manager.dart';
import 'package:werkbank/src/components/components.dart';

class BoldTextControl extends StatelessWidget {
  const BoldTextControl({super.key});

  @override
  Widget build(BuildContext context) {
    return WControlItem(
      title: Text(context.sL10n.addons.accessibility.controls.boldText),
      control: WSwitch(
        value: AccessibilityManager.boldTextOf(context),
        onChanged: (value) {
          AccessibilityManager.setBoldText(context, boldText: value);
        },
        falseLabel: Text(context.sL10n.generic.yesNoSwitch.no),
        trueLabel: Text(context.sL10n.generic.yesNoSwitch.yes),
      ),
    );
  }
}
