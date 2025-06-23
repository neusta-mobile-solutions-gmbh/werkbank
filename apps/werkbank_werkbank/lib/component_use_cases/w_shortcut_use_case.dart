import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder wShortcutUseCase(UseCaseComposer c) {
  c
    ..description(
      'A component used to display a keyboard shortcut.',
    )
    ..tags([Tags.display]);

  final strokes = c.knobs.string(
    'strokes (enter comma separated)',
    initialValue: '⌘,⇧,A',
  );

  final description = c.knobs.string(
    'description',
    initialValue: 'Select all',
  );

  return (context) {
    return WShortcut(
      keyStrokes: strokes.value.split(','),
      description: description.value,
    );
  };
}
