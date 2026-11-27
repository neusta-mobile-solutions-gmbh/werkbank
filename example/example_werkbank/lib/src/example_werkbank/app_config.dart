import 'dart:ui';

import 'package:material_ui/material_ui.dart';
import 'package:werkbank/werkbank.dart';

AppConfig get appConfig => AppConfig.material(
  additionalBuilder: (context, child) {
    final scrollBehavior = ScrollConfiguration.of(context);
    return ScrollConfiguration(
      behavior: scrollBehavior.copyWith(
        dragDevices: {
          ...scrollBehavior.dragDevices,
          // Enable drag scrolling with mouse.
          PointerDeviceKind.mouse,
        },
      ),
      // Some of the material widgets we are using require a Material widget
      // as ancestor.
      child: Material(
        type: MaterialType.transparency,
        child: child,
      ),
    );
  },
);
