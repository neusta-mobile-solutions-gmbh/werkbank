import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder wAutoChangePageIndicatorUseCase(UseCaseComposer c) {
  final pageCount = c.knobs.intSlider(
    'Page Count',
    initialValue: 5,
    max: 50,
    min: 1,
  );
  final selectedPage = c.knobs.intSlider(
    'Selected Page',
    initialValue: 0,
    max: 49,
  );
  return (context) {
    return WAutoChangePageIndicator(
      pageCount: pageCount.value,
      selectedPage: selectedPage.value % pageCount.value,
      onSelectedPageChanged: (index) {
        selectedPage.value = index;
      },
    );
  };
}
