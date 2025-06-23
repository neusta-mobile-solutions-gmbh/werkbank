import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

WerkbankFolder get wrappingFolder => WerkbankFolder(
  name: 'Wrapping',
  builder: (c) {
    final horizontalSafeAreaKnob = c.knobs.doubleSlider(
      'Horizontal Safe Area',
      max: 250,
      initialValue: 0,
    );

    final verticalSafeAreaKnob = c.knobs.doubleSlider(
      'Vertical Safe Area',
      max: 250,
      initialValue: 0,
    );

    c.wrapUseCase(
      (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            padding: EdgeInsets.symmetric(
              horizontal: horizontalSafeAreaKnob.value,
              vertical: verticalSafeAreaKnob.value,
            ),
          ),
          child: child,
        );
      },
    );
  },
  children: [
    WerkbankUseCase(
      name: 'Page',
      builder: _pageUseCase,
    ),
    WerkbankUseCase(
      name: 'Box',
      builder: _boxUseCase,
    ),
  ],
);

WidgetBuilder _pageUseCase(UseCaseComposer c) {
  return (context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AppBar'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: const SizedBox.expand(),
    );
  };
}

WidgetBuilder _boxUseCase(UseCaseComposer c) {
  c
    ..wrapUseCase(
      (context, child) {
        return ColoredBox(
          color: Colors.lightGreen,
          child: child,
        );
      },
      layer: WrappingLayer.surrounding,
    )
    ..wrapUseCase((context, child) {
      return Container(
        color: Colors.yellow,
        padding: const EdgeInsets.all(16),
        child: child,
      );
    });
  return (context) {
    return ColoredBox(
      color: Colors.amber,
      child: SafeArea(
        child: Container(
          color: Colors.redAccent,
          width: 100,
          height: 100,
        ),
      ),
    );
  };
}
