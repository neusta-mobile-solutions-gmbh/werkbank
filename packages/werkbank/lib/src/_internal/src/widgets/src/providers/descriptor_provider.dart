import 'package:flutter/material.dart';

/// Provides a [ChildDescriptor].
///
/// Which descriptor is provided by this widget depends on the context.
/// Within a [UseCasePage] for example this is
/// widget provides the [UseCaseDescriptor] that is currently being displayed.
/// If there are route transitions, this means that there may be two widget
/// trees with different [UseCaseDescriptor]s at the same time.
/// Outside of the [UseCasePage] this is usually the [ChildDescriptor] which
/// was selected in the interface.
///
/// This is meant for internal use only.
/// Implementers of addons should use
/// [UseCaseAccessorMixin.useCaseOf] instead.
class DescriptorProvider extends InheritedWidget {
  const DescriptorProvider({
    required this.descriptor,
    required super.child,
    super.key,
  });

  static Descriptor? maybeDescriptorOf(BuildContext context) {
    final descriptor = context
        .dependOnInheritedWidgetOfExactType<DescriptorProvider>()!
        .descriptor;
    return descriptor;
  }

  static UseCaseDescriptor? maybeUseCaseOf(BuildContext context) {
    final descriptor = maybeDescriptorOf(context);
    return switch (descriptor) {
      UseCaseDescriptor() => descriptor,
      null ||
      RootDescriptor() ||
      FolderDescriptor() ||
      ComponentDescriptor() => null,
    };
  }

  static UseCaseDescriptor useCaseOf(BuildContext context) {
    return maybeUseCaseOf(context)!;
  }

  final Descriptor? descriptor;

  @override
  bool updateShouldNotify(covariant DescriptorProvider oldWidget) {
    return descriptor != oldWidget.descriptor;
  }
}
