import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder wAnimatedVisibilityUseCase(UseCaseComposer c) {
  final visible = c.knobs.boolean('Visible', initialValue: true);

  return (context) {
    return WAnimatedVisibility(
      visible: visible.value,
      child: const ColoredBox(
        color: Colors.red,
        child: SizedBox(
          width: 100,
          height: 100,
        ),
      ),
    );
  };
}
