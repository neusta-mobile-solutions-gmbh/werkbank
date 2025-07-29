import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/use_case/use_case.dart';
import 'package:werkbank/src/_internal/src/widgets/src/providers/descriptor_provider.dart';
import 'package:werkbank/src/_internal/src/widgets/src/providers/use_case_controller_provider/use_case_controller_provider.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/use_case.dart';

class LocalUseCaseControllerProvider extends StatefulWidget {
  const LocalUseCaseControllerProvider({
    super.key,
    this.initialMutation,
    required this.child,
  });

  final UseCaseStateMutation? initialMutation;
  final Widget child;

  @override
  State<LocalUseCaseControllerProvider> createState() =>
      _LocalUseCaseControllerProviderState();
}

class _LocalUseCaseControllerProviderState
    extends State<LocalUseCaseControllerProvider> {
  final UseCaseController _controller = UseCaseController();
  UseCaseDescriptor? _useCase;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final newUseCase = DescriptorProvider.useCaseOf(context);
    if (newUseCase != _useCase) {
      _controller.assemble(
        newUseCase,
        context: context,
        initialMutation: widget.initialMutation,
        keepState: newUseCase.path == _useCase?.path,
      );
    }
    _useCase = newUseCase;
  }

  @override
  Widget build(BuildContext context) {
    return UseCaseControllerProvider(
      controller: _controller,
      child: widget.child,
    );
  }
}
