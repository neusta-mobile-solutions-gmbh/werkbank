import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/background/background.dart';
import 'package:werkbank/src/components/components.dart';

class BackgroundDropdown extends StatelessWidget {
  const BackgroundDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundController = SettingsControlSection.access
        .globalStateOf(context)
        .background;
    return WControlItem(
      title: Text(context.sL10n.addons.background.controls.background.label),
      control: ListenableBuilder(
        listenable: backgroundController,
        builder: (context, _) {
          final selectedBackgroundOptionName =
              backgroundController.selectedBackgroundOptionName;
          return WDropdown<String?>(
            value: selectedBackgroundOptionName,
            onChanged: (value) {
              backgroundController.selectedBackgroundOptionName = value;
            },
            items: [
              WDropdownMenuItem(
                value: null,
                child: Text(
                  context
                      .sL10n
                      .addons
                      .background
                      .controls
                      .background
                      .values
                      .useCaseDefault,
                ),
              ),
              // TODO(lzuttermeister): Should we sort the options somehow?
              for (final backgroundOption
                  in backgroundController.availableBackgroundOptions)
                WDropdownMenuItem(
                  value: backgroundOption.name,
                  child: Text(backgroundOption.name),
                ),
            ],
          );
        },
      ),
    );
  }
}
