import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/addons/src/viewer/src/_internal/viewer_gestures.dart';
import 'package:werkbank/src/addons/src/viewer/src/_internal/viewport_reference.dart';
import 'package:werkbank/src/utils/utils.dart';

/// {@category Configuring Addons}
class ViewerAddon extends Addon {
  const ViewerAddon() : super(id: addonId);

  static const addonId = 'viewer';

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      useCaseOverlay: [
        UseCaseOverlayLayerEntry(
          id: 'viewer_gestures',
          sortHint: SortHint.beforeMost,
          builder: (context, child) => ViewerGestures(child: child),
        ),
      ],
      // TODO(lzuttermeister): Is "useCase" the right layer for this?
      useCase: [
        UseCaseLayerEntry(
          id: 'viewport_reference',
          appOnly: true,
          sortHint: SortHint.afterMost,
          builder: (context, child) => ViewportReference(child: child),
        ),
      ],
    );
  }

  @override
  AddonDescription? buildDescription(BuildContext context) {
    final ctlKey = context.isApple
        ? LogicalKeyboardKey.meta
        : LogicalKeyboardKey.control;
    final sL10n = context.sL10n;

    return AddonDescription(
      priority: DescriptionPriority.high,
      markdownDescription: '''
  # Viewer

  An addon for the werkbank.
  ''',
      shortcuts: [
        ShortcutsSection(
          title: sL10n.addons.zoom.shortcuts.title,
          shortcuts: {
            {
              KeyOrText.key(ctlKey),
              KeyOrText.text(sL10n.addons.zoom.shortcuts.keystrokeZoom),
            }: sL10n.addons.zoom.shortcuts.descriptionZoom,
            {KeyOrText.key(ctlKey), KeyOrText.key(LogicalKeyboardKey.digit0)}:
                sL10n.addons.zoom.shortcuts.descriptionReset,
            {KeyOrText.key(ctlKey), KeyOrText.key(LogicalKeyboardKey.add)}:
                sL10n.addons.zoom.shortcuts.descriptionZoomIn,
            {KeyOrText.key(ctlKey), KeyOrText.key(LogicalKeyboardKey.minus)}:
                sL10n.addons.zoom.shortcuts.descriptionZoomOut,
            {
              KeyOrText.key(ctlKey),
              KeyOrText.text(sL10n.addons.zoom.shortcuts.keystrokePan),
            }: sL10n.addons.zoom.shortcuts.descriptionPan,
            {
              KeyOrText.key(ctlKey),
              KeyOrText.text(sL10n.addons.zoom.shortcuts.keystrokeZoomPan),
            }: sL10n.addons.zoom.shortcuts.descriptionZoomPan,
          },
        ),
      ],
    );
  }
}
