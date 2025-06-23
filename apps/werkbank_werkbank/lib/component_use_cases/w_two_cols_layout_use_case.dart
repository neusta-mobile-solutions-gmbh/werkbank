import 'dart:math';

import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder wTwoColsLayoutUseCase(UseCaseComposer c) {
  final count = c.knobs.intSlider('Children', max: 20, initialValue: 5);

  final mainAxisSpaceBetween = c.knobs.doubleSlider(
    'Main Axis Space Between',
    max: 100,
    initialValue: 16,
  );

  final crossAxisSpaceBetween = c.knobs.doubleSlider(
    'Cross Axis Space Between',
    max: 100,
    initialValue: 16,
  );

  final retainFirstOrder = c.knobs.boolean(
    'Retain First Order',
    initialValue: false,
  );

  final rebuildChangesHeight = c.knobs.boolean(
    'Rebuild Changes item Height',
    initialValue: false,
  );

  return (context) {
    return WTwoColsLayout(
      mainAxisSpaceBetween: mainAxisSpaceBetween.value,
      crossAxisSpaceBetween: crossAxisSpaceBetween.value,
      retainFirstOrder: retainFirstOrder.value,
      children: List.generate(count.value, (index) {
        final height = Random(index).nextDouble() * 500 + 50;

        if (rebuildChangesHeight.value) {
          // This LayoutBuilder is used to trigger rebuilds when
          // the constraints change.
          return LayoutBuilder(
            builder: (context, _) {
              final heightChange = (Random().nextDouble() * 5) - 2.5;
              return Container(
                key: ValueKey(index),
                color: Colors.primaries[index % Colors.primaries.length],
                height: height + heightChange,
                child: Center(
                  child: Text('$index'),
                ),
              );
            },
          );
        }
        return Container(
          key: ValueKey(index),
          color: Colors.primaries[index % Colors.primaries.length],
          height: height,
          child: Center(
            child: Text('$index'),
          ),
        );
      }),
    );
  };
}
