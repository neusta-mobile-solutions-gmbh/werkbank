import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder wDropdownUseCase(UseCaseComposer c) {
  c
    ..description(
      'A customized dropdown matching the Werkbank design.',
    )
    ..tags(
      [Tags.input],
    );

  c.constraints
    ..initialConstraints(
      const BoxConstraints(maxWidth: 200),
    )
    ..overview();

  final items = ['Item 1', 'Item 2', 'Item 3'];
  final valueKnob = c.knobs.list<String>(
    'Value',
    initialValue: items.first,
    options: items,
    optionLabel: (item) => item,
  );

  return (context) {
    return WDropdown(
      value: valueKnob.value,
      items: items
          .map(
            (item) => WDropdownMenuItem(
              value: item,
              child: Text(item),
            ),
          )
          .toList(),
      onChanged: valueKnob.setValue,
    );
  };
}
