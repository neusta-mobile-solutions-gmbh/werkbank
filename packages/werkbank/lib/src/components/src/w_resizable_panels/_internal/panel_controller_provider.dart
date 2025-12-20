import 'package:flutter/material.dart';
import 'package:werkbank/src/components/components.dart';

// TODO: Remove? Do we still need some logic from here?
// class WPanelControllerProvider extends StatefulWidget {
//   const WPanelControllerProvider({
//     required this.child,
//     super.key,
//   });
//
//   final Widget child;
//
//   static WPanelController of(
//     BuildContext context,
//   ) {
//     return context
//         .dependOnInheritedWidgetOfExactType<_InheritedPanelController>()!
//         .controller;
//   }
//
//   @override
//   State<WPanelControllerProvider> createState() =>
//       _WPanelControllerProviderState();
// }
//
// class _WPanelControllerProviderState extends State<WPanelControllerProvider>
//     with TickerProviderStateMixin, PanelCalcMixin {
//   late final WPanelController _panelController;
//   bool _initialized = false;
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (!_initialized) {
//       _initialized = true;
//
//       // Since this is just happening once to initialize the controller
//       // dont want to depend on MediaQuery.of(context) here.
//       // Therefore, we use
//       final size = context
//           .getInheritedWidgetOfExactType<MediaQuery>()!
//           .data
//           .size;
//
//       final initialMaxWidth = maxPanelWidth(size.width);
//       final initialWidth = appropriatePanelWidth(initialMaxWidth);
//
//       _panelController = WPanelController(
//         vsync: this,
//         initiallyVisible: initialVisible(size.width),
//         initialMaxWidth: initialMaxWidth,
//         initialWidth: initialWidth,
//       );
//     }
//   }
//
//   @override
//   void dispose() {
//     _panelController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return _InheritedPanelController(
//       controller: _panelController,
//       child: widget.child,
//     );
//   }
// }

class WPanelControllerProvider extends InheritedWidget {
  const WPanelControllerProvider({
    super.key,
    required this.controller,
    required super.child,
  });

  static WPanelController of(
    BuildContext context,
  ) {
    return context
        .dependOnInheritedWidgetOfExactType<WPanelControllerProvider>()!
        .controller;
  }

  final WPanelController controller;

  @override
  bool updateShouldNotify(WPanelControllerProvider oldWidget) {
    return controller != oldWidget.controller;
  }
}
