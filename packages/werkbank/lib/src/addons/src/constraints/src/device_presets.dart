import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/constraints/constraints.dart';

extension DevicePresetComposerExtension on ViewConstraintsComposer {
  void devicePresets({
    bool includeMobile = true,
    bool includeTablet = true,
    bool includeDesktop = true,
  }) {
    for (final device in _devices) {
      var exclude = false;
      exclude |= !includeMobile && device.deviceType == _DeviceType.mobile;
      exclude |= !includeTablet && device.deviceType == _DeviceType.tablet;
      exclude |= !includeDesktop && device.deviceType == _DeviceType.desktop;
      if (exclude) {
        continue;
      }

      presetSize(
        device.name,
        device.viewportSize,
      );
    }
  }
}

const _devices = <_Device>[
  // MOBILE
  _Device(
    name: 'Mobile Small',
    viewportSize: Size(360, 640),
    deviceType: _DeviceType.mobile,
  ),
  _Device(
    name: 'Mobile Medium',
    viewportSize: Size(421, 732),
    deviceType: _DeviceType.mobile,
  ),
  _Device(
    name: 'Mobile Large',
    viewportSize: Size(480, 853),
    deviceType: _DeviceType.mobile,
  ),

  // TABLET
  _Device(
    name: 'Tablet Small',
    viewportSize: Size(768, 1024),
    deviceType: _DeviceType.tablet,
  ),
  _Device(
    name: 'Tablet Medium',
    viewportSize: Size(820, 1280),
    deviceType: _DeviceType.tablet,
  ),
  _Device(
    name: 'Tablet Large',
    viewportSize: Size(1024, 1366),
    deviceType: _DeviceType.tablet,
  ),

  // DESKTOP
  _Device(
    name: 'Desktop HD',
    viewportSize: Size(1280, 720),
    deviceType: _DeviceType.desktop,
  ),
  _Device(
    name: 'Desktop HD+',
    viewportSize: Size(1600, 900),
    deviceType: _DeviceType.desktop,
  ),
  _Device(
    name: 'Desktop Full HD',
    viewportSize: Size(1920, 1080),
    deviceType: _DeviceType.desktop,
  ),
];

class _Device {
  const _Device({
    required this.name,
    required this.viewportSize,
    required this.deviceType,
  });

  final String name;
  final Size viewportSize;
  final _DeviceType deviceType;

  _Orientation get orientation => viewportSize.height > viewportSize.width
      ? _Orientation.portrait
      : _Orientation.landscape;
}

enum _DeviceType {
  mobile,
  tablet,
  desktop,
}

enum _Orientation {
  portrait,
  landscape;

  _Orientation get opposite => switch (this) {
    portrait => landscape,
    landscape => portrait,
  };
}
