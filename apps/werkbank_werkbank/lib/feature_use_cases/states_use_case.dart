import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';
import 'package:werkbank_werkbank/tags.dart';

class _SomeExampleState {
  _SomeExampleState({
    required this.ready,
    required this.text,
    required this.number,
  });

  final bool ready;
  final String text;
  final double number;

  @override
  String toString() {
    return 'SomeExampleState(ready: $ready, text: $text, number: $number)';
  }
}

WidgetBuilder statesUseCase(UseCaseComposer c) {
  c
    ..tags([Tags.addon])
    ..overview.withoutThumbnail();

  final exampleState = c.states.immutable(
    'Example',
    initialValue: _SomeExampleState(
      ready: true,
      text: 'Hello, Werkbank!',
      number: 42,
    ),
  );

  final otherExampleState = c.states.immutable(
    'Other Example',
    initialValue: _SomeExampleState(
      ready: false,
      text: 'Other Example State',
      number: 24,
    ),
  );

  // ignore: unused_local_variable
  // final shouldNotWork = c.states.immutable(
  //   'Mutable',
  //   initialValue: ScrollController(),
  // );

  final textEditingControllerContainer = c.states.mutable(
    'TextEditingController',
    create: () => TextEditingController(text: 'Initial Text'),
    dispose: (controller) => controller.dispose(),
  );

  final tabControllerContainer = c.states
      .mutableWithTickerProvider<TabController>(
        'TabController',
        create: (tickerProvider) => TabController(
          length: 3,
          vsync: tickerProvider,
        ),
        dispose: (controller) => controller.dispose(),
      );

  return (context) {
    final composition = UseCase.compositionOf(context);
    final mutableStates = composition.states.mutable;
    final immutableStates = composition.states.immutable;
    return Column(
      spacing: 24,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          spacing: 24,
          children: [
            _SomeExampleComponent(
              state: exampleState.value,
              onStateChanged: (newState) {
                exampleState.value = newState;
              },
            ),
            _SomeExampleComponent(
              state: otherExampleState.value,
              onStateChanged: (newState) {
                otherExampleState.value = newState;
              },
            ),
          ],
        ),
        SizedBox(
          width: 256,
          child: WTextField(
            controller: textEditingControllerContainer.value,
          ),
        ),
        TabBar(
          controller: tabControllerContainer.value,
          tabs: const [
            Tab(text: 'Tab 1'),
            Tab(text: 'Tab 2'),
            Tab(text: 'Tab 3'),
          ],
        ),
        const SizedBox(height: 40),
        Text('Mutable States: ${mutableStates.length}'),
        Text('Immutable States: ${immutableStates.length}'),
      ],
    );
  };
}

class _SomeExampleComponent extends StatelessWidget {
  const _SomeExampleComponent({
    required this.state,
    required this.onStateChanged,
  });

  final _SomeExampleState state;
  final ValueChanged<_SomeExampleState> onStateChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Ready: ${state.ready}'),
        Text('Text: ${state.text}'),
        Text('Number: ${state.number}'),

        WIconButton(
          icon: const Icon(WerkbankIcons.plusSquare),
          onPressed: () {
            final newState = _SomeExampleState(
              ready: !state.ready,
              text: state.text,
              number: state.number + 1,
            );
            onStateChanged(newState);
          },
        ),
      ],
    );
  }
}
