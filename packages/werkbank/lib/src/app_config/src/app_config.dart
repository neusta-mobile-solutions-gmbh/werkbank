import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

typedef AppBuilder =
    Widget Function(
      BuildContext context,
      TransitionBuilder builder,
      Widget home,
    );

/// {@category Getting Started}
/// {@category File Structure}
/// A class that defines how to build the app widget, which is typically one of
/// [MaterialApp], [CupertinoApp], or [WidgetsApp].
///
/// This needs to be passed to a [WerkbankApp] or [DisplayApp].
/// If you are using both, make sure to pass the same [AppConfig] in order to
/// ensure consistent behavior.
///
/// {@category Customizing the AppConfig}
abstract interface class AppConfig {
  /// A constructor which defines an [AppConfig] using callbacks.
  ///
  /// When passing the [buildApp] function, the `builder` parameter should be
  /// passed to the `builder` attribute of the app widget.
  /// The `home` parameter should be passed to the `home` attribute of the app
  /// widget, or if a `.router` constructor is used, it should be used such
  /// that it is opened as the initial route.
  ///
  /// If [additionalBuilder] is provided, it will be integrated into the
  /// `builder` parameter and thus can be used similar to how you would use
  /// the `builder` attribute of a [MaterialApp] or [CupertinoApp] for example.
  /// Additionally the widgets from the [AddonLayer.affiliationTransition]
  /// layer are integrated into the `builder` parameter of the passed [buildApp]
  /// function.
  /// The widgets built inside the [additionalBuilder] can be assumed to be
  /// descendants of the widgets in the [AddonLayer.affiliationTransition]
  /// layer.
  factory AppConfig({
    required AppBuilder buildApp,
    TransitionBuilder? additionalBuilder,
    required WrapperBuilder defaultTextStyleBuilder,
  }) => _CallbackAppConfig(
    buildApp: buildApp,
    additionalBuilder: additionalBuilder,
    defaultTextStyleBuilder: defaultTextStyleBuilder,
  );

  /// A constructor which defines an [AppConfig] for a material app.
  ///
  /// The [additionalBuilder] parameter can be used like you normally would use
  /// the [MaterialApp.builder] parameter.
  factory AppConfig.material({TransitionBuilder? additionalBuilder}) =>
      AppConfig(
        buildApp: (context, builder, home) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            builder: builder,
            home: home,
          );
        },
        additionalBuilder: additionalBuilder,
        defaultTextStyleBuilder: (context, child) {
          return DefaultTextStyle(
            style: Theme.of(context).textTheme.bodyMedium!,
            child: child,
          );
        },
      );

  /// A constructor which defines an [AppConfig] for a cupertino app.
  ///
  /// The [additionalBuilder] parameter can be used like you normally would use
  /// the [CupertinoApp.builder] parameter.
  factory AppConfig.cupertino({TransitionBuilder? additionalBuilder}) =>
      AppConfig(
        buildApp: (context, builder, home) {
          return CupertinoApp(
            debugShowCheckedModeBanner: false,
            builder: builder,
            home: home,
          );
        },
        additionalBuilder: additionalBuilder,
        defaultTextStyleBuilder: (context, child) {
          return DefaultTextStyle(
            style: CupertinoTheme.of(context).textTheme.textStyle,
            child: child,
          );
        },
      );

  /// A constructor which defines an [AppConfig] for a widgets app.
  ///
  /// The [additionalBuilder] parameter can be used like you normally would use
  /// the [WidgetsApp.builder] parameter.
  factory AppConfig.widgets({
    TransitionBuilder? additionalBuilder,
    required WrapperBuilder defaultTextStyleBuilder,
  }) => AppConfig(
    buildApp: (context, builder, home) {
      return WidgetsApp(
        debugShowCheckedModeBanner: false,
        builder: builder,
        color: Colors.black,
        home: home,
      );
    },
    additionalBuilder: additionalBuilder,
    defaultTextStyleBuilder: defaultTextStyleBuilder,
  );

  /// Builds the app widget.
  /// This is typically one of [MaterialApp], [CupertinoApp], or [WidgetsApp].
  ///
  /// The [builder] parameter should be passed to the `builder` attribute of the
  /// app widget.
  Widget buildApp(
    BuildContext context,
    TransitionBuilder builder,
    Widget home,
  );

  /// Wraps the child with a default text style widget, which defines the
  /// default text style for the use cases.
  Widget buildDefaultTextStyle(BuildContext context, Widget child);
}

class _CallbackAppConfig implements AppConfig {
  const _CallbackAppConfig({
    required AppBuilder buildApp,
    this.additionalBuilder,
    required this.defaultTextStyleBuilder,
  }) : _buildApp = buildApp;

  final AppBuilder _buildApp;

  final TransitionBuilder? additionalBuilder;

  final WrapperBuilder defaultTextStyleBuilder;

  @override
  Widget buildApp(
    BuildContext context,
    TransitionBuilder builder,
    Widget home,
  ) {
    return _buildApp(
      context,
      (context, child) {
        final Widget? builderChild;
        if (additionalBuilder != null) {
          builderChild = Builder(
            builder: (context) => additionalBuilder!(context, child),
          );
        } else {
          builderChild = child;
        }
        return builder(context, builderChild);
      },
      home,
    );
  }

  @override
  Widget buildDefaultTextStyle(BuildContext context, Widget child) {
    return defaultTextStyleBuilder(context, child);
  }
}
