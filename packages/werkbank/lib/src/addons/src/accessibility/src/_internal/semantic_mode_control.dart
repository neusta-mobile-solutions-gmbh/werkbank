import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addons/src/accessibility/src/accessibility_manager.dart';
import 'package:werkbank/src/components/components.dart';

class SemanticModeControl extends StatelessWidget {
  const SemanticModeControl({super.key});

  static final List<SemanticMode> _options = [
    SemanticMode.none,
    SemanticMode.overlay,
    SemanticMode.inspection,
  ];

  @override
  Widget build(BuildContext context) {
    final mode = AccessibilityManager.semanticModeOf(context);
    return WControlItem(
      title: Text(
        context.sL10n.addons.accessibility.controls.semanticsMode.name,
      ),
      control: WDropdown<SemanticMode>(
        // This is necessary for the DropdownMenuItem to have
        // the right width-constraints.
        value: mode,
        onChanged: (value) {
          AccessibilityManager.setSemanticMode(
            context,
            value,
          );
        },
        items: [
          for (final mode in _options)
            WDropdownMenuItem(
              value: mode,
              child: Text(
                switch (mode) {
                  SemanticMode.none =>
                    context
                        .sL10n
                        .addons
                        .accessibility
                        .controls
                        .semanticsMode
                        .values
                        .none,
                  SemanticMode.overlay =>
                    context
                        .sL10n
                        .addons
                        .accessibility
                        .controls
                        .semanticsMode
                        .values
                        .overlay,
                  SemanticMode.inspection =>
                    context
                        .sL10n
                        .addons
                        .accessibility
                        .controls
                        .semanticsMode
                        .values
                        .inspection,
                },
              ),
            ),
        ],
      ),
    );
  }
}
