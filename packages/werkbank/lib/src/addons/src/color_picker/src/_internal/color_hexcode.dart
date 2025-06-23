import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:werkbank/src/addons/src/color_picker/src/_internal/color_picker_manager.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class ColorHexcode extends StatelessWidget {
  const ColorHexcode({
    super.key,
  });

  String _buildHexString(Color color) {
    return color.toARGB32().toRadixString(16).padLeft(8, '0');
  }

  TextSpan _buildColorTextSpan(Color? color, BuildContext context) {
    final sl10n = context.sL10n.addons.colorPicker.controls.colorPicker.values;
    final textStyle = context.werkbankTextTheme.input;
    if (color == null) {
      return TextSpan(text: sl10n.noSelectedColor);
    }
    final hexString = _buildHexString(color);
    return TextSpan(
      style: textStyle,
      children: [
        const TextSpan(text: '#'),
        TextSpan(text: hexString.substring(0, 2)),
        TextSpan(
          text: hexString.substring(2, 4),
          style: const TextStyle(color: Colors.red),
        ),
        TextSpan(
          text: hexString.substring(4, 6),
          style: const TextStyle(color: Colors.green),
        ),
        TextSpan(
          text: hexString.substring(6, 8),
          style: const TextStyle(color: Colors.blue),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = ColorPickerManager.colorOf(context);
    return WTextArea.textSpan(
      textSpan: _buildColorTextSpan(color, context),
      contentPadding: const EdgeInsets.only(left: 12),
      trailing: color != null
          ? WIconButton(
              onPressed: () {
                Clipboard.setData(
                  ClipboardData(text: _buildHexString(color)),
                );
                ColorPickerManager.setEnabled(context, enabled: false);
                WerkbankNotifications.dispatch(
                  context,
                  WerkbankNotification.text(
                    title: context
                        .sL10n
                        .addons
                        .colorPicker
                        .controls
                        .colorPicker
                        .values
                        .colorCopied,
                  ),
                );
              },
              icon: const Icon(Icons.copy),
            )
          : const SizedBox(
              height: 48,
            ),
    );
  }
}
