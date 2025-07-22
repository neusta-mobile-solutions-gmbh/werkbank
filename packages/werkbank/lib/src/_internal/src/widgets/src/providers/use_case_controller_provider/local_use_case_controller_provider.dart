import 'package:flutter/material.dart';

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
