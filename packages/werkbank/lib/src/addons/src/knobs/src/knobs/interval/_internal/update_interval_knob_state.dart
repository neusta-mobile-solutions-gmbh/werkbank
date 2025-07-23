import 'package:flutter/material.dart';
import 'package:werkbank/werkbank_old.dart';

mixin UpdateIntervalKnobState {
  ({
    NamedInterval currentInterval,
    List<NamedDouble> beginOptions,
    List<NamedDouble> endOptions,
  })
  updateIntervalKnobState({
    required Interval currentValue,
    required Interval initialValue,
    List<NamedDouble>? beginOptions,
    List<NamedDouble>? endOptions,
  }) {
    final effectiveBeginOptions = (beginOptions ?? _beginOptions)
        .where((e) => e.value < currentValue.end)
        .toList();

    final effectiveEndOptions = (endOptions ?? _endOptions)
        .where((e) => e.value > currentValue.begin)
        .toList();

    final initialBeginValueIsMissing = !effectiveBeginOptions
        .map((e) => e.value)
        .contains(initialValue.begin);
    if (initialBeginValueIsMissing) {
      effectiveBeginOptions.add(
        NamedDouble(
          '${initialValue.begin.toStringAsFixed(2)} (Initial)',
          initialValue.begin,
        ),
      );
    }

    final initialEndValueIsMissing = !effectiveEndOptions
        .map((e) => e.value)
        .contains(initialValue.end);
    if (initialEndValueIsMissing) {
      effectiveEndOptions.add(
        NamedDouble(
          '${initialValue.end.toStringAsFixed(2)} (Initial)',
          initialValue.end,
        ),
      );
    }

    final currentBeginValueIsMissing = !effectiveBeginOptions
        .map((e) => e.value)
        .contains(currentValue.begin);
    if (currentBeginValueIsMissing) {
      effectiveBeginOptions.add(
        NamedDouble(
          '${currentValue.begin.toStringAsFixed(2)} (Current)',
          currentValue.begin,
        ),
      );
    }

    final currentEndValueIsMissing = !effectiveEndOptions
        .map((e) => e.value)
        .contains(currentValue.end);
    if (currentEndValueIsMissing) {
      effectiveEndOptions.add(
        NamedDouble(
          '${currentValue.end.toStringAsFixed(2)} (Current)',
          currentValue.end,
        ),
      );
    }

    effectiveEndOptions.sort((a, b) => a.value.compareTo(b.value));
    effectiveBeginOptions.sort((a, b) => a.value.compareTo(b.value));

    final currentNamedBegin = effectiveBeginOptions.firstWhere(
      (e) => e.value == currentValue.begin,
    );

    final currentNamedEnd = effectiveEndOptions.firstWhere(
      (e) => e.value == currentValue.end,
    );

    final currentInterval = NamedInterval(
      currentNamedBegin,
      currentNamedEnd,
    );

    return (
      currentInterval: currentInterval,
      beginOptions: effectiveBeginOptions,
      endOptions: effectiveEndOptions,
    );
  }
}

List<NamedDouble> get _beginOptions => [
  .0,
  .05,
  .1,
  .2,
  .25,
  .3,
  .33,
  .4,
  .5,
  .6,
  .66,
  0.75,
  .8,
  .9,
].map((e) => NamedDouble(e.toStringAsFixed(2), e)).toList();

List<NamedDouble> get _endOptions => [
  .1,
  .2,
  .25,
  .3,
  .33,
  .4,
  .5,
  .6,
  .66,
  0.75,
  .8,
  .9,
  .95,
  1.0,
].map((e) => NamedDouble(e.toStringAsFixed(2), e)).toList();
