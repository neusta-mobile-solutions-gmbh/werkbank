import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/src/pages/_internal/page_background.dart';

class OverviewPage extends StatelessWidget with OrderExecutor {
  const OverviewPage({
    required this.navState,
    super.key,
  });

  final OverviewNavState navState;

  @override
  Widget build(BuildContext context) {
    final descriptor = navState.descriptor;
    return PageBackground(
      child: DebugDisplayFilter(
        child: UseCaseEnvironmentProvider(
          environment: UseCaseEnvironment.overview,
          child: DescriptorProvider(
            descriptor: descriptor,
            child: Builder(
              builder: (context) {
                final metadataMap = UseCaseMetadataProvider.metadataMapOf(
                  context,
                );
                final SliverChildBuilderDelegate delegate;
                switch (navState) {
                  case ParentOverviewNavState(:final descriptor):
                    final filter = FilterResultProvider.of(context);
                    final orderOption = WerkbankSettings.orderOptionOf(
                      context,
                    );
                    final filteredDescriptors = filter.filteredDescriptors(
                      orderFlattenedTree(
                        descriptor,
                        orderOption,
                        includeParents: false,
                      ),
                    );
                    final useCaseDescriptor = filteredDescriptors
                        .cast<UseCaseDescriptor>()
                        .toList();

                    delegate = SliverChildBuilderDelegate(
                      (context, index) {
                        final child = useCaseDescriptor[index];
                        return _OverviewTile(
                          key: ValueKey(child.path),
                          useCaseDescriptor: child,
                          onPressed: (_) {
                            WerkbankRouter.of(
                              context,
                            ).goTo(DescriptorNavState.overviewOrView(child));
                          },
                          nameSegments: child.nameSegments
                              .skip(descriptor.nameSegments.length)
                              .toList(),
                          hasThumbnail:
                              metadataMap[child]!.overviewSettings.hasThumbnail,
                        );
                      },
                      childCount: useCaseDescriptor.length,
                    );
                  case UseCaseOverviewNavState(
                    :final descriptor,
                    :final config,
                  ):
                    final metadata = metadataMap[descriptor]!;
                    final hasThumbnail = metadata.overviewSettings.hasThumbnail;
                    final entries = config.entryBuilder(metadata);
                    delegate = SliverChildBuilderDelegate(
                      (context, index) {
                        final entry = entries[index];
                        return _OverviewTile(
                          key: ValueKey(entry.name),
                          useCaseDescriptor: descriptor,
                          initialMutation: entry.initialMutation,
                          onPressed: (tileController) {
                            final snapshot = tileController.saveSnapshot();
                            WerkbankRouter.of(context).goTo(
                              ViewUseCaseNavState(
                                descriptor: descriptor,
                                initialMutation: (controller) {
                                  controller.loadSnapshot(snapshot);
                                },
                              ),
                            );
                          },
                          nameSegments: [entry.name],
                          hasThumbnail: hasThumbnail,
                        );
                      },
                      childCount: entries.length,
                    );
                }
                return OverviewOverflowNotifier(
                  child: CustomScrollView(
                    slivers: [
                      SliverPadding(
                        padding: const EdgeInsets.all(24),
                        sliver: SliverToBoxAdapter(
                          child: WPathText(
                            nameSegments: descriptor.nameSegments,
                            isRelative: false,
                            isDirectory: descriptor is ParentDescriptor,
                            style: context.werkbankTextTheme.headline,
                            overflow: null,
                          ),
                        ),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(24).copyWith(top: 0),
                        sliver: SliverGrid(
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                mainAxisSpacing: 24,
                                crossAxisSpacing: 24,
                                maxCrossAxisExtent: 256,
                                childAspectRatio: 0.85,
                              ),
                          delegate: delegate,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _OverviewTile extends StatelessWidget {
  const _OverviewTile({
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
