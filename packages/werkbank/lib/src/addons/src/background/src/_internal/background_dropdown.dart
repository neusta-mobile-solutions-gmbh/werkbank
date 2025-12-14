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
        .globalStateControllerOf<BackgroundController>(
          context,
        );
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
                  /* TODO(lzuttermeister): This currently has to be disabled,
                       because the color preview does not work in the dropdown
                       overlay since it doesn't have access to the right context.
                       We need our own Dropdown implementation using portals. */
                  // child: Row(
                  //   mainAxisSize: MainAxisSize.min,
                  //   children: [
                  //     Padding(
                  //       padding: const EdgeInsets.only(right: 4),
                  //       child: Text(backgroundOption.name),
                  //     ),
                  //     SizedBox(
                  //       width: 16,
                  //       height: 16,
                  //       child: ClipOval(child: backgroundOption.backgroundWidget),
                  //     ),
                  //   ],
                  // ),
                ),
            ],
          );
        },
      ),
    );
  }
}
