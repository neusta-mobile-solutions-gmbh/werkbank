import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/color_picker/src/_internal/color_picker_manager.dart';
import 'package:werkbank/src/addons/src/color_picker/src/_internal/color_picker_utils.dart';

class ColorPickerMouseHandler extends StatefulWidget {
  const ColorPickerMouseHandler({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ColorPickerMouseHandler> createState() =>
      _ColorPickerMouseHandlerState();
}

class _ColorPickerMouseHandlerState extends State<ColorPickerMouseHandler> {
  ColorPickerUtils? colorPicker;
  final GlobalKey _mouseRegionKey = GlobalKey();
  final GlobalKey _pickerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    colorPicker = ColorPickerUtils(
      boundaryKey: _pickerKey,
    );
    // This is necessary to to keep the cursor appearance after navigating
    // through use cases
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {});
      }
    });
  }

  Offset localCursorPosition = Offset.zero;

  @override
  Widget build(BuildContext context) {
    final isActive = ColorPickerManager.enabledOf(context);
    final VoidCallback? clickAction = isActive
        ? () async {
            final mouseRenderBox =
                _mouseRegionKey.currentContext!.findRenderObject()!
                    as RenderBox;

            final newColor = await colorPicker?.getColor(
              mouseRenderBox,
              localCursorPosition,
            );
            if (context.mounted) {
              ColorPickerManager.setColor(context, color: newColor);
            }
          }
        : null;
    return Stack(
      children: [
        PickerKeyProvider(pickerKey: _pickerKey, child: widget.child),
        if (isActive)
          MouseRegion(
            key: _mouseRegionKey,
            onHover: (event) => localCursorPosition = event.localPosition,
            cursor: isActive ? SystemMouseCursors.precise : MouseCursor.defer,
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: clickAction,
              onPanStart: (details) {
                localCursorPosition = details.localPosition;
                clickAction?.call();
              },
              onPanUpdate: (details) {
                localCursorPosition = details.localPosition;
                clickAction?.call();
              },
            ),
          ),
      ],
    );
  }
}

class PickerKeyProvider extends InheritedWidget {
  const PickerKeyProvider({
    super.key,
    required this.pickerKey,
    required super.child,
  });

  static GlobalKey of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<PickerKeyProvider>();
    assert(result != null, 'No PickerKeyPorvider found in context');
    return result!.pickerKey;
  }

  final GlobalKey pickerKey;

  @override
  bool updateShouldNotify(PickerKeyProvider oldWidget) {
    return pickerKey != oldWidget.pickerKey;
  }
}
