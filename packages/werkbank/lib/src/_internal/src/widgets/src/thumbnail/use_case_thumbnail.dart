import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class UseCaseThumbnail extends StatelessWidget {
  const UseCaseThumbnail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final useCase = DescriptorProvider.useCaseOf(context);
    final metadata = UseCaseMetadataProvider.metadataOf(context, useCase);
    final overviewSettings = metadata.overviewSettings;
    final viewportPadding = overviewSettings.hasPadding
        ? const EdgeInsets.all(8)
        : EdgeInsets.zero;
    return AddonLayerBuilder(
      layer: AddonLayer.useCaseOverlay,
      child: ThumbnailScaler(
        minSize: overviewSettings.minSize,
        maxScale: overviewSettings.maxScale ?? 1,
        viewportPadding: viewportPadding,
        child: IgnorePointer(
          child: ExcludeFocus(
            child: ExcludeSemantics(
              child: UseCaseApp(
                appConfig: WerkbankAppInfo.appConfigOf(context),
                child: AddonLayerBuilder(
                  layer: AddonLayer.useCase,
                  child: UseCaseLayout(
                    viewportPadding: viewportPadding,
                    child: const AddonLayerBuilder(
                      layer: AddonLayer.useCaseFitted,
                      child: UseCaseWidgetDisplay(),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
