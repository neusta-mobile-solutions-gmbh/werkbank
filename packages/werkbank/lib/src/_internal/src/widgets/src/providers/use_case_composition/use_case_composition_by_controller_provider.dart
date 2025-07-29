import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/src/providers/use_case_composition/use_case_composition_provider.dart';
import 'package:werkbank/src/_internal/src/widgets/src/providers/use_case_controller_provider/use_case_controller_provider.dart';

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
