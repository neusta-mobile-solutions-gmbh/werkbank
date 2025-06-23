import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder wExpandedIndicatorUseCase(UseCaseComposer c) {
  c.overview.maximumScale(4);
  final isExpanded = c.knobs.boolean('isExpanded', initialValue: true);

  return (context) {
    return WExpandedIndicator(
      isExpanded: isExpanded.value,
    );
  };
}
