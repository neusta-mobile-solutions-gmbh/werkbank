import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

/// {@category Display}
/// {@category Testing with Use Cases}
class UseCaseDisplay extends StatefulWidget {
  const UseCaseDisplay({
    super.key,
    required this.useCase,
    this.initialMutation,
  });

  final UseCaseDescriptor useCase;

  /// A callback that is called before the build method of the use case is
  /// called. This can be used to set up the state of the use case using a
  /// [UseCaseComposition].
  ///
  /// Changes to this function will not cause the use case to reassemble.
  final UseCaseStateMutation? initialMutation;

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
        child: const UseCaseCompositionByControllerProvider(
          child: AddonLayerBuilder(
            layer: AddonLayer.useCase,
            child: UseCaseLayout(
              child: AddonLayerBuilder(
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
