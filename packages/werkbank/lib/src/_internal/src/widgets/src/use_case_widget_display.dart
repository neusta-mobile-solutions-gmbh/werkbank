import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/werkbank.dart';

/// Displays the use case defined controller in
/// [UseCaseControllerProvider].
class UseCaseWidgetDisplay extends StatelessWidget {
  const UseCaseWidgetDisplay({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = UseCaseControllerProvider.of(context);
    return KeyedSubtree(
      key: UseCase.key,
      child: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return controller.useCaseWidget(
            errorBuilder: (context, error, _) {
              return ErrorWidget(error);
            },
          );
        },
      ),
    );
  }
}
