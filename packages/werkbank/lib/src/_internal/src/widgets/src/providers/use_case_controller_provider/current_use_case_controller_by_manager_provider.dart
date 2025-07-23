import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/use_case/use_case.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';

/// Provides the current [UseCaseController] using the
/// [UseCaseControllerManager].
class CurrentUseCaseControllerByManagerProvider extends StatefulWidget {
  const CurrentUseCaseControllerByManagerProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<CurrentUseCaseControllerByManagerProvider> createState() =>
      _CurrentUseCaseControllerByManagerProviderState();
}

class _CurrentUseCaseControllerByManagerProviderState
    extends State<CurrentUseCaseControllerByManagerProvider> {
  String? _path;
  late UseCaseControllerSubscription _useCaseControllerSubscription;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final useCase = DescriptorProvider.useCaseOf(context);
    final newPath = useCase.path;
    if (_path == null) {
      _useCaseControllerSubscription =
          UseCaseControllerManager.subscribeToCurrentOf(context);
    } else if (_path != newPath) {
      _useCaseControllerSubscription.cancel();
      _useCaseControllerSubscription =
          UseCaseControllerManager.subscribeToCurrentOf(context);
    }
    _path = newPath;
  }

  @override
  void dispose() {
    _useCaseControllerSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UseCaseControllerProvider(
      controller: _useCaseControllerSubscription.controller,
      child: widget.child,
    );
  }
}
