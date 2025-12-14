import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/theming/theming.dart';

class ThemeOptionApplier extends StatefulWidget {
  const ThemeOptionApplier({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<ThemeOptionApplier> createState() => _ThemeOptionApplierState();
}

class _ThemeOptionApplierState extends State<ThemeOptionApplier> {
  final _childKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final themeController = AffiliationTransitionLayerEntry.access
        .maybeGlobalStateControllerOf<ThemeController>(
          context,
        )!;
    return ListenableBuilder(
      listenable: themeController,
      builder: (context, _) {
        final themeOption = themeController.selectedThemeOption;
        Widget result = KeyedSubtree(
          key: _childKey,
          child: widget.child,
        );
        if (themeOption != null) {
          final wrapperBuilder = themeOption.wrapperBuilder;

          if (wrapperBuilder != null) {
            result = wrapperBuilder(context, result);
          }
        }
        return result;
      },
    );
  }
}
