import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/use_case/use_case.dart';

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
        return KeyedSubtree(
          key: UseCase.key,
          child: controller.useCaseWidget(
            errorBuilder: (context, error, _) {
              return ErrorWidget(error);
            },
          ),
        );
      },
    );
  }
}
