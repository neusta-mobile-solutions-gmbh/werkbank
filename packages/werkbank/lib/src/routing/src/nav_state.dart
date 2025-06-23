import 'package:meta/meta.dart';
import 'package:werkbank/werkbank.dart';

@immutable
sealed class NavState {}

class HomeNavState extends NavState {
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HomeNavState && runtimeType == other.runtimeType;

  @override
  int get hashCode => (HomeNavState).hashCode;
}

sealed class DescriptorNavState extends NavState {
  DescriptorNavState();

  /// Creates either a [ParentOverviewNavState] or a [ViewUseCaseNavState]
  /// depending on whether the [descriptor] is a [ParentDescriptor] or a
  /// [UseCaseDescriptor].
  factory DescriptorNavState.overviewOrView(Descriptor descriptor) =>
      switch (descriptor) {
        ParentDescriptor() => ParentOverviewNavState(descriptor: descriptor),
        UseCaseDescriptor() => ViewUseCaseNavState(descriptor: descriptor),
      };

  Descriptor get descriptor;
}

sealed class OverviewNavState extends DescriptorNavState {}

sealed class UseCaseNavState extends DescriptorNavState {
  @override
  UseCaseDescriptor get descriptor;
}

class ParentOverviewNavState implements OverviewNavState {
  ParentOverviewNavState({required this.descriptor});

  @override
  final ParentDescriptor descriptor;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParentOverviewNavState &&
          runtimeType == other.runtimeType &&
          descriptor == other.descriptor;

  @override
  int get hashCode => descriptor.hashCode;
}

class UseCaseOverviewNavState implements OverviewNavState, UseCaseNavState {
  UseCaseOverviewNavState({required this.descriptor, required this.config});

  @override
  final UseCaseDescriptor descriptor;
  final UseCaseOverviewConfig config;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UseCaseOverviewNavState &&
          runtimeType == other.runtimeType &&
          descriptor == other.descriptor &&
          config == other.config;

  @override
  int get hashCode => Object.hash(descriptor, config);
}

class ViewUseCaseNavState implements UseCaseNavState {
  ViewUseCaseNavState({required this.descriptor, this.initialMutation});

  @override
  final UseCaseDescriptor descriptor;
  final UseCaseStateMutation? initialMutation;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ViewUseCaseNavState &&
          runtimeType == other.runtimeType &&
          descriptor == other.descriptor &&
          initialMutation == other.initialMutation;

  @override
  int get hashCode => Object.hash(descriptor, initialMutation);
}
