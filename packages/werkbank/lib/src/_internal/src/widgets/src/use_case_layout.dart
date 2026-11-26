import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/environment/environment.dart';
import 'package:werkbank/src/utils/utils.dart';

class UseCaseLayout extends StatelessWidget {
  const UseCaseLayout({
    super.key,
    this.viewportPadding = EdgeInsets.zero,
    this.additionalLayoutBuilder,
    required this.child,
  });

  final EdgeInsets viewportPadding;
  final WrapperBuilder? additionalLayoutBuilder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final environment = WerkbankEnvironmentProvider.of(context);
    Widget result = AddonLayerBuilder(
      layer: AddonLayer.useCaseLayout,
      child: child,
    );
    final additionalLayoutBuilder = this.additionalLayoutBuilder;
    if (additionalLayoutBuilder != null) {
      final child = result;
      result = Builder(
        builder: (context) => additionalLayoutBuilder(context, child),
      );
    }
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
