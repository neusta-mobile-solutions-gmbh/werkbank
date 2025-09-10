import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/use_case.dart';

class UseCaseOverviewTile extends StatelessWidget {
  const UseCaseOverviewTile({
    super.key,
    required this.useCaseDescriptor,
    this.initialMutation,
    required this.nameSegments,
    required this.onPressed,
    required this.hasThumbnail,
  });

  final UseCaseDescriptor useCaseDescriptor;
  final UseCaseStateMutation? initialMutation;
  final List<String> nameSegments;
  final void Function(UseCaseComposition composition) onPressed;
  final bool hasThumbnail;

  @override
  Widget build(BuildContext context) {
    return DescriptorProvider(
      descriptor: useCaseDescriptor,
      child: LocalUseCaseControllerProvider(
        initialMutation: initialMutation,
        child: UseCaseCompositionByControllerProvider(
          child: Builder(
            builder: (context) {
              return WOverviewTile(
                onPressed: () {
                  onPressed(
                    UseCaseCompositionProvider.compositionOf(
                      context,
                    ),
                  );
                },
                nameSegments: nameSegments,
                thumbnail: hasThumbnail ? const UseCaseThumbnail() : null,
              );
            },
          ),
        ),
      ),
    );
  }
}
