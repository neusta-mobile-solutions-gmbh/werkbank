import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addons/src/color_picker/src/_internal/color_picker_manager.dart';
import 'package:werkbank/src/components/components.dart';

class ColorPickerButton extends StatelessWidget {
  const ColorPickerButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return WControlItem(
      title: Text(
        context
            .sL10n
            .addons
            .colorPicker
            .controls
            .colorPicker
            .values
            .pickedColor,
      ),
      layout: ControlItemLayout.spacious,
      control: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WIconButton(
            isActive: ColorPickerManager.enabledOf(context),
            onPressed: () {
              ColorPickerManager.setEnabled(
                context,
                enabled: !ColorPickerManager.enabledOf(
                  context,
                ),
              );
            },
            icon: const Icon(Icons.colorize_outlined),
          ),
        ],
      ),
    );
  }
}
