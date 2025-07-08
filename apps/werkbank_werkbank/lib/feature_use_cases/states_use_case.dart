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

  final exampleState = c.states.register(
    'Example',
    initialValue: _SomeExampleState(
      ready: true,
      text: 'Hello, Werkbank!',
      number: 42,
    ),
  );

  final otherExampleState = c.states.register(
    'Other Example',
    initialValue: _SomeExampleState(
      ready: false,
      text: 'Other Example State',
      number: 24,
    ),
  );

  return (context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _SomeExampleComponent(
          state: exampleState.value,
          onStateChanged: (newState) {
            exampleState.value = newState;
          },
        ),
        const SizedBox(width: 20),
        _SomeExampleComponent(
          state: otherExampleState.value,
          onStateChanged: (newState) {
            otherExampleState.value = newState;
          },
        ),
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
