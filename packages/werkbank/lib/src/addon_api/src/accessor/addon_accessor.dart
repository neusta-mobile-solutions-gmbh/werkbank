import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/src/accessor/addon_layer_accessor.dart';
import 'package:werkbank/src/addon_api/src/accessor/use_case_accessor_mixin.dart';
import 'package:werkbank/src/addon_api/src/addon.dart';
import 'package:werkbank/src/addon_api/src/addon_control_sections/addon_control_section.dart';
import 'package:werkbank/src/addon_api/src/addon_description.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/addon_layer_entry.dart';
import 'package:werkbank/src/addon_api/src/addon_specification.dart';
import 'package:werkbank/src/addon_api/src/addon_specifications_provider.dart';
import 'package:werkbank/src/addon_api/src/home_page_component.dart';

/// A class that provides access to data in the [BuildContext] that is
/// available from every place where the [Addon] API gives access to a
/// [BuildContext].
///
/// Classes that hold or build widgets within an addon implement a
/// static `access` field that returns an instance of this class.
///
/// These classes include subclasses of [AddonLayerEntry],
/// subclasses of [AddonControlSection], [HomePageComponent] and
/// [AddonDescription].
///
/// Subclasses of this class such as [AddonLayerAccessor] and
/// [UseCaseAccessorMixin] introduce
/// additional data that can be accessed only in specific contexts.
///
/// Make sure to use the `access` field on the class which actually builds
/// the widgets you want to access the data in. Otherwise the data might not
/// be available in the [BuildContext].
abstract class AddonAccessor {
  const AddonAccessor();

  @protected
  String get containerName;

  Never _throw() {
    throw AssertionError(
      'This method is missing dependencies from the context. '
      'Make sure to only use the methods on $containerName.access in widgets '
      'that are actually built inside $containerName. ',
    );
  }

  @protected
  T ensureNotNull<T extends Object>(T? value) {
    if (value == null) {
      _throw();
    }
    return value;
  }

  T ensureReturns<T>(T Function() function) {
    try {
      return function();
      /* TODO(lzuttermeister): Can we do this better? Ideally by including the
           original error with its stack trace. */
      // ignore: avoid_catching_errors
    } on TypeError catch (_) {
      _throw();
    }
  }

  /// Get a map from [Addon.id]s to [AddonSpecification]s for all all addons
  /// that are currently used.
  Map<String, AddonSpecification> addonsOf(BuildContext context) {
    return ensureReturns(() => AddonSpecificationsProvider.of(context));
  }
}
