import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

extension BackgroundComposerExtension on UseCaseComposer {
  BackgroundComposer get background => BackgroundComposer(this);
}

extension type BackgroundComposer(UseCaseComposer _c) {
  void named(String name) {
    _c.setMetadata<DefaultBackgroundOption>(NamedBackgroundOption(name: name));
  }

  void color(Color color) {
    _c.setMetadata<DefaultBackgroundOption>(
      CustomBackgroundOption(
        backgroundBox: ColoredBox(color: color),
      ),
    );
  }

  void widget(Widget widget) {
    _c.setMetadata<DefaultBackgroundOption>(
      CustomBackgroundOption(
        backgroundBox: widget,
      ),
    );
  }
}
