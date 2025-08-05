import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/src/providers/use_case_controller_provider/use_case_controller_provider.dart';

/// Displays the use case defined controller in
/// [UseCaseControllerProvider].
class UseCaseWidgetDisplay extends StatelessWidget {
  const UseCaseWidgetDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = UseCaseControllerProvider.of(context);
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return controller.useCaseWidget(
          errorBuilder: (context, error, _) {
            return ErrorWidget(error);
          },
        );
      },
    );
  }
}
