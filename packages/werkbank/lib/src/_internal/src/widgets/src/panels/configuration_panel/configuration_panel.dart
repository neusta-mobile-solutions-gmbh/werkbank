import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/_internal/src/routing/routing.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/environment/environment.dart';
import 'package:werkbank/src/notifications/notifications.dart';
import 'package:werkbank/src/routing/routing.dart';
import 'package:werkbank/src/theme/theme.dart';

class ConfigurationPanel extends StatelessWidget {
  const ConfigurationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final currentDescriptor = switch (NavStateProvider.of(context)) {
      HomeNavState() => null,
      DescriptorNavState(:final descriptor) => descriptor,
    };
    final nameSegments = currentDescriptor?.nameSegments ?? [];
    return SizedBox.expand(
      child: _ConfigurationPanelScaffold(
        pathInfoArea: Visibility(
          visible: currentDescriptor != null,
          maintainSize: true,
          maintainAnimation: true,
          maintainState: true,
          child: WButtonBase(
            backgroundColor: Colors.transparent,
            onPressed: nameSegments.isEmpty
                ? null
                : () {
                    final copyText = nameSegments.last;
                    unawaited(
                      Clipboard.setData(
                        ClipboardData(text: copyText),
                      ),
                    );
                    WerkbankNotifications.controllerOf(context).dispatch(
                      WerkbankNotification.text(
                        title: context.sL10n.configurationPanel
                            .nameCopiedNotificationMessage(name: copyText),
                      ),
                    );
                  },
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: WPathDisplay(
                nameSegments: nameSegments,
              ),
            ),
          ),
        ),
        tabArea: WTabView(
          tabs: [
            WTab(
              title: Text(context.sL10n.configurationPanel.tabs.configure),
              child: const _UseCaseNeedingTabWrapper(
                tab: ConfigureTab(),
              ),
            ),
            WTab(
              title: Text(context.sL10n.configurationPanel.tabs.inspect),
              child: const _UseCaseNeedingTabWrapper(
                tab: InspectTab(),
              ),
            ),
            WTab(
              title: Text(context.sL10n.configurationPanel.tabs.settings),
              child: const SettingsTab(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConfigurationPanelScaffold extends StatelessWidget {
  const _ConfigurationPanelScaffold({
    required this.pathInfoArea,
    required this.tabArea,
  });

  final Widget pathInfoArea;
  final Widget tabArea;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.werkbankColorScheme.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: pathInfoArea,
          ),
          Expanded(
            child: tabArea,
          ),
        ],
      ),
    );
  }
}

/* TODO(lzuttermeister): Should the addons handle which sections to show
     based on whether there is a use case? If so, this won't be needed
     later. */
class _UseCaseNeedingTabWrapper extends StatelessWidget {
  const _UseCaseNeedingTabWrapper({required this.tab});

  final Widget tab;

  @override
  Widget build(BuildContext context) {
    switch (NavStateProvider.of(context)) {
      case HomeNavState() || ParentOverviewNavState():
        return _PlaceholderContent(
          child: Text(context.sL10n.configurationPanel.noUseCaseSelected),
        );
      case UseCaseOverviewNavState():
        return _PlaceholderContent(
          child: Text(
            context.sL10n.configurationPanel.cantConfigureUseCaseInOverview,
          ),
        );
      case ViewUseCaseNavState(:final descriptor):
        return DescriptorProvider(
          descriptor: descriptor,
          child: UseCaseEnvironmentProvider(
            // We have to set the environment here, since the
            // UseCaseAccessorMixin allows to read the value in these tabs.
            // Currently we show the placeholder above though if we are
            // in an overview, so we don't need to handle that case here.
            environment: UseCaseEnvironment.regular,
            child: UseCaseCompositionProvider(
              composition: UseCaseControllerManager.currentCompositionOf(
                context,
              )!,
              child: tab,
            ),
          ),
        );
    }
  }
}

class _PlaceholderContent extends StatelessWidget {
  const _PlaceholderContent({
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    // TODO(lzuttermeister): Add real placeholder once there is a design?
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Center(
        child: DefaultTextStyle(
          style: context.werkbankTextTheme.detail.apply(
            color: context.werkbankColorScheme.textLight,
          ),
          textAlign: TextAlign.center,
          child: child,
        ),
      ),
    );
  }
}
