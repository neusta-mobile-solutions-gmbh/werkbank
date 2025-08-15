import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/constraints/constraints.dart';
import 'package:werkbank/src/environment/environment.dart';

class ViewConstraintsEnforcer extends StatelessWidget {
  const ViewConstraintsEnforcer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final metadata = UseCaseLayoutLayerEntry.access.metadataOf(context);
    final supportedSizes = metadata.supportedSizes;
    final viewSize =
        UseCaseLayoutLayerEntry.access.maybeUseCaseViewportSizeOf(context) ??
        Size.infinite;
    final overviewViewConstraints = switch (UseCaseLayoutLayerEntry.access
        .maybeUseCaseEnvironmentOf(context)) {
      UseCaseEnvironment.regular || null => null,
      UseCaseEnvironment.overview => metadata.overviewViewConstraints,
    };
    return ValueListenableBuilder(
      valueListenable: UseCaseLayoutLayerEntry.access
          .compositionOf(context)
          .constraints
          .viewConstraintsNotifier,
      builder: (context, viewConstraints, _) {
        return ConstrainedBox(
          constraints: (overviewViewConstraints ?? viewConstraints)
              .toBoxConstraints(viewSize: viewSize)
              .enforce(supportedSizes),
          child: child,
        );
      },
    );
  }
}
