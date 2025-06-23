import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/werkbank.dart';

class BackgroundDropdown extends StatelessWidget {
  const BackgroundDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    final backgroundOptions = BackgroundManager.backgroundOptionsByNameOf(
      context,
    ).values;
    final selectedBackgroundOption = BackgroundManager.backgroundOptionOf(
      context,
    );
    return WControlItem(
      title: Text(context.sL10n.addons.background.controls.background.label),
      control: WDropdown<String?>(
        value: selectedBackgroundOption?.name,
        onChanged: (value) {
          BackgroundManager.setBackgroundOptionNameOf(
            context,
            value,
          );
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
          for (final backgroundOption in backgroundOptions)
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
              //       child: Text(themeOption.name),
              //     ),
              //     SizedBox(
              //       width: 16,
              //       height: 16,
              //       child: ClipOval(child: themeOption.backgroundBox),
              //     ),
              //   ],
              // ),
            ),
        ],
      ),
    );
  }
}
