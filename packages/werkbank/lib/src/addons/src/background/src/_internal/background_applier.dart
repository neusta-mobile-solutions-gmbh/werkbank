import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/background/src/background_manager.dart';
import 'package:werkbank/src/addons/src/background/src/background_metadata.dart';

class BackgroundApplier extends StatelessWidget {
  const BackgroundApplier({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final backgroundOptionsByName = BackgroundManager.backgroundOptionsByNameOf(
      context,
    );
    final selectedBackgroundOption = BackgroundManager.backgroundOptionOf(
      context,
    );
    final metadata = UseCaseLayerEntry.access.metadataOf(context);
    final Widget? backgroundBox;
    if (selectedBackgroundOption != null) {
      backgroundBox = selectedBackgroundOption.backgroundBox;
    } else {
      switch (metadata.backgroundOption) {
        case null:
          backgroundBox = null;
        case NamedBackgroundOption(:final name):
          backgroundBox = backgroundOptionsByName[name]?.backgroundBox;
        case CustomBackgroundOption(backgroundBox: final useCaseBackgroundBox):
          backgroundBox = useCaseBackgroundBox;
      }
    }
    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (backgroundBox != null)
          Positioned.fill(
            child: backgroundBox,
          ),
        KeyedSubtree(
          key: const Key('child'),
          child: child,
        ),
      ],
    );
  }
}
