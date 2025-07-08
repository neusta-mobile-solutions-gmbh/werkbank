import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/feature_use_cases/constraints_visualizer.dart';
import 'package:werkbank_werkbank/tags.dart';

const _loremIpsum = '''
Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus est Lorem ipsum dolor sit amet.
''';

WerkbankFolder get wNotificationComponent => WerkbankFolder(
  name: 'Notification',
  builder: (c) {
    c
      ..tags([Tags.feature, Tags.notificationFeature])
      ..description('''
# Notifications

Werkbank has a notification system that allows you to dispatch notifications.
It can be used by the werkbank itself or by addons or by the user writing a use case.
''');
  },
  children: [
    WerkbankComponent(
      name: 'WNotification',
      useCases: [
        WerkbankUseCase(
          name: 'text',
          builder: wNotificationTextUseCase,
        ),
        WerkbankUseCase(
          name: 'widgets',
          builder: wNotificationWidgetsUseCase,
        ),
      ],
    ),
    WerkbankUseCase(
      name: 'WNotificationInAndOut',
      builder: wNotificationInAndOutUseCase,
    ),
    WerkbankUseCase(
      name: 'WDraggableConstraintedBox',
      builder: wDraggableConstraintedBoxUseCase,
    ),
  ],
);

WidgetBuilder wNotificationTextUseCase(UseCaseComposer c) {
  c.constraints
    ..initialConstraints(const BoxConstraints(maxWidth: 400))
    ..overview();
  c.overview.minimumSize(width: 250);
  final title = c.knobs.string('Title', initialValue: 'The Title');
  final counter = c.knobs.nullable.intSlider(
    'Counter',
    min: 1,
    initialValue: 100,
  );

  final content = c.knobs.nullable.string(
    'Content',
    initialValue: _loremIpsum,
  );

  final source = c.knobs.nullable.string('Source', initialValue: 'Source');

  final animation = c.knobs.animationController(
    'Visibility Animation',
    initialDuration: const Duration(seconds: 3),
  );

  return (context) {
    return WNotification(
      counter: counter.value,
      onDismiss: () {},
      onPauseVisibility: () {},
      onContinueVisibility: () {},
      onKeepVisible: () {},
      visibilityAnimation: animation.value,
      notification: WerkbankNotification.text(
        title: title.value,
        content: content.value,
        source: source.value,
      ),
    );
  };
}

enum _HeightOptions {
  maxHeight,
  headHeight,
  none,
}

WidgetBuilder wNotificationWidgetsUseCase(UseCaseComposer c) {
  c.constraints
    ..initialConstraints(const BoxConstraints(maxWidth: 400))
    ..overview();
  c.overview.minimumSize(width: 250);

  final counter = c.knobs.nullable.intSlider(
    'Counter',
    min: 1,
    initialValue: 100,
  );

  final withContent = c.knobs.boolean('With Content', initialValue: true);

  final headHeight = c.knobs.doubleSlider(
    'Head Height',
    initialValue: 30,
    max: 200,
  );

  final heightOption = c.knobs.customDropdown(
    'HeightOption',
    initialValue: _HeightOptions.none,
    options: _HeightOptions.values,
    optionLabel: (option) => option.name,
  );

  final animation = c.knobs.animationController(
    'Visibility Animation',
    initialDuration: const Duration(seconds: 3),
  );

  return (context) {
    return WNotification(
      onDismiss: () {},
      onPauseVisibility: () {},
      onContinueVisibility: () {},
      onKeepVisible: () {},
      visibilityAnimation: animation.value,
      counter: counter.value,
      notification: WerkbankNotification.widgets(
        key: const ValueKey('_'),
        buildHead: (context) => Container(
          color: Colors.red,
          height: switch (heightOption.value) {
            _HeightOptions.maxHeight => double.infinity,
            _HeightOptions.headHeight => headHeight.value,
            _HeightOptions.none => null,
          },
          child: const Text('Head'),
        ),
        buildBody: withContent.value
            ? (context) => const ColoredBox(
                color: Colors.green,
                child: Text('Content'),
              )
            : null,
      ),
    );
  };
}

WidgetBuilder wNotificationInAndOutUseCase(UseCaseComposer c) {
  final animation = c.knobs.animationController(
    'Dismiss Animation',
    initialDuration: const Duration(seconds: 3),
  );
  c.description('''
## Turn off Page Transition

To see the primary animation of WNotificationInAndOut,
you need to turn off the Werkbank page transition.

`Settings -> Page Transition -> Off.`
''');
  return (context) {
    return WNotificationInAndOut(
      dismissAnimation: animation.value,
      child: Container(
        width: 500,
        height: 200,
        color: Colors.blue,
      ),
    );
  };
}

WidgetBuilder wDraggableConstraintedBoxUseCase(UseCaseComposer c) {
  c.overview.minimumSize(width: 400, height: 400);
  final initialMaxWidth = c.knobs.doubleSlider(
    'Initial Max Width',
    initialValue: 400,
    min: 200,
    max: 600,
  );
  final minDraggableWidth = c.knobs.nullable.doubleSlider(
    'Min Draggable Width',
    initialValue: 200,
    min: 100,
    max: 300,
  );
  final initialMaxHeight = c.knobs.doubleSlider(
    'Initial Max Height',
    initialValue: 400,
    min: 200,
    max: 600,
  );
  final minDraggableHeight = c.knobs.nullable.doubleSlider(
    'Min Draggable Height',
    initialValue: 200,
    min: 100,
    max: 300,
  );
  final enableLeftBorder = c.knobs.boolean('Left Border', initialValue: true);
  final enableRightBorder = c.knobs.boolean('Right Border', initialValue: true);
  final enableTopBorder = c.knobs.boolean('Top Border', initialValue: true);
  final enableButtomBorder = c.knobs.boolean(
    'Buttom Border',
    initialValue: true,
  );
  final leftRightTickness = c.knobs.doubleSlider(
    'Left Right Thickness',
    initialValue: 8,
    max: 20,
  );

  final topBottomTickness = c.knobs.doubleSlider(
    'Top Bottom Thickness',
    initialValue: 8,
    max: 20,
  );

  return (context) {
    final leftRight = DraggableBorders(
      initialMaxValue: initialMaxWidth.value,
      enableStartBorder: enableLeftBorder.value,
      enableEndBorder: enableRightBorder.value,
      minDraggableValue: minDraggableWidth.value,
      thickness: leftRightTickness.value,
      needsDoubleAcceleration: true,
    );
    final topBottom = DraggableBorders(
      initialMaxValue: initialMaxHeight.value,
      enableStartBorder: enableTopBorder.value,
      enableEndBorder: enableButtomBorder.value,
      minDraggableValue: minDraggableHeight.value,
      thickness: topBottomTickness.value,
      needsDoubleAcceleration: true,
    );
    return WDraggableConstrainedBox(
      leftRight: leftRight,
      topBottom: topBottom,
      child: const ConstraintsVisualizer(
        expandHorizontally: false,
        expandVertically: false,
      ),
    );
  };
}
