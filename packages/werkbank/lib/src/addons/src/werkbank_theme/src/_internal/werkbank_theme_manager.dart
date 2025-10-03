import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/werkbank_theme/werkbank_theme.dart';
import 'package:werkbank/src/global_state/global_state.dart';
import 'package:werkbank/src/theme/theme.dart';
import 'package:werkbank/src/widgets/widgets.dart';

class WerkbankThemeManager extends StatefulWidget {
  const WerkbankThemeManager({
    super.key,
    required this.child,
  });

  final Widget child;

  static String themeNameOf(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<_InheritedWerkbankThemeState>()!
      .themeName;

  static void setThemeNameOf(BuildContext context, String newThemeName) =>
      context
              .findAncestorStateOfType<_WerkbankThemeManagerState>()!
              ._werkbankThemeController
              .themeName =
          newThemeName;

  @override
  State<WerkbankThemeManager> createState() => _WerkbankThemeManagerState();
}

class _WerkbankThemeManagerState extends State<WerkbankThemeManager> {
  late WerkbankThemeController _werkbankThemeController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // TODO(cjaros): wrong layer used
    _werkbankThemeController = ApplicationOverlayLayerEntry.access
        .persistentControllerOf<WerkbankThemeController>(context);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.platformBrightnessOf(context);

    return ListenableBuilder(
      listenable: _werkbankThemeController,
      builder: (context, child) {
        final darkColorScheme = WerkbankColorScheme.fromPalette(
          const WerkbankPalette.dark(),
        );

        final lightColorScheme = WerkbankColorScheme.fromPalette(
          const WerkbankPalette.light(),
        );

        final themeName = _werkbankThemeController.themeName;
        return _InheritedWerkbankThemeState(
          themeName: themeName,
          child: WerkbankSettings(
            orderOption: WerkbankSettings.orderOptionOf(context),
            werkbankTheme: switch (themeName) {
              WerkbankThemeAddon.darkThemeName => WerkbankTheme(
                colorScheme: darkColorScheme,
                textTheme: WerkbankTextTheme.standard(),
              ),
              WerkbankThemeAddon.lightThemeName => WerkbankTheme(
                colorScheme: lightColorScheme,
                textTheme: WerkbankTextTheme.standard(),
              ),
              WerkbankThemeAddon.systemThemeName || _ => WerkbankTheme(
                colorScheme: switch (brightness) {
                  Brightness.dark => darkColorScheme,
                  Brightness.light => lightColorScheme,
                },
                textTheme: WerkbankTextTheme.standard(),
              ),
            },
            child: widget.child,
          ),
        );
      },
    );
  }
}

// TODO: Move out of internal
class WerkbankThemeController extends GlobalStateController {
  WerkbankThemeController();

  String _themeName = WerkbankThemeAddon.systemThemeName;

  String get themeName => _themeName;

  set themeName(String newThemeName) {
    if (_themeName != newThemeName) {
      _themeName = newThemeName;
      notifyListeners();
    }
  }

  @override
  void tryLoadFromJson(Object? json, {required bool isWarmStart}) {
    if (json is String) {
      themeName = json;
    }
  }

  @override
  Object? toJson() {
    return themeName;
  }
}

class _InheritedWerkbankThemeState extends InheritedWidget {
  const _InheritedWerkbankThemeState({
    required this.themeName,
    required super.child,
  });

  final String themeName;

  @override
  bool updateShouldNotify(_InheritedWerkbankThemeState oldWidget) {
    return themeName != oldWidget.themeName;
  }
}
