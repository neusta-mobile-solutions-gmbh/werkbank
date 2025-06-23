import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder wIconButtonUseCase(UseCaseComposer c) {
  c
    ..description(
      'A small button with an active state and an icon.',
    )
    ..tags([Tags.button]);

  final isActive = c.knobs.boolean('Is Active', initialValue: false);
  final useActiveIcon = c.knobs.boolean('Use Active Icon', initialValue: false);

  return (context) {
    return WIconButton(
      onPressed: () => isActive.value = !isActive.value,
      isActive: isActive.value,
      icon: const Icon(WerkbankIcons.circle),
      activeIcon: useActiveIcon.value ? const Icon(WerkbankIcons.empty) : null,
    );
  };
}
