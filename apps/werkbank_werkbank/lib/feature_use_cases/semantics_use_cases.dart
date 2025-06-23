import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WidgetBuilder nestedSemanticsUseCase(UseCaseComposer c) {
  return (context) {
    return Semantics(
      container: true,
      label: 'Hello World',
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MergeSemantics(
              child: Text(
                'Hello',
                style: context.werkbankTextTheme.detail.copyWith(
                  color: context.werkbankColorScheme.text,
                ),
              ),
            ),
            MergeSemantics(
              child: Text(
                'World',
                style: context.werkbankTextTheme.detail.copyWith(
                  color: context.werkbankColorScheme.text,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  };
}

WidgetBuilder attributedStringsUseCase(UseCaseComposer c) {
  return (context) {
    return Text.rich(
      style: context.werkbankTextTheme.detail.copyWith(
        color: context.werkbankColorScheme.text,
      ),
      const TextSpan(
        children: [
          TextSpan(text: 'Hello '),
          TextSpan(
            text: 'Welt',
            locale: Locale('de'),
          ),
          TextSpan(
            text: '!',
            spellOut: true,
          ),
        ],
      ),
    );
  };
}

WidgetBuilder materialComponentsUseCase(UseCaseComposer c) {
  final switchValue = c.knobs.boolean(
    'Switch Value',
    initialValue: false,
  );
  final sliderValue = c.knobs.doubleSlider(
    'Slider Value',
    initialValue: 0.5,
  );
  return (context) {
    final components = [
      Switch(
        value: switchValue.value,
        onChanged: switchValue.setValue,
      ),
      ElevatedButton(
        onPressed: () {},
        child: const Text('Elevated Button'),
      ),
      Slider(
        value: sliderValue.value,
        onChanged: sliderValue.setValue,
      ),
      TextField(
        style: context.werkbankTextTheme.detail.copyWith(
          color: context.werkbankColorScheme.text,
        ),
        decoration: InputDecoration(
          labelText: 'Text Field',
          labelStyle: context.werkbankTextTheme.detail.copyWith(
            color: context.werkbankColorScheme.text,
          ),
        ),
      ),
    ];
    return Wrap(
      children: [
        for (final component in components) component,
      ],
    );
  };
}
