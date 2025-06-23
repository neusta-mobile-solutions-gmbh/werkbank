import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder wChipUseChase(UseCaseComposer c) {
  c
    ..description(
      'A chip with an active state and two optional icons.',
    )
    ..tags([Tags.button]);

  final isActive = c.knobs.boolean('Is Active', initialValue: false);
  final labelText = c.knobs.string('Label', initialValue: 'LINK');
  final showLeading = c.knobs.boolean(
    'Show Leading',
    initialValue: true,
  );
  final showTrailing = c.knobs.boolean(
    'Show Trailing',
    initialValue: true,
  );

  return (context) {
    return WChip(
      onPressed: () {
        UseCase.dispatchTextNotification(
          context,
          'Chip pressed',
        );
      },
      isActive: isActive.value,
      leading: showLeading.value ? const Icon(WerkbankIcons.figmaLogo) : null,
      label: Text(labelText.value),
      trailing: showTrailing.value
          ? const Icon(WerkbankIcons.arrowSquareOut)
          : null,
    );
  };
}
