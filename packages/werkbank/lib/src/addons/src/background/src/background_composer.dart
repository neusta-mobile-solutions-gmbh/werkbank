import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

extension BackgroundComposerExtension on UseCaseComposer {
  /// Provides a [BackgroundComposer] with methods to set the default background
  /// for the use case.
  BackgroundComposer get background => BackgroundComposer(this);
}

/// A composer for setting the default background of a use case.
extension type BackgroundComposer(UseCaseComposer _c) {
  /// Sets the default background for the use case to one of the
  /// [BackgroundAddon.backgroundOptions] listed in the [BackgroundAddon]
  /// including the ones included by default.
  ///
  /// The the given [name] refers to the [BackgroundOption.name] of the
  /// background.
  ///
  /// {@template werkbank.background_is_overwritten}
  /// Calling this method will overwrite the default background set by any
  /// previous calls to [named], [color], [colorBuilder], [widget]
  /// or [widgetBuilder].
  /// {@endtemplate}
  void named(String name) {
    _c.setMetadata<DefaultBackgroundOption>(NamedBackgroundOption(name: name));
  }

  /// Sets the default background for the use case to a given [color].
  ///
  /// {@macro werkbank.background_is_overwritten}
  void color(Color color) {
    widget(ColoredBox(color: color));
  }

  /// Sets the default background for the use case to a color that is built
  /// using the given [colorBuilder]. This allows you to use for example
  /// theme colors using the provided [BuildContext].
  ///
  /// {@macro werkbank.background_is_overwritten}
  void colorBuilder(Color Function(BuildContext context) colorBuilder) {
    widgetBuilder(
      (context) => ColoredBox(
        color: colorBuilder(context),
      ),
    );
  }

  /// Sets the default background for the use case to a given [widget].
  ///
  /// {@macro werkbank.background_is_overwritten}
  void widget(Widget widget) {
    _c.setMetadata<DefaultBackgroundOption>(
      CustomBackgroundOption(
        backgroundBox: widget,
      ),
    );
  }

  /// Sets the default background for the use case to a widget that is built
  /// using the given [widgetBuilder]. This allows you to use for example
  /// theme colors using the provided [BuildContext].
  ///
  /// {@macro werkbank.background_is_overwritten}
  void widgetBuilder(WidgetBuilder widgetBuilder) {
    widget(
      Builder(
        builder: widgetBuilder,
      ),
    );
  }
}
