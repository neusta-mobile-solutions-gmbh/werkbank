import 'package:flutter/material.dart';

class UseCaseLayout extends StatelessWidget {
  const UseCaseLayout({
    super.key,
    this.viewportPadding = EdgeInsets.zero,
    required this.child,
  });

  final EdgeInsets viewportPadding;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final environment = WerkbankEnvironmentProvider.of(context);
    Widget result = AddonLayerBuilder(
      layer: AddonLayer.useCaseLayout,
      child: child,
    );
    switch (environment) {
      case WerkbankEnvironment.app:
        result = UseCaseViewport(
          sizePadding: viewportPadding,
          child: result,
        );
      case WerkbankEnvironment.display:
        break;
    }
    return result;
  }
}
