import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder werkbankLogoUseCase(UseCaseComposer c) {
  c.overview
    ..minimumSize(width: 64, height: 64)
    ..maximumScale(double.infinity);

  final sizeKnob = c.knobs.doubleSlider(
    'Size',
    initialValue: 64,
    max: 128,
  );

  return (context) {
    return WerkbankLogo(
      size: Size.square(sizeKnob.value),
    );
  };
}
