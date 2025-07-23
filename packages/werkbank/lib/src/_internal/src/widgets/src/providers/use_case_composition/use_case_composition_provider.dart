import 'package:flutter/material.dart';
import 'package:werkbank/src/use_case/use_case.dart';

class UseCaseCompositionProvider extends InheritedWidget {
  const UseCaseCompositionProvider({
    super.key,
    required this.composition,
    required super.child,
  });

  static UseCaseComposition compositionOf(BuildContext context) {
    return maybeCompositionOf(context)!;
  }

  static UseCaseComposition? maybeCompositionOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<UseCaseCompositionProvider>()
        ?.composition;
  }

  static UseCaseMetadata metadataOf(BuildContext context) {
    return compositionOf(context).metadata;
  }

  final UseCaseComposition composition;

  @override
  bool updateShouldNotify(UseCaseCompositionProvider oldWidget) {
    return composition != oldWidget.composition;
  }
}
