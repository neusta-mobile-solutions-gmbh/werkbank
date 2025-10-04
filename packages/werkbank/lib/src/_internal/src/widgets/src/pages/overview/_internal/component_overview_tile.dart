import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/tree/tree.dart';

class ComponentOverviewTile extends StatelessWidget {
  const ComponentOverviewTile({
    super.key,
    required this.useCaseDescriptors,
    required this.hasThumbnail,
    required this.nameSegments,
    required this.onPressed,
  });

  final List<UseCaseDescriptor> useCaseDescriptors;
  final bool Function(UseCaseDescriptor descriptor) hasThumbnail;
  final List<String> nameSegments;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return WOverviewTile.multi(
      onPressed: onPressed,
      nameSegments: nameSegments,
      thumbnailBuilders: [
        for (final useCaseDescriptor in useCaseDescriptors)
          if (hasThumbnail(useCaseDescriptor))
            (context) => DescriptorProvider(
              descriptor: useCaseDescriptor,
              child: const LocalUseCaseControllerProvider(
                child: UseCaseCompositionByControllerProvider(
                  child: UseCaseThumbnail(),
                ),
              ),
            )
          else
            null,
      ],
    );
  }
}
