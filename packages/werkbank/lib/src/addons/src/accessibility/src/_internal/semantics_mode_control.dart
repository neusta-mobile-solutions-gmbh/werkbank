import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addons/src/accessibility/accessibility.dart';
import 'package:werkbank/src/components/components.dart';

class SemanticsModeControl extends StatelessWidget {
  const SemanticsModeControl({super.key});

  static final List<SemanticsMode> _options = [
    SemanticsMode.none,
    SemanticsMode.overlay,
    SemanticsMode.inspection,
    SemanticsMode.sideBySide,
  ];

  @override
  Widget build(BuildContext context) {
    final mode = AccessibilityManager.semanticsModeOf(context);
    return WControlItem(
      title: Text(
        context.sL10n.addons.accessibility.controls.semanticsMode.name,
      ),
      control: WDropdown<SemanticsMode>(
        // This is necessary for the DropdownMenuItem to have
        // the right width-constraints.
        value: mode,
        onChanged: (value) {
          AccessibilityManager.setSemanticsMode(
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
                  SemanticsMode.none =>
                    context
                        .sL10n
                        .addons
                        .accessibility
                        .controls
                        .semanticsMode
                        .values
                        .none,
                  SemanticsMode.overlay =>
                    context
                        .sL10n
                        .addons
                        .accessibility
                        .controls
                        .semanticsMode
                        .values
                        .overlay,
                  SemanticsMode.inspection =>
                    context
                        .sL10n
                        .addons
                        .accessibility
                        .controls
                        .semanticsMode
                        .values
                        .inspection,
                  SemanticsMode.sideBySide =>
                    context
                        .sL10n
                        .addons
                        .accessibility
                        .controls
                        .semanticsMode
                        .values
                        .sideBySide,
                },
              ),
            ),
        ],
      ),
    );
  }
}
