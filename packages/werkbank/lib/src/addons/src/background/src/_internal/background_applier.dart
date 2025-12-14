import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/background/background.dart';

class BackgroundApplier extends StatelessWidget {
  const BackgroundApplier({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final backgroundController = UseCaseLayerEntry.access
        .maybeGlobalStateControllerOf<BackgroundController>(
          context,
        )!;
    return ListenableBuilder(
      listenable: backgroundController,
      builder: (context, _) {
        final metadata = UseCaseLayerEntry.access.metadataOf(context);
        final Widget? backgroundWidget;
        final selectedBackgroundOption =
            backgroundController.selectedBackgroundOption;
        if (selectedBackgroundOption != null) {
          backgroundWidget = selectedBackgroundOption.backgroundWidget;
        } else {
          switch (metadata.backgroundOption) {
            case null:
              backgroundWidget = null;
            case NamedBackgroundOption(:final name):
              backgroundWidget = backgroundController
                  .backgroundOptionByName(name)
                  ?.backgroundWidget;
            case CustomBackgroundOption(
              backgroundWidget: final useCaseBackgroundWidget,
            ):
              backgroundWidget = useCaseBackgroundWidget;
          }
        }
        return Stack(
          fit: StackFit.passthrough,
          children: [
            if (backgroundWidget != null)
              Positioned.fill(
                child: ExcludeSemantics(
                  child: backgroundWidget,
                ),
              ),
            KeyedSubtree(
              key: const Key('child'),
              child: child,
            ),
          ],
        );
      },
    );
  }
}
