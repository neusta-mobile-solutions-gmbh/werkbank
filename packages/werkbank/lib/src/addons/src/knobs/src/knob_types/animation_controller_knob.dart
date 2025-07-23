import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/knobs/src/_internal/animation_controller_status_listenable_builder.dart';
import 'package:werkbank/src/addons/src/knobs/src/_internal/verbose_animation_controller.dart';
import 'package:werkbank/werkbank_old.dart';

// We can't merge this with [AnimationControllerKnob], since
// the [ValueGuardingKnobMixin] needs a concrete implementation
// of the [value] getter.
abstract class _AnimationControllerKnobBase
    extends BuildableKnob<AnimationController> {
  _AnimationControllerKnobBase({required super.label});

  VerboseAnimationController? _verboseAnimationController;

  /// Should only be use in places where it is guaranteed that the
  /// [prepareForBuild] method has already been called.
  VerboseAnimationController get _animationController =>
      _verboseAnimationController!;

  @override
  AnimationController get value => _animationController;

  ValueNotifier<NamedDuration>? _selectedDurationNotifier;

  ValueNotifier<NamedDuration> get _selectedDuration =>
      _selectedDurationNotifier!;
}

class AnimationControllerKnob extends _AnimationControllerKnobBase
    with ValueGuardingKnobMixin<AnimationController> {
  AnimationControllerKnob({
    required super.label,
    required this.initialValue,
    required this.initialDuration,
    required this.durationOptions,
  });

  final double initialValue;
  final Duration initialDuration;
  final Set<NamedDuration> durationOptions;

  @override
  void prepareForBuild(BuildContext context) {
    super.prepareForBuild(context);
    _selectedDurationNotifier = ValueNotifier(_initialNamedDuration);
    _verboseAnimationController = VerboseAnimationController(
      vsync: TickerProviderProvider.of(context),
      duration: _selectedDuration.value.duration,
      value: initialValue,
    );
  }

  void _updateSelectedDuration(NamedDuration namedDuration) {
    _selectedDuration.value = namedDuration;
    _animationController.duration = namedDuration.duration;
  }

  NamedDuration get _initialNamedDuration => NamedDuration(
    'Initial',
    initialDuration,
  );

  @override
  KnobSnapshot createSnapshot() => AnimationControllerKnobSnapshot(
    value: _animationController.value,
    status: value.status,
    isAnimating: _animationController.isAnimating,
    selectedDuration: _selectedDuration.value,
  );

  @override
  void tryLoadSnapshot(KnobSnapshot snapshot) {
    if (snapshot is AnimationControllerKnobSnapshot) {
      _selectedDuration.value = snapshot.selectedDuration;
      _animationController
        ..duration = snapshot.selectedDuration.duration
        ..value = snapshot.value;

      if (snapshot.isAnimating) {
        // the animationController-status can be forward or reverse.
        // However, this does not mean that the animation is currently
        // running. Therefore, we need to check isAnimating,
        // before we (re)-start it.
        switch (snapshot.status) {
          case AnimationStatus.forward:
            _animationController.forward();
          case AnimationStatus.reverse:
            _animationController.reverse();
          case AnimationStatus.completed:
          case AnimationStatus.dismissed:
            break;
        }
      }
    }
  }

  @override
  void resetToInitial() {
    _animationController.value = initialValue;
    _updateSelectedDuration(_initialNamedDuration);
  }

  List<NamedDuration> get _allDurationOptionsSorted => ([
    ...durationOptions,
    _initialNamedDuration,
  ]..sort());

  @override
  late final contentChangedListenable = Listenable.merge([
    value,
    _selectedDuration,
  ]);

  @override
  void dispose() {
    _selectedDurationNotifier?.dispose();
    _verboseAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WControlItem(
      title: Text(label),
      control: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              AnimationControllerStatusListenableBuilder(
                animationController: _animationController,
                builder: (context, child) {
                  final isAnimating = _animationController.isAnimating;
                  return WIconButton(
                    onPressed: () {
                      if (_animationController.value == 1) {
                        _animationController.forward(from: 0);
                      }

                      if (isAnimating) {
                        _animationController.stop();
                      } else {
                        _animationController.forward();
                      }
                    },
                    icon: Icon(
                      isAnimating ? WerkbankIcons.pause : WerkbankIcons.play,
                    ),
                  );
                },
              ),
              const SizedBox(width: 2),
              Expanded(
                child: AnimatedBuilder(
                  animation: value,
                  builder: (context, child) {
                    return WSlider(
                      value: value.value,
                      onChanged: (value) {
                        this.value.value = value;
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ListenableBuilder(
            listenable: _selectedDuration,
            builder: (context, _) => WDropdown<NamedDuration>(
              value: _selectedDuration.value,
              onChanged: _updateSelectedDuration,
              items: [
                for (final durationOption in _allDurationOptionsSorted)
                  WDropdownMenuItem(
                    value: durationOption,
                    child: Text(durationOption.nameWithMillis()),
                  ),
              ],
            ),
          ),
        ],
      ),
      layout: ControlItemLayout.spacious,
    );
  }
}

class AnimationControllerKnobSnapshot extends KnobSnapshot {
  const AnimationControllerKnobSnapshot({
    required this.value,
    required this.status,
    required this.isAnimating,
    required this.selectedDuration,
  });

  final double value;
  final AnimationStatus status;
  final bool isAnimating;
  final NamedDuration selectedDuration;
}
