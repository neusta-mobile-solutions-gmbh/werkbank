import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

class ThemingManager extends StatefulWidget {
  const ThemingManager({
    super.key,
    required this.themeOptions,
    required this.child,
  });

  final List<ThemeOption> themeOptions;

  static ThemeOption? selectedThemeOptionOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_ThemingState>()!
        .selectedOption;
  }

  static void setSelectedThemeName(
    BuildContext context,
    String selectedThemeName,
  ) {
    context
        .findAncestorStateOfType<_ThemingManagerState>()!
        .setSelectedThemeName(selectedThemeName);
  }

  final Widget child;

  @override
  State<ThemingManager> createState() => _ThemingManagerState();
}

class _ThemingManagerState extends State<ThemingManager> {
  late String? _selectedThemeOptionName;

  late Map<String, ThemeOption> _themeOptionsByName;

  void _updateThemeOptionsByName() {
    _themeOptionsByName = {
      for (final themeOption in widget.themeOptions)
        themeOption.name: themeOption,
    };
  }

  @override
  void initState() {
    super.initState();
    _updateThemeOptionsByName();
    _selectedThemeOptionName = widget.themeOptions.firstOrNull?.name;
  }

  @override
  void didUpdateWidget(covariant ThemingManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.themeOptions != oldWidget.themeOptions) {
      _updateThemeOptionsByName();
      if (_selectedThemeOptionName != null) {
        // We call this method to ensure that the selected theme option
        // is still valid after the theme options have been updated.
        setSelectedThemeName(
          _selectedThemeOptionName!,
        );
      }
    }
  }

  void setSelectedThemeName(String themeName) {
    setState(() {
      if (!_themeOptionsByName.containsKey(themeName)) {
        _selectedThemeOptionName = widget.themeOptions.firstOrNull?.name;
      } else {
        _selectedThemeOptionName = themeName;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _ThemingState(
      selectedOption: _themeOptionsByName[_selectedThemeOptionName],
      child: widget.child,
    );
  }
}

class _ThemingState extends InheritedWidget {
  const _ThemingState({
    required this.selectedOption,
    required super.child,
  });

  final ThemeOption? selectedOption;

  @override
  bool updateShouldNotify(_ThemingState oldWidget) {
    return selectedOption != oldWidget.selectedOption;
  }
}
