import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/werkbank_theme/werkbank_theme.dart';
import 'package:werkbank/src/persistence/persistence.dart';
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
          .setTheme(newThemeName);

  @override
  State<WerkbankThemeManager> createState() => _WerkbankThemeManagerState();
}

class _WerkbankThemeManagerState extends State<WerkbankThemeManager> {
  late WerkbankThemePersistentController _werkbankThemeController;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // TODO(cjaros): wrong layer used
    _werkbankThemeController = ApplicationOverlayLayerEntry.access
        .persistentControllerOf<WerkbankThemePersistentController>(context);
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

class WerkbankThemePersistentController extends GlobalStateController {
  WerkbankThemePersistentController();

  @override
  void tryLoadFromJson(Object? json, {required bool isWarmStart}) {
    if (json is String) {
      themeName = json;
      notifyListeners();
    }
  }

  @override
  Object? toJson() {
    return themeName;
  }

  // TODO: private
  String themeName = WerkbankThemeAddon.systemThemeName;

  void setTheme(String newThemeName) {
    themeName = newThemeName;
    notifyListeners();
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
