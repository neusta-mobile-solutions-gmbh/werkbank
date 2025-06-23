import 'package:flutter/material.dart';

/// This is a temporary workaround for easily adding a disabled state to an
/// input widget. This should be removed, once proper disabled states have been
/// implemented.
///
/// {@category Werkbank Components}
class WTempDisabler extends StatelessWidget {
  const WTempDisabler({
    super.key,
    required this.enabled,
    required this.child,
  });

  final bool enabled;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: child,
      ),
    );
  }
}
