import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/color_picker/src/_internal/color_picker_mouse_handler.dart';
import 'package:werkbank/src/addons/src/color_picker/src/_internal/custom_repaint_boundary.dart';

class ColorPickerSection extends StatelessWidget {
  const ColorPickerSection({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return CustomRepaintBoundary(
      key: PickerKeyProvider.of(context),
      child: child,
    );
  }
}
