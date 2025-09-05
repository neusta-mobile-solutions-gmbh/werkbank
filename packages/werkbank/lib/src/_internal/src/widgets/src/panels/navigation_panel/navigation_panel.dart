import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/filter/filter.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/_internal/src/routing/routing.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/routing/routing.dart';
import 'package:werkbank/src/theme/theme.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/widgets/widgets.dart';

class NavigationPanel extends StatelessWidget with OrderExecutor {
  const NavigationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final rootDescriptor = WerkbankAppInfo.rootDescriptorOf(context);
    final filterResultMap = FilterResultProvider.of(context);
    final currentDescriptor = switch (NavStateProvider.of(context)) {
      HomeNavState() => null,
      DescriptorNavState(:final descriptor) => descriptor,
    };
    final orderOption = WerkbankSettings.orderOptionOf(context);
    return _NavigationPanelLayout(
      header: const _NavigationPanelHeader(),
      body: WTreeView(
        treeNodes: parseRootDescriptorToSTreeNodes(
          context: context,
          rootDescriptor: rootDescriptor,
          filterResultMap: filterResultMap,
          currentDescriptor: switch (currentDescriptor) {
            null || RootDescriptor() => null,
            ChildDescriptor() => currentDescriptor,
          },
          orderOption: orderOption,
        ),
      ),
    );
  }

  WTreeNode convertDescriptorToSTreeNode({
    required BuildContext context,
    required ChildDescriptor descriptor,
    required FilterResult filterResult,
    required ChildDescriptor? currentDescriptor,
    required OrderOption orderOption,
  }) {
    final isVisible = filterResult.descriptorVisibleInTree(descriptor);

    final leading = switch (descriptor) {
      FolderDescriptor() => const Icon(WerkbankIcons.folderSimple),
      ComponentDescriptor() => const Icon(WerkbankIcons.bigDots),
      UseCaseDescriptor() => const Icon(WerkbankIcons.bigDot),
    };

    return WTreeNode(
      key: ValueKey(descriptor.path),
      title: Text(descriptor.node.name),
      leading: leading,
      isInitiallyExpanded: switch (descriptor) {
        FolderDescriptor() => !descriptor.node.isInitiallyCollapsed,
        ComponentDescriptor() => !descriptor.node.isInitiallyCollapsed,
        UseCaseDescriptor() => false,
      },
      onTap: () {
        WerkbankRouter.of(
          context,
        ).goTo(DescriptorNavState.overviewOrView(descriptor));
      },
      isSelected: descriptor == currentDescriptor,
      isVisible: isVisible,
      children: switch (descriptor) {
        final ParentDescriptor descriptor =>
          orderChildren(descriptor.children, orderOption)
              .map(
                (e) => convertDescriptorToSTreeNode(
                  context: context,
                  descriptor: e,
                  filterResult: filterResult,
                  currentDescriptor: currentDescriptor,
                  orderOption: orderOption,
                ),
              )
              .toList(),
        UseCaseDescriptor() => null,
      },
    );
  }

  List<WTreeNode> parseRootDescriptorToSTreeNodes({
    required BuildContext context,
    required RootDescriptor rootDescriptor,
    required FilterResult filterResultMap,
    required ChildDescriptor? currentDescriptor,
    required OrderOption orderOption,
  }) {
    return orderChildren(rootDescriptor.children, orderOption)
        .map(
          (e) => convertDescriptorToSTreeNode(
            context: context,
            descriptor: e,
            filterResult: filterResultMap,
            currentDescriptor: currentDescriptor,
            orderOption: orderOption,
          ),
        )
        .toList();
  }
}

class _NavigationPanelLayout extends StatelessWidget {
  const _NavigationPanelLayout({
    required this.header,
    required this.body,
  });

  final Widget header;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final pinned =
            constraints.maxHeight > WBreakpoints.pinnedPanelHeadersBreakpoint;
        return ColoredBox(
          color: context.werkbankColorScheme.surface,
          child: CustomScrollView(
            slivers: [
              SliverPinnedHeader(
                pinned: pinned,
                child: header,
              ),
              SliverPadding(
                padding: const EdgeInsets.only(
                  left: 24,
                  right: 24,
                  bottom: 24,
                ),
                sliver: SliverToBoxAdapter(
                  child: body,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _NavigationPanelHeader extends StatelessWidget {
  const _NavigationPanelHeader();

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.werkbankColorScheme.surface,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: WProjectInfoArea(
              logo: WerkbankAppInfo.logoOf(context),
              title: Text(WerkbankAppInfo.nameOf(context)),
              lastUpdated: WerkbankAppInfo.lastUpdatedOf(context),
              onTap: () {
                WerkbankRouter.of(context).goTo(HomeNavState());
              },
            ),
          ),
          const WDivider.horizontal(),
          const Padding(
            padding: EdgeInsets.only(top: 24, left: 24, right: 24),
            child: SearchTextField(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Align(
              alignment: Alignment.centerLeft,
              child: WChip(
                onPressed: () {
                  WerkbankRouter.of(context).goTo(
                    DescriptorNavState.overviewOrView(
                      WerkbankAppInfo.rootDescriptorOf(context),
                    ),
                  );
                },
                leading: const Icon(WerkbankIcons.squaresFour),
                label: Text(context.sL10n.navigationPanel.overview),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
