import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder wControlItemUseCase(UseCaseComposer c) {
  c
    ..description(
      'An item which adds a title to an input widget that is usually used '
      'to control some value. '
      'Depending on the available width and its configuration, '
      'the layout of the control item changes.',
    )
    ..tags([Tags.container])
    ..urls([]);

  c.constraints
    ..initial(width: 200)
    ..preset('Narrow', width: 200)
    ..preset('Wide', width: 400)
    ..overview();

  c.overview.minimumSize(width: 200);

  final title = c.knobs.string('Title', initialValue: 'Title');
  final layout = c.knobs.list(
    'Layout',
    initialValue: ControlItemLayout.compact,
    options: [ControlItemLayout.compact, ControlItemLayout.spacious],
    optionLabel: (ControlItemLayout layout) => switch (layout) {
      ControlItemLayout.compact => 'Compact',
      ControlItemLayout.spacious => 'Spacious',
    },
  );
  final withTrailingIcon = c.knobs.boolean(
    'With trailing icon',
    initialValue: false,
  );

  return (context) {
    return WControlItem(
      layout: layout.value,
      title: Text(title.value),
      trailing: withTrailingIcon.value
          ? WTrailingButton(
              onPressed: () {},
              child: const Icon(
                WerkbankIcons.info,
              ),
            )
          : null,
      control: WSwitch(
        value: true,
        onChanged: (_) {},
        falseLabel: const Text('False'),
        trueLabel: const Text('True'),
      ),
    );
  };
}
