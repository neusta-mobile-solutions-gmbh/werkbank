import 'package:flutter/material.dart';

class Tags {
  /// A component used to change some value
  static const input = 'input';
  static const button = 'button';

  /// A component used to display some static information.
  static const display = 'display';

  /// A base component which is usually not used directly but
  /// to build other components.
  static const base = 'base';

  /// A component that is made to contain some other component or components.
  /// This usually excludes trivial widgets like [Text] or [Icon].
  static const container = 'container';

  static const shader = 'shader';
  static const hotReload = 'hot reload';
  static const feature = 'feature';
  static const addon = 'addon';
  static const knobs = 'knobs';
  static const useCase = 'use case';
  static const notificationFeature = 'notification';
}
