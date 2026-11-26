/// @docImport 'package:werkbank/src/addons/src/background/background.dart';
library;

import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/use_case.dart';
import 'package:werkbank/src/utils/utils.dart';
import 'package:werkbank/src/widgets/src/display/display_app.dart';

/// {@category Display}
/// {@category Testing with Use Cases}
class UseCaseDisplay extends StatefulWidget {
  const UseCaseDisplay({
    super.key,
    required this.useCase,
    this.initialMutation,
    this.layoutBuilder,
  });

  final UseCaseDescriptor useCase;

  /// A callback that is called before the build method of the use case is
  /// called. This can be used to set up the state of the use case using a
  /// [UseCaseComposition].
  ///
  /// Changes to this function will not cause the use case to reassemble.
  final UseCaseStateMutation? initialMutation;

  /// An optional [WrapperBuilder] that wraps the [AddonLayer.useCaseLayout]
  /// layer.
  ///
  /// This can be used to add layout around the use case, such as padding,
  /// alignment, or constraints.
  ///
  /// Unlike when wrapping the entire [UseCaseDisplay], the widgets in
  /// [layoutBuilder] are placed within the [AddonLayer.useCase] layer.
  /// For example if you want a background from the [BackgroundAddon] to fill
  /// the [DisplayApp] while the use case within is centered, you have to put
  /// the [Center] widget in the [layoutBuilder].
  /// Otherwise the background introduced in the [AddonLayer.useCase] layer
  /// is inside the [Center] widget.
  final WrapperBuilder? layoutBuilder;

  @override
  State<UseCaseDisplay> createState() => _UseCaseDisplayState();
}

class _UseCaseDisplayState extends State<UseCaseDisplay> {
  @override
  Widget build(BuildContext context) {
    return DescriptorProvider(
      descriptor: widget.useCase,
      child: LocalUseCaseControllerProvider(
        initialMutation: widget.initialMutation,
        child: UseCaseCompositionByControllerProvider(
          child: AddonLayerBuilder(
            layer: AddonLayer.useCase,
            child: UseCaseLayout(
              additionalLayoutBuilder: widget.layoutBuilder,
              child: const AddonLayerBuilder(
                layer: AddonLayer.useCaseFitted,
                child: UseCaseWidgetDisplay(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
