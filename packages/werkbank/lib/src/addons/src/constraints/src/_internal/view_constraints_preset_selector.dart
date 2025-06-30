import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/werkbank.dart';

class ViewConstraintsPresetSelector extends StatelessWidget {
  const ViewConstraintsPresetSelector({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final viewConstraintsPresets = UseCaseControlSection.access
        .metadataOf(context)
        .viewConstraintsPresets;
    final constraintsComposition = UseCaseControlSection.access
        .compositionOf(context)
        .constraints;
    final textTheme = context.werkbankTextTheme;
    final colorScheme = context.werkbankColorScheme;
    return ValueListenableBuilder(
      valueListenable:
          constraintsComposition.activeViewConstraintsPresetListenable,
      builder: (context, value, child) {
        return WControlItem(
          title: Text(context.sL10n.addons.constraints.controls.preset.name),
          control: WDropdown<SelectableViewConstraintsPreset?>(
            onChanged: (preset) {
              if (preset != null) {
                constraintsComposition.loadPreset(preset);
              }
            },
            value: value,
            items: [
              // TODO(lzuttermeister): This option should not be selectable.
              WDropdownMenuItem(
                value: null,
                child: Text(
                  context
                      .sL10n
                      .addons
                      .constraints
                      .controls
                      .preset
                      .values
                      .unknown,
                ),
              ),
              WDropdownMenuItem(
                value: const InitialViewConstraintsPreset(),
                child: Text(
                  context
                      .sL10n
                      .addons
                      .constraints
                      .controls
                      .preset
                      .values
                      .initial,
                ),
              ),
              for (final preset in viewConstraintsPresets)
                WDropdownMenuItem(
                  value: DefinedViewConstraintsPreset(preset.name),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        preset.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          _viewConstraintsToLabelString(preset.viewConstraints),
                          style: textTheme.indicator.copyWith(
                            // TODO(lzuttermeister): Use color from scheme.
                            color: colorScheme.fieldContent.withValues(
                              alpha: 0.6,
                            ),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _viewConstraintsToLabelString(ViewConstraints viewConstraints) {
    final minWidth = switch (viewConstraints.minWidth) {
      double.infinity => '∞',
      final width => width.round().toString(),
    };
    final maxWidth = switch (viewConstraints.maxWidth) {
      double.infinity => '∞',
      null => 'view',
      final width => width.round().toString(),
    };
    final minHeight = switch (viewConstraints.minHeight) {
      double.infinity => '∞',
      final height => height.round().toString(),
    };
    final maxHeight = switch (viewConstraints.maxHeight) {
      double.infinity => '∞',
      null => 'view',
      final height => height.round().toString(),
    };
    final String width;
    if (viewConstraints.minWidth == viewConstraints.maxWidth) {
      width = minWidth;
    } else if (viewConstraints.minWidth == double.infinity &&
        viewConstraints.maxWidth == null) {
      width = 'view';
    } else {
      width = '$minWidth–$maxWidth';
    }
    final String height;
    if (viewConstraints.minHeight == viewConstraints.maxHeight) {
      height = minHeight;
    } else if (viewConstraints.minHeight == double.infinity &&
        viewConstraints.maxHeight == null) {
      height = 'view';
    } else {
      height = '$minHeight–$maxHeight';
    }

    return '$width × $height';
  }
}
