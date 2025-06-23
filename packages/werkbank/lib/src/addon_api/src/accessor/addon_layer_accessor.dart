import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

/// A class that provides access to data in the [BuildContext] that is
/// available from within the widgets built by the [AddonLayerEntry.builder]
/// of any layer.
///
/// To obtain an instance of this class call the static `access` field on the
/// [AddonLayerEntry] subclass in which the widgets you want to access the data
/// in are built.
abstract class AddonLayerAccessor extends AddonAccessor {
  const AddonLayerAccessor();

  /// Gets the [WerkbankEnvironment] of the current addon.
  /// This is one of [WerkbankEnvironment.app] or
  /// [WerkbankEnvironment.display].
  /// This can be used by addons for example to omit certain visual overlays
  /// or similar with a [DisplayApp] widget, since they only make
  /// sense in an environment where the user interacts with
  /// the [WerkbankApp] application.
  ///
  /// The value can be assumed to be constant for the lifetime of the widget
  /// that uses it.
  /// This means that widgets that change the widgets that are built depending
  /// on its value do not need to reparent children widgets using [GlobalKey]s
  /// to prevent state loss.
  WerkbankEnvironment environmentOf(BuildContext context) {
    return WerkbankEnvironmentProvider.of(context);
  }
}
