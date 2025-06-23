import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class WerkbankShortcuts extends StatelessWidget with OrderExecutor {
  const WerkbankShortcuts({
    required this.child,
    super.key,
  });

  final Widget child;

  static List<ShortcutsSection> shortcutsSections(BuildContext context) {
    final sL10n = context.sL10n;
    final ctlKey = context.isApple
        ? LogicalKeyboardKey.meta
        : LogicalKeyboardKey.control;
    return [
      ShortcutsSection(
        title: sL10n.shortcuts.general.title,
        shortcuts: {
          {
            KeyOrText.key(LogicalKeyboardKey.escape),
          }: sL10n.shortcuts.general.descriptionHome,
          {
            KeyOrText.key(ctlKey),
            KeyOrText.key(LogicalKeyboardKey.keyF),
          }: sL10n.shortcuts.general.descriptionSearch,
          {
            KeyOrText.key(ctlKey),
            KeyOrText.key(LogicalKeyboardKey.period),
          }: sL10n.shortcuts.general.descriptionTogglePanel,
        },
      ),
      ShortcutsSection(
        title: sL10n.shortcuts.navigationMode.title,
        shortcuts: {
          {
            KeyOrText.text(sL10n.shortcuts.navigationMode.keystrokePrevious),
          }: sL10n.shortcuts.navigationMode.descriptionPrevious,
          {
            KeyOrText.text(sL10n.shortcuts.navigationMode.keystrokeNext),
          }: sL10n.shortcuts.navigationMode.descriptionNext,
        },
      ),
    ];
  }

  // If we would use signal, this method would be a perfect example for
  // what to use it for.
  List<Descriptor> _filteredAndOrderedDescriptors(BuildContext context) {
    final orderOption = WerkbankSettings.orderOptionOf(context);
    final rootDescriptor = WerkbankAppInfo.rootDescriptorOf(context);
    final orderedDescriptors = orderFlattenedTree(
      rootDescriptor,
      orderOption,
      includeParents: true,
    );
    final filterResult = FilterResultProvider.of(context);
    return filterResult.filteredDescriptors(orderedDescriptors);
  }

  Map<String, int> _filteredAndOrderedDescriptorsMap(
    List<Descriptor> descriptors,
  ) {
    final filteredAndOrderedDescriptors = descriptors;
    return {
      for (final (i, descriptor) in filteredAndOrderedDescriptors.indexed)
        descriptor.path: i,
    };
  }

  int? findNextUseCase(
    List<Descriptor> list,
    int currentIndex,
  ) {
    final n = list.length;
    for (var i = 1; i < n; i++) {
      final nextIndex = (currentIndex + i) % n;
      if (list[nextIndex] is UseCaseDescriptor) {
        return nextIndex;
      }
    }
    return null;
  }

  int? findPreviousUseCase(
    List<Descriptor> list,
    int currentIndex,
  ) {
    final n = list.length;
    for (var i = 1; i < n; i++) {
      final nextIndex = (currentIndex - i) % n;
      if (list[nextIndex] is UseCaseDescriptor) {
        return nextIndex;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final panelController = PanelControllerProvider.of(context);
    final filteredAndOrderedDescriptors = _filteredAndOrderedDescriptors(
      context,
    );
    final filteredAndOrderedDescriptorsMap = _filteredAndOrderedDescriptorsMap(
      filteredAndOrderedDescriptors,
    );
    final currentDescriptor = switch (NavStateProvider.of(context)) {
      HomeNavState() => null,
      DescriptorNavState(:final descriptor) => descriptor,
    };
    return _Shortcuts(
      onToggelPanel: panelController.toggle,
      onSearch: () {
        WerkbankPersistence.maybeSearchQueryController(
          context,
        )?.focusNode.requestFocus();
      },
      onOverview: () {
        WerkbankPersistence.maybeSearchQueryController(context)?.reset();
        WerkbankRouter.of(context).goTo(HomeNavState());
      },
      onNext: () {
        final currentIndex = currentDescriptor != null
            ? filteredAndOrderedDescriptorsMap[currentDescriptor.path] ?? 0
            : 0;
        final nextIndex = findNextUseCase(
          filteredAndOrderedDescriptors,
          currentIndex,
        );
        if (nextIndex != null &&
            nextIndex < filteredAndOrderedDescriptors.length) {
          WerkbankRouter.of(context).goTo(
            DescriptorNavState.overviewOrView(
              filteredAndOrderedDescriptors[nextIndex],
            ),
          );
        }
      },
      onPrevious: () {
        final currentIndex = currentDescriptor != null
            ? filteredAndOrderedDescriptorsMap[currentDescriptor.path] ?? 0
            : 0;
        final prevIndex = findPreviousUseCase(
          filteredAndOrderedDescriptors,
          currentIndex,
        );
        if (prevIndex != null && prevIndex >= 0) {
          WerkbankRouter.of(context).goTo(
            DescriptorNavState.overviewOrView(
              filteredAndOrderedDescriptors[prevIndex],
            ),
          );
        }
      },
      child: child,
    );
  }
}

class _Shortcuts extends StatelessWidget {
  const _Shortcuts({
    required this.child,
    this.onPrevious,
    this.onNext,
    this.onOverview,
    this.onSearch,
    this.onToggelPanel,
  });

  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final VoidCallback? onOverview;
  final VoidCallback? onSearch;
  final VoidCallback? onToggelPanel;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isApple = context.isApple;
    return GlobalCallbackShortcuts(
      bindings: <ShortcutActivator, VoidCallback>{
        if (onPrevious != null) ...{
          const SingleActivator(LogicalKeyboardKey.arrowUp): onPrevious!,
          const SingleActivator(LogicalKeyboardKey.pageUp): onPrevious!,
        },
        if (onNext != null) ...{
          const SingleActivator(LogicalKeyboardKey.arrowDown): onNext!,
          const SingleActivator(LogicalKeyboardKey.pageDown): onNext!,
        },
        if (onOverview != null)
          const SingleActivator(LogicalKeyboardKey.escape): onOverview!,
        if (onSearch != null)
          SingleActivator(
            LogicalKeyboardKey.keyF,
            control: !isApple,
            meta: isApple,
          ): onSearch!,
        if (onToggelPanel != null)
          SingleActivator(
            LogicalKeyboardKey.period,
            control: !isApple,
            meta: isApple,
          ): onToggelPanel!,
      },
      child: child,
    );
  }
}
