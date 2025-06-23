import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/wrapping/src/_internal/wrapping_state_entry.dart';
import 'package:werkbank/werkbank.dart';

/// An enum that defines where in the use case the wrapping should be applied.
enum WrappingLayer {
  /// The widget will be wrapped around the use case but further outside
  /// than [fitted] would.
  ///
  /// This means it will NOT be affected for example by the constraints from the
  /// [ConstraintsAddon] or by moving the viewport using the [ViewerAddon].
  surrounding,

  /// The widget will be wrapped closely around the use case.
  ///
  /// This means it will be affected for example by the constraints from the
  /// [ConstraintsAddon] or by moving the viewport using the [ViewerAddon].
  fitted,
}

extension WrappingComposerExtension on UseCaseComposer {
  /// Wraps the widget built inside the [builder] around use case.
  ///
  /// The provided [layer] defines where the widget will be wrapped.
  /// See [WrappingLayer.surrounding] and [WrappingLayer.fitted] for the
  /// differences.
  /// The default is [WrappingLayer.fitted].
  ///
  /// Using this within the [UseCaseBuilder] of a [WerkbankUseCase]
  /// and with the default [WrappingLayer.fitted] layer is not
  /// particularly useful since the widget could just as well be wrapped around
  /// the widget returned by the [WidgetBuilder].
  ///
  /// However when used inside a [UseCaseMetadataBuilder] within a
  /// [WerkbankSections], [WerkbankFolder], or [WerkbankComponent]
  /// this will be wrapped around every use case contained within.
  ///
  /// Using the [WrappingLayer.surrounding] layer also allows you to wrap the
  /// use case with widgets that are not affected for example
  /// by the constraints of the [ConstraintsAddon] or by moving the viewport
  /// using the [ViewerAddon].
  ///
  /// The [builder] will be rebuilt whenever the [WidgetBuilder] from the
  /// use case is rebuilt.
  /// This means it is allowed to use for example the values of knobs
  /// from the [KnobsAddon] without a [ListenableBuilder] that listens to the
  /// knob.
  ///
  /// Like inside of [WidgetBuilder] from the use case the static methods on
  /// [UseCase] can be used inside the [builder].
  ///
  /// If this method is called multiple times, later calls will be nested
  /// within the widgets from earlier calls.
  ///
  /// This means [UseCaseComposer.addLateExecutionCallback] can be
  /// used to ensure that the widgets are nested more deeply.
  void wrapUseCase(
    WrapperBuilder builder, {
    WrappingLayer layer = WrappingLayer.fitted,
  }) {
    getTransientStateEntry<WrappingStateEntry>().addWrapper(
      builder,
      layer: layer,
    );
  }
}
