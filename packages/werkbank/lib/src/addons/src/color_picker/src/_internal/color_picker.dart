import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/color_picker/src/_internal/color_hexcode.dart';
import 'package:werkbank/src/addons/src/color_picker/src/_internal/color_info.dart';
import 'package:werkbank/src/addons/src/color_picker/src/_internal/color_picker_manager.dart';
import 'package:werkbank/werkbank.dart';

class ColorPicker extends StatelessWidget {
  const ColorPicker({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.werkbankColorScheme;
    final color = ColorPickerManager.colorOf(context);
    final colorInfo = color != null ? const ColorInfo() : null;
    return Column(
      spacing: 4,
      children: [
        Row(
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
            const SizedBox(width: 4),
            const Flexible(
              child: ColorHexcode(),
            ),
            const SizedBox(
              width: 4,
            ),
            WBorderedBox(
              borderRadius: BorderRadius.circular(4),
              backgroundColor: colorScheme.backgroundActive,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: DecoratedBox(
                  position: DecorationPosition.foreground,
                  decoration: BoxDecoration(
                    color: color,
                  ),
                  child: const SizedBox(
                    width: 44,
                    height: 44,
                    child: WCheckerboardBackground(),
                  ),
                ),
              ),
            ),
          ],
        ),
        ?colorInfo,
      ],
    );
  }
}
