import 'package:flutter/material.dart';

class AddonSpecificationsProvider extends StatelessWidget {
  const AddonSpecificationsProvider({
    super.key,
    required this.child,
  });

  static Map<String, AddonSpecification> of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<_InheritedAddonSpecifications>();
    assert(result != null, 'No AddonSpecificationsProvider found in context');
    return result!.specifications;
  }

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final addons = AddonConfigProvider.addonsOf(context);
    return _InheritedAddonSpecifications(
      specifications: {
        for (final addon in addons)
          addon.id: AddonSpecification(
            id: addon.id,
            description: addon.buildDescription(context),
          ),
      },
      child: child,
    );
  }
}

class _InheritedAddonSpecifications extends InheritedWidget {
  const _InheritedAddonSpecifications({
    required this.specifications,
    required super.child,
  });

  final Map<String, AddonSpecification> specifications;

  @override
  bool updateShouldNotify(_InheritedAddonSpecifications oldWidget) {
    return oldWidget.specifications != specifications;
  }
}
