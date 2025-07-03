import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

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
    return ListenableBuilder(
      listenable: _werkbankThemeController,
      builder: (context, child) {
        final themeName = _werkbankThemeController.themeName;
        return _InheritedWerkbankThemeState(
          themeName: themeName,
          child: WerkbankSettings(
            orderOption: WerkbankSettings.orderOptionOf(context),
            werkbankTheme: switch (themeName) {
              'Werkbank Dark' => WerkbankTheme(
                colorScheme: WerkbankColorScheme.fromPalette(
                  const WerkbankPalette.dark(),
                ),
                textTheme: WerkbankTextTheme.standard(),
              ),
              'Werkbank Light' || _ => WerkbankTheme(
                colorScheme: WerkbankColorScheme.fromPalette(
                  const WerkbankPalette.light(),
                ),
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

class WerkbankThemePersistentController
    extends PersistentController<WerkbankThemePersistentController> {
  WerkbankThemePersistentController() : super(id: 'werkbank_theme');

  @override
  void tryLoadFromJson(Object? json) {
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
  String themeName = 'Werkbank Light';

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
