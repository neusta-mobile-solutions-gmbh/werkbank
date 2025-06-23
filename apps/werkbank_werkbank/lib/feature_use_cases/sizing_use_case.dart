import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/feature_use_cases/constraints_visualizer.dart';
import 'package:werkbank_werkbank/tags.dart';

WidgetBuilder sizingUseCase(UseCaseComposer c) {
  c
    ..description(
      'A use case to make it easy to show the effects of the sizing addon '
      'on the constraints passed to the widget.',
    )
    ..tags([Tags.addon])
    ..overview.minimumSize(width: 400, height: 400)
    ..constraints.overview();

  final expandHorizontally = c.knobs.boolean(
    'Expand Horizontally',
    initialValue: false,
  );
  final expandVertically = c.knobs.boolean(
    'Expand Vertically',
    initialValue: false,
  );

  c.constraints
    ..initialConstraints(
      const BoxConstraints(),
      viewLimitedMaxWidth: false,
      viewLimitedMaxHeight: false,
    )
    ..devicePresets()
    ..presetConstraints(
      'With Min and Max',
      const BoxConstraints(
        minWidth: _minLimit,
        maxWidth: _maxLimit,
        minHeight: _minLimit,
        maxHeight: _maxLimit,
      ),
    );

  return (context) {
    return ConstraintsVisualizer(
      expandHorizontally: expandHorizontally.value,
      expandVertically: expandVertically.value,
    );
  };
}

const _minLimit = 340.0;
const _maxLimit = 650.0;

WidgetBuilder limitedMinUseCase(UseCaseComposer c) {
  c.constraints.supported(
    const BoxConstraints(
      minWidth: _minLimit,
      minHeight: _minLimit,
    ),
  );
  return sizingUseCase(c);
}

WidgetBuilder limitedMaxUseCase(UseCaseComposer c) {
  c.constraints.supported(
    const BoxConstraints(
      maxWidth: _maxLimit,
      maxHeight: _maxLimit,
    ),
  );
  return sizingUseCase(c);
}

WidgetBuilder limitedMinAndMaxUseCase(UseCaseComposer c) {
  c.constraints.supported(
    const BoxConstraints(
      minWidth: _minLimit,
      maxWidth: _maxLimit,
      minHeight: _minLimit,
      maxHeight: _maxLimit,
    ),
  );
  return sizingUseCase(c);
}
