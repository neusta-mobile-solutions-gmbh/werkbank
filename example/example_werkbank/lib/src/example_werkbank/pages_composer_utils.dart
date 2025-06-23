import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

extension PagesComposerUtils on UseCaseComposer {
  void withScaffold({required String title}) {
    wrapUseCase((context, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            title,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
        body: child,
      );
    });
  }

  void withSafeArea() {
    final horizontalSafeAreaKnob = knobs.doubleSlider(
      'Horizontal Safe Area',
      max: 250,
      initialValue: 0,
    );

    final verticalSafeAreaKnob = knobs.doubleSlider(
      'Vertical Safe Area',
      max: 250,
      initialValue: 0,
    );

    wrapUseCase(
      (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            padding:
                MediaQuery.paddingOf(context) +
                EdgeInsets.symmetric(
                  horizontal: horizontalSafeAreaKnob.value,
                  vertical: verticalSafeAreaKnob.value,
                ),
          ),
          child: child,
        );
      },
      layer: WrappingLayer.surrounding,
    );
  }
}
