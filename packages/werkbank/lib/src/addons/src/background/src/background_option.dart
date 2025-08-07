import 'package:flutter/material.dart';

/// {@category Backgrounds}
class BackgroundOption {
  const BackgroundOption({
    required this.name,
    required this.backgroundBox,
  });

  factory BackgroundOption.color({
    required String name,
    required Color Function(BuildContext context) colorBuilder,
  }) {
    return BackgroundOption.builder(
      name: name,
      backgroundBoxBuilder: (context) => ColoredBox(
        color: colorBuilder(context),
      ),
    );
  }

  factory BackgroundOption.builder({
    required String name,
    required Widget Function(BuildContext context) backgroundBoxBuilder,
  }) {
    return BackgroundOption(
      name: name,
      backgroundBox: Builder(
        builder: backgroundBoxBuilder,
      ),
    );
  }

  final String name;
  final Widget backgroundBox;
}
