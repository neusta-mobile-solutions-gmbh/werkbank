import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/app_config/app_config.dart';
import 'package:werkbank/src/environment/environment.dart';

class UseCaseApp extends StatelessWidget {
  const UseCaseApp({
    super.key,
    required this.appConfig,
    required this.child,
  });

  final AppConfig appConfig;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaQueryData = MediaQuery.of(context);
        return MediaQuery(
          data: MediaQueryData(
            size: constraints.biggest,
            textScaler: TextScaler.noScaling,
            devicePixelRatio: mediaQueryData.devicePixelRatio,
          ),
          child: appConfig.buildApp(
            context,
            (context, child) {
              return _SharedEnvironment(
                child: AddonLayerBuilder(
                  layer: AddonLayer.affiliationTransition,
                  // TODO(lzuttermeister): Do we still need this?
                  // Localizations widgets create a Semantics widget
                  // that merges the semantics of its descendants.
                  // This ensures that the semantic boxes of
                  // the children are kept separate.
                  child: Semantics(
                    explicitChildNodes: true,
                    child: Builder(
                      builder: (context) {
                        return appConfig.buildDefaultTextStyle(
                          context,
                          child ?? const SizedBox.shrink(),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
            child,
          ),
        );
      },
    );
  }
}

class _SharedEnvironment extends StatefulWidget {
  const _SharedEnvironment({
    required this.child,
  });

  final Widget child;

  @override
  State<_SharedEnvironment> createState() => _SharedEnvironmentState();
}

class _SharedEnvironmentState extends State<_SharedEnvironment> {
  final String key = 'werkbank_environment';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return;
      SharedAppData.setValue(
        context,
        key,
        switch (WerkbankEnvironmentProvider.of(context)) {
          WerkbankEnvironment.app => 'app',
          WerkbankEnvironment.display => 'display',
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
