import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder wTitledUseCase(UseCaseComposer c) {
  final title = c.knobs.string('Title', initialValue: 'About');
  return (context) {
    return WTitled(
      title: Text(title.value),
      child: const Text('Child'),
    );
  };
}
