import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart' show SchedulerBinding;
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

class _WerkbankThemeManagerState extends State<WerkbankThemeManager>
    with WidgetsBindingObserver {
  late WerkbankThemePersistentController _werkbankThemeController;

  late Brightness brightness;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _updateDarkMode();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // TODO(cjaros): wrong layer used
    _werkbankThemeController = ApplicationOverlayLayerEntry.access
        .persistentControllerOf<WerkbankThemePersistentController>(context);
  }

  @override
  void didChangePlatformBrightness() {
    setState(_updateDarkMode);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }

  void _updateDarkMode() {
    brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
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
              'Werkbank Light' => WerkbankTheme(
                colorScheme: WerkbankColorScheme.fromPalette(
                  const WerkbankPalette.light(),
                ),
                textTheme: WerkbankTextTheme.standard(),
              ),
              'Werkbank System' || _ => WerkbankTheme(
                colorScheme: WerkbankColorScheme.fromPalette(
                  brightness == Brightness.dark
                      ? const WerkbankPalette.dark()
                      : const WerkbankPalette.light(),
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

class WerkbankThemePersistentController extends PersistentController {
  WerkbankThemePersistentController({
    required super.prefsWithCache,
  });

  @override
  String get id => 'werkbank_theme';

  @override
  void init(String? unsafeJson) {
    themeName = unsafeJson ?? 'Werkbank Light';
  }

  late String themeName;

  void setTheme(String newThemeName) {
    themeName = newThemeName;
    setJson(themeName);
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
