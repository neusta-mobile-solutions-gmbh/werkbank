import 'package:flutter/material.dart';
import 'package:werkbank/werkbank_old.dart';

class PanelControllerProvider extends StatefulWidget {
  const PanelControllerProvider({
    required this.child,
    super.key,
  });

  final Widget child;

  static PanelController of(
    BuildContext context,
  ) {
    return context
        .dependOnInheritedWidgetOfExactType<
          _InheritedPanelVisibilityController
        >()!
        .controller;
  }

  @override
  State<PanelControllerProvider> createState() =>
      _PanelControllerProviderState();
}

class _PanelControllerProviderState extends State<PanelControllerProvider>
    with TickerProviderStateMixin, PanelCalcMixin {
  late final PanelController _panelController;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;

      // Since this is just happening once to initialize the controller
      // dont want to depend on MediaQuery.of(context) here.
      // Therefore, we use
      final size = context
          .getInheritedWidgetOfExactType<MediaQuery>()!
          .data
          .size;

      final initialMaxWidth = maxPanelWidth(size.width);
      final initialWidth = appropriatePanelWidth(initialMaxWidth);

      _panelController = PanelController(
        vsync: this,
        initiallyVisible: initialVisible(size.width),
        initialMaxWidth: initialMaxWidth,
        initialWidth: initialWidth,
      );
    }
  }

  @override
  void dispose() {
    _panelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedPanelVisibilityController(
      controller: _panelController,
      child: widget.child,
    );
  }
}

class _InheritedPanelVisibilityController extends InheritedWidget {
  const _InheritedPanelVisibilityController({
    required this.controller,
    required super.child,
  });

  final PanelController controller;

  @override
  bool updateShouldNotify(_InheritedPanelVisibilityController oldWidget) {
    return controller != oldWidget.controller;
  }
}
