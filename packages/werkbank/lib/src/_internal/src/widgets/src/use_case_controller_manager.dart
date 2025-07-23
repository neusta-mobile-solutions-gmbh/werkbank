import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/routing/routing.dart';
import 'package:werkbank/src/_internal/src/use_case/use_case.dart';
import 'package:werkbank/src/routing/routing.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/use_case.dart';
import 'package:werkbank/src/utils/utils.dart';
import 'package:werkbank/src/widgets/widgets.dart';

class UseCaseControllerManager extends StatefulWidget {
  const UseCaseControllerManager({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  State<UseCaseControllerManager> createState() =>
      _UseCaseControllerManagerState();

  static UseCaseComposition? currentCompositionOf(
    BuildContext context,
  ) {
    return context
        .dependOnInheritedWidgetOfExactType<
          _InheritedCurrentUseCaseComposition
        >()!
        .currentComposition;
  }

  static UseCaseControllerSubscription subscribeToCurrentOf(
    BuildContext context,
  ) {
    return context
        .findAncestorStateOfType<_UseCaseControllerManagerState>()!
        .subscribeToCurrent();
  }
}

class _UseCaseControllerManagerState extends State<UseCaseControllerManager> {
  final Map<String, _SubscriptionManager> _subscriptionManagersByPath = {};

  String? currentPath;

  late RootDescriptor rootDescriptor;

  UseCaseControllerSubscription subscribeToCurrent() {
    assert(
      currentPath != null,
      'Cannot subscribe to current controller if there is no current use case.',
    );
    // The subscription manager is already created in didChangeDependencies.
    return _subscriptionManagersByPath[currentPath]!.subscribe();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // We need to reassemble the controllers, since the [RootDescriptor] may
    // have changed.
    // But also, if a [UseCaseStateEntry] introduces a dependency to an
    // inherited widget in its prepareForBuild method, we need to make sure
    // that the controller is assembled after the inherited widget is updated.
    _update();
  }

  void _update() {
    final useCase = switch (NavStateProvider.of(context)) {
      HomeNavState() => null,
      ParentOverviewNavState() => null,
      UseCaseOverviewNavState() => null,
      ViewUseCaseNavState(:final descriptor) => descriptor,
    };
    final newCurrentPath = useCase?.path;
    if (newCurrentPath != currentPath) {
      setState(() {
        currentPath = newCurrentPath;
        if (newCurrentPath != null) {
          (_subscriptionManagersByPath[newCurrentPath] ??= _SubscriptionManager(
            this,
            newCurrentPath,
          )).resetController(useCase!);
        }
      });
    }
    rootDescriptor = WerkbankAppInfo.rootDescriptorOf(context);
    for (final subscriptionManger in _subscriptionManagersByPath.values) {
      subscriptionManger.reassembleControllers(context);
    }
  }

  void removeSubscriptionManager(_SubscriptionManager subscriptionManager) {
    _subscriptionManagersByPath.remove(subscriptionManager.path);
  }

  @override
  void dispose() {
    for (final subscriptionManager in _subscriptionManagersByPath.values) {
      subscriptionManager.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentController =
        _subscriptionManagersByPath[currentPath]?.currentController;
    return ListenableBuilder(
      listenable: currentController ?? Listenable.merge([]),
      builder: (context, _) {
        return _InheritedCurrentUseCaseComposition(
          currentComposition: currentController?.currentComposition,
          child: widget.child,
        );
      },
    );
  }
}

class _SubscriptionManager
    with SingleAttachmentMixin<UseCaseControllerSubscription> {
  _SubscriptionManager(this._state, this.path);

  UseCaseControllerSubscription? get _currentSubscription => entity;
  final Set<UseCaseControllerSubscription> _oldSubscriptions = {};
  final _UseCaseControllerManagerState _state;
  UseCaseController? currentController;
  final String path;

  void resetController(UseCaseDescriptor useCase) {
    if (_currentSubscription == null) {
      currentController?.dispose();
    } else {
      _oldSubscriptions.add(_currentSubscription!);
      detach(_currentSubscription!);
    }
    currentController = UseCaseController();
  }

  UseCaseControllerSubscription subscribe() {
    final subscription = UseCaseControllerSubscription._(
      this,
      currentController!,
    );
    attach(subscription);
    return subscription;
  }

  void cancelSubscription(UseCaseControllerSubscription subscription) {
    // If resetController was called, the subscription is already detached.
    // However if the subscription is replaced by a new one, the controller
    // will have stayed the same.
    // And since there can only be one current subscription, this one must be
    // detached by the end of the frame the new subscription was made in.
    if (subscription.controller == currentController) {
      detach(subscription);
    } else {
      subscription.controller.dispose();
      final wasRemoved = _oldSubscriptions.remove(subscription);
      assert(
        wasRemoved,
        'Subscription was not found in the old subscriptions.',
      );
    }
    if (_oldSubscriptions.isEmpty &&
        _currentSubscription == null &&
        _state.currentPath != path) {
      _state.removeSubscriptionManager(this);
      dispose();
    }
  }

  void reassembleControllers(BuildContext context) {
    final controllers = [
      ..._oldSubscriptions.map(
        (subscription) => subscription.controller,
      ),
      if (currentController != null) currentController!,
    ];
    for (final controller in controllers) {
      final useCase = _state.rootDescriptor.maybeFromPath(path);
      if (useCase is! UseCaseDescriptor) {
        // The paths may have changes such that a path that previously
        // resolved to a use case now resolves to something else.
        // In that case we cannot reassemble of course.
        // Hopefully all subscribers also cancel their subscriptions soon,
        // so that the controller can be disposed.
        continue;
      }
      controller.assemble(
        useCase,
        context: context,
      );
    }
  }

  void dispose() {
    for (final subscription in _oldSubscriptions) {
      subscription.controller.dispose();
    }
    currentController?.dispose();
    currentController = null;
  }
}

class UseCaseControllerSubscription {
  UseCaseControllerSubscription._(this._manager, this.controller);

  final _SubscriptionManager _manager;
  final UseCaseController controller;

  void cancel() {
    _manager.cancelSubscription(this);
  }
}

class _InheritedCurrentUseCaseComposition extends InheritedWidget {
  const _InheritedCurrentUseCaseComposition({
    required this.currentComposition,
    required super.child,
  });

  final UseCaseComposition? currentComposition;

  @override
  bool updateShouldNotify(
    covariant _InheritedCurrentUseCaseComposition oldWidget,
  ) {
    return currentComposition != oldWidget.currentComposition;
  }
}
