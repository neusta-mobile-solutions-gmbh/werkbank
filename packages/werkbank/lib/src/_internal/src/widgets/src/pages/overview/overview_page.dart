import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/filter/filter.dart';
import 'package:werkbank/src/_internal/src/widgets/src/pages/_internal/page_background.dart';
import 'package:werkbank/src/_internal/src/widgets/src/pages/overview/_internal/component_overview_tile.dart';
import 'package:werkbank/src/_internal/src/widgets/src/pages/overview/_internal/use_case_overview_tile.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/environment/environment.dart';
import 'package:werkbank/src/routing/routing.dart';
import 'package:werkbank/src/theme/theme.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case_metadata/use_case_metadata.dart';
import 'package:werkbank/src/widgets/widgets.dart';

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
                        includeComponentChildren:
                            descriptor is ComponentDescriptor,
                      ),
                    );
                    final useCaseOrComponentDescriptors = filteredDescriptors
                        .cast<ChildDescriptor>();

                    delegate = SliverChildBuilderDelegate(
                      (context, index) {
                        final child = useCaseOrComponentDescriptors[index];
                        switch (child) {
                          case UseCaseDescriptor():
                            return UseCaseOverviewTile(
                              key: ValueKey(child.path),
                              useCaseDescriptor: child,
                              onPressed: (_) {
                                WerkbankRouter.of(context).goTo(
                                  DescriptorNavState.overviewOrView(child),
                                );
                              },
                              nameSegments: child.nameSegments
                                  .skip(descriptor.nameSegments.length)
                                  .toList(),
                              hasThumbnail: metadataMap[child]!
                                  .overviewSettings
                                  .hasThumbnail,
                            );
                          case ComponentDescriptor():
                            return ComponentOverviewTile(
                              key: ValueKey(child.path),
                              useCaseDescriptors: filter.filteredDescriptors(
                                child.useCases,
                              ),
                              hasThumbnail: (useCaseDescriptor) =>
                                  metadataMap[useCaseDescriptor]!
                                      .overviewSettings
                                      .hasThumbnail,
                              onPressed: () {
                                WerkbankRouter.of(
                                  context,
                                ).goTo(
                                  DescriptorNavState.overviewOrView(child),
                                );
                              },
                              nameSegments: child.nameSegments
                                  .skip(descriptor.nameSegments.length)
                                  .toList(),
                            );
                          case FolderDescriptor():
                            throw AssertionError('Unexpected FolderDescriptor');
                        }
                      },
                      childCount: useCaseOrComponentDescriptors.length,
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
                        return UseCaseOverviewTile(
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
                                childAspectRatio: 0.8,
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
