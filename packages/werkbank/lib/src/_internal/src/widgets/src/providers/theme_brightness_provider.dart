import 'package:flutter/material.dart';

class ThemeBrightnessProvider extends InheritedWidget {
  const ThemeBrightnessProvider({
    super.key,
    required this.themeBrightness,
    required super.child,
  });

  static Brightness of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<ThemeBrightnessProvider>();
    assert(result != null, 'No ThemeBrightnessProvider found in context');
    return result!.themeBrightness;
  }

  final Brightness themeBrightness;

  @override
  bool updateShouldNotify(ThemeBrightnessProvider old) {
    return themeBrightness != old.themeBrightness;
  }
}
