import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/background/background.dart';

/// A selectable background option for uses cases, which can be added to the
/// [BackgroundAddon].
class BackgroundOption {
  /// Creates a [BackgroundOption] from a [Widget].
  ///
  /// {@template werkbank.background_option.name}
  /// The [name] is used as a label in the dropdown to select the background.
  /// Additionally, you can use the [name] inside of [BackgroundComposer.named]
  /// to set the default background of a use case to the background defined in
  /// this [BackgroundOption].
  /// {@endtemplate}
  ///
  /// The [widget] is used as the background of the use case.
  const BackgroundOption.widget({
    required this.name,
    required Widget widget,
  }) : backgroundWidget = widget;

  /// Creates a [BackgroundOption] from a [WidgetBuilder].
  ///
  /// {@macro werkbank.background_option.name}
  ///
  /// The [widgetBuilder] is used to build the background [Widget]
  /// of the use case
  factory BackgroundOption.widgetBuilder({
    required String name,
    required WidgetBuilder widgetBuilder,
  }) {
    return BackgroundOption.widget(
      name: name,
      widget: Builder(
        builder: widgetBuilder,
      ),
    );
  }

  /// Creates a [BackgroundOption] from a [Color].
  ///
  /// {@macro werkbank.background_option.name}
  ///
  /// The [color] is used as the background of the use case.
  factory BackgroundOption.color({
    required String name,
    required Color color,
  }) {
    return BackgroundOption.widget(
      name: name,
      widget: ColoredBox(color: color),
    );
  }

  /// Creates a [BackgroundOption] from a function that builds a [Color]
  /// using the provided [BuildContext].
  ///
  /// {@macro werkbank.background_option.name}
  ///
  /// The [colorBuilder] is used to build the background color
  /// of the use case.
  factory BackgroundOption.colorBuilder({
    required String name,
    required Color Function(BuildContext context) colorBuilder,
  }) {
    return BackgroundOption.widgetBuilder(
      name: name,
      widgetBuilder: (context) => ColoredBox(
        color: colorBuilder(context),
      ),
    );
  }

  /// The name of the background option.
  final String name;

  /// The widget that is used as the background.
  final Widget backgroundWidget;
}
