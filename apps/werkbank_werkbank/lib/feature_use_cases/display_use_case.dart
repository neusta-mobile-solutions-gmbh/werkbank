import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/main.dart';
import 'package:werkbank_werkbank/root.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder displayUseCase(UseCaseComposer c) {
  c
    ..description(
      'A use case to show off the `DisplayApp` and `UseCaseDisplay` which '
      'inserts a use cases in isolation without any '
      'werkbank user interface. '
      'This can be used for a11y tests and golden tests.',
    )
    ..tags([Tags.feature]);
  c.overview.withoutThumbnail();

  return (context) {
    final rootDescriptor = RootDescriptor.fromWerkbankRoot(
      WerkbankRoot(
        children: root.children,
        builder: (c) {
          root.builder?.call(c);
          c.addLateExecutionCallback(() {
            c.background.named('None');
          });
        },
      ),
    );
    final useCases = [
      for (final useCase in rootDescriptor.useCases)
        if (useCase.node.builder != displayUseCase) useCase,
    ];
    return DisplayApp(
      appConfig: AppConfig.material(),
      addonConfig: addons,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final useCase in useCases)
              for (final config in _configsForUseCase(useCase))
                ConstrainedBox(
                  constraints: BoxConstraints.loose(config.maxSize),
                  child: UseCaseDisplay(
                    useCase: useCase,
                    initialMutation: config.startBuildSetup,
                  ),
                ),
          ],
        ),
      ),
    );
  };
}

class _UseCaseConfig {
  const _UseCaseConfig({
    required this.maxSize,
    this.startBuildSetup,
  });

  final Size maxSize;
  final UseCaseStateMutation? startBuildSetup;
}

List<_UseCaseConfig> _configsForUseCase(
  UseCaseDescriptor useCase,
) {
  final metadata = useCase.computeMetadata(addons);
  final configs = <_UseCaseConfig>[];
  Size maxSizeFromAppearance(ViewConstraints appearance) {
    return Size(
      appearance.maxWidth ?? 600,
      appearance.maxHeight ?? 600,
    );
  }

  final initialAppearanceMaxSize = maxSizeFromAppearance(
    metadata.initialViewConstraints,
  );

  configs.add(
    _UseCaseConfig(
      maxSize: initialAppearanceMaxSize,
    ),
  );
  for (final preset in metadata.definedKnobPresets) {
    configs.add(
      _UseCaseConfig(
        maxSize: initialAppearanceMaxSize,
        startBuildSetup: (composer) {
          composer.knobs.loadPreset(preset);
        },
      ),
    );
  }
  for (final appearance in metadata.viewConstraintsPresets) {
    configs.add(
      _UseCaseConfig(
        maxSize: maxSizeFromAppearance(appearance.viewConstraints),
        startBuildSetup: (composer) {
          composer.constraints.loadPreset(
            DefinedViewConstraintsPreset(appearance.name),
          );
        },
      ),
    );
  }
  return configs;
}
