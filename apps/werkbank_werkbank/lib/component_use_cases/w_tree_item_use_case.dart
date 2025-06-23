import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder wTreeItemUseCase(UseCaseComposer c) {
  c.constraints
    ..initial(width: 400)
    ..overview();

  final label = c.knobs.string('Label', initialValue: 'Root');
  // TODO(jthranitz): replace with int slider
  final nestingLevel = c.knobs.doubleSlider(
    'nesting level',
    initialValue: 0,
    max: 8,
    divisions: 8,
  );
  final iconData = c.knobs.list(
    'icons',
    options: [
      WerkbankIcons.folderSimple,
      WerkbankIcons.bookOpen,
      WerkbankIcons.bookmarkSimple,
    ],
    optionLabel: (icon) => switch (icon) {
      WerkbankIcons.folderSimple => 'Folder',
      WerkbankIcons.bookOpen => 'Menu',
      WerkbankIcons.bookmarkSimple => 'Bookmark',
      _ => 'Unknown',
    },
  );
  final showExpand = c.knobs.boolean('onExpand', initialValue: true);

  final showTrailing = c.knobs.boolean('showTrailing', initialValue: true);
  final isSelected = c.knobs.boolean('isSelected', initialValue: false);

  c
    ..knobPreset('Branch', () {
      label.value = 'Branch';
      iconData.value = WerkbankIcons.bookOpen;
      nestingLevel.value = 1.0;
      showExpand.value = false;
    })
    ..knobPreset('Leaf', () {
      label.value = 'Leaf';
      iconData.value = WerkbankIcons.bookmarkSimple;
      nestingLevel.value = 2;
      showExpand.value = false;
    });

  return (context) {
    return WTreeItem(
      onTap: () {},
      label: Text(label.value),
      leading: Icon(
        iconData.value,
        size: 16,
      ),
      nestingLevel: nestingLevel.value.toInt(),
      onExpansionChanged: showExpand.value ? (_) {} : null,
      trailing: showTrailing.value
          ? const Icon(
              WerkbankIcons.pushPin,
              size: 16,
            )
          : null,
      isSelected: isSelected.value,
    );
  };
}
