import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addons/src/color_picker/src/_internal/color_picker.dart';
import 'package:werkbank/src/addons/src/color_picker/src/_internal/color_picker_manager.dart';
import 'package:werkbank/src/addons/src/color_picker/src/_internal/color_picker_mouse_handler.dart';
import 'package:werkbank/src/addons/src/color_picker/src/_internal/color_picker_section.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Configuring Addons}
class ColorPickerAddon extends Addon {
  const ColorPickerAddon() : super(id: addonId);

  static const addonId = 'color_picker';

  @override
  AddonLayerEntries get layers {
    return AddonLayerEntries(
      management: [
        ManagementLayerEntry(
          id: 'color_picker_manager',
          appOnly: true,
          builder: (context, child) => ColorPickerManager(
            child: child,
          ),
        ),
      ],
      useCaseOverlay: [
        UseCaseOverlayLayerEntry(
          id: 'color_picker_mouse_handler',
          includeInOverlay: false,
          builder: (context, child) => ColorPickerMouseHandler(
            child: child,
          ),
        ),
      ],
      affiliationTransition: [
        AffiliationTransitionLayerEntry(
          id: 'color_picker_section',
          includeInOverlay: false,
          appOnly: true,
          builder: (context, child) => ColorPickerSection(
            child: child,
          ),
        ),
      ],
    );
  }

  @override
  List<InspectControlSection> buildInspectTabControlSections(
    BuildContext context,
  ) {
    return [
      InspectControlSection(
        id: 'color_picker_section',
        title: Text(context.sL10n.addons.colorPicker.name),
        children: [const ColorPicker()],
      ),
    ];
  }
}
