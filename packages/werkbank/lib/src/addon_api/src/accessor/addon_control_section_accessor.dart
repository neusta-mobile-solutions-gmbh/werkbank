import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';

/// A class that provides access to data in the [BuildContext] that is
/// available from within the widgets built by the
/// [AddonControlSection.children] of any subclass of [AddonControlSection].
///
/// To obtain an instance of this class call the static `access` field on the
/// [AddonControlSection] subclass in which the widgets you want to access
/// the data in are built.
abstract class AddonControlSectionAccessor extends AddonAccessor
    with WerkbankAppOnlyAccessor {
  const AddonControlSectionAccessor();
}
