import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/background/background.dart';

class BackgroundManager extends StatefulWidget {
  const BackgroundManager({
    super.key,
    required this.backgroundOptions,
    required this.initialBackgroundOptionName,
    required this.child,
  });

  static Map<String, BackgroundOption> backgroundOptionsByNameOf(
    BuildContext context,
  ) {
    return context
        .dependOnInheritedWidgetOfExactType<_BackgroundOptionsProvider>()!
        .backgroundOptionsByName;
  }

  static BackgroundOption? backgroundOptionOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_BackgroundState>()
        ?.backgroundOption;
  }

  static void setBackgroundOptionNameOf(
    BuildContext context,
    String? backgroundOptionName,
  ) {
    final manager = context.findAncestorStateOfType<_BackgroundManagerState>();
    manager?.setSelectedBackgroundOptionName(backgroundOptionName);
  }

  final List<BackgroundOption> backgroundOptions;
  final String? initialBackgroundOptionName;
  final Widget child;

  @override
  State<BackgroundManager> createState() => _BackgroundManagerState();
}

class _BackgroundManagerState extends State<BackgroundManager> {
  late String? _selectedBackgroundOptionName;

  late Map<String, BackgroundOption> _backgroundOptionsByName;

  void _updateBackgroundOptionsByName() {
    _backgroundOptionsByName = {
      for (final themeOption in widget.backgroundOptions)
        themeOption.name: themeOption,
    };
  }

  @override
  void initState() {
    super.initState();
    _updateBackgroundOptionsByName();
    setSelectedBackgroundOptionName(
      widget.initialBackgroundOptionName,
    );
  }

  @override
  void didUpdateWidget(covariant BackgroundManager oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.backgroundOptions != oldWidget.backgroundOptions) {
      _updateBackgroundOptionsByName();
      // We call this method to ensure that the selected background option
      // is still valid after the background options have been updated.
      setSelectedBackgroundOptionName(
        _selectedBackgroundOptionName,
      );
    }
  }

  void setSelectedBackgroundOptionName(String? backgroundOptionName) {
    setState(() {
      if (backgroundOptionName != null &&
          !_backgroundOptionsByName.containsKey(backgroundOptionName)) {
        _selectedBackgroundOptionName = null;
      } else {
        _selectedBackgroundOptionName = backgroundOptionName;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _BackgroundOptionsProvider(
      backgroundOptionsByName: _backgroundOptionsByName,
      child: _BackgroundState(
        backgroundOption:
            _backgroundOptionsByName[_selectedBackgroundOptionName],
        child: widget.child,
      ),
    );
  }
}

class _BackgroundState extends InheritedWidget {
  const _BackgroundState({
    required this.backgroundOption,
    required super.child,
  });

  final BackgroundOption? backgroundOption;

  @override
  bool updateShouldNotify(_BackgroundState oldWidget) {
    return backgroundOption != oldWidget.backgroundOption;
  }
}

class _BackgroundOptionsProvider extends InheritedWidget {
  const _BackgroundOptionsProvider({
    required this.backgroundOptionsByName,
    required super.child,
  });

  final Map<String, BackgroundOption> backgroundOptionsByName;

  @override
  bool updateShouldNotify(_BackgroundOptionsProvider oldWidget) {
    return backgroundOptionsByName != oldWidget.backgroundOptionsByName;
  }
}
