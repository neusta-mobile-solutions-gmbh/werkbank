import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class UseCaseCompositionByControllerProvider extends StatelessWidget {
  const UseCaseCompositionByControllerProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final controller = UseCaseControllerProvider.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return UseCaseCompositionProvider(
          composition: controller.currentComposition!,
          child: child,
        );
      },
    );
  }
}
