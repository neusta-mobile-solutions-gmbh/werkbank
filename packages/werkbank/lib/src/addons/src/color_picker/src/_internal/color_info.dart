import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/color_picker/src/_internal/color_picker_manager.dart';

class ColorInfo extends StatelessWidget {
  const ColorInfo({
    super.key,
  });

  TextSpan _buildColorTextSpan(Color? color, BuildContext context) {
    final sl10n = context.sL10n.addons.colorPicker.controls.colorPicker.values;
    final textStyle = context.werkbankTextTheme.input;
    if (color == null) {
      return TextSpan(text: sl10n.noSelectedColor);
    }
    return TextSpan(
      style: textStyle,
      children: [
        TextSpan(
          text: 'alpha: ${color.a.toStringAsFixed(4)}\n',
        ),
        TextSpan(
          text: 'red: ${color.r.toStringAsFixed(4)}\n',
          style: const TextStyle(color: Colors.red),
        ),
        TextSpan(
          text: 'green: ${color.g.toStringAsFixed(4)}\n',
          style: const TextStyle(color: Colors.green),
        ),
        TextSpan(
          text: 'blue: ${color.b.toStringAsFixed(4)}\n',
          style: const TextStyle(color: Colors.blue),
        ),
        TextSpan(
          text: 'colorSpace: ${color.colorSpace.name}',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final color = ColorPickerManager.colorOf(context);
    return WTextArea.textSpan(
      textSpan: _buildColorTextSpan(color, context),
    );
  }
}
