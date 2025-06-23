import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/werkbank.dart';

class ViewConstraintsSelector extends StatefulWidget {
  const ViewConstraintsSelector({
    super.key,
    required this.constraintsComposition,
  });

  final ConstraintsComposition constraintsComposition;

  @override
  State<ViewConstraintsSelector> createState() =>
      _ViewConstraintsSelectorState();
}

class _ViewConstraintsSelectorState extends State<ViewConstraintsSelector> {
  final TextEditingController minWidthController = TextEditingController();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController minHeightController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();

  final minWidthFocusNode = FocusNode();
  final maxWidthFocusNode = FocusNode();
  final minHeightFocusNode = FocusNode();
  final maxHeightFocusNode = FocusNode();

  TextEditingController controllerFor(ViewConstraintsParameter parameter) {
    return switch (parameter) {
      ViewConstraintsParameter.minWidth => minWidthController,
      ViewConstraintsParameter.maxWidth => maxWidthController,
      ViewConstraintsParameter.minHeight => minHeightController,
      ViewConstraintsParameter.maxHeight => maxHeightController,
    };
  }

  FocusNode focusNodeFor(ViewConstraintsParameter parameter) {
    return switch (parameter) {
      ViewConstraintsParameter.minWidth => minWidthFocusNode,
      ViewConstraintsParameter.maxWidth => maxWidthFocusNode,
      ViewConstraintsParameter.minHeight => minHeightFocusNode,
      ViewConstraintsParameter.maxHeight => maxHeightFocusNode,
    };
  }

  late ValueNotifier<ViewConstraints> viewConstraintsNotifier;

  @override
  void initState() {
    super.initState();
    viewConstraintsNotifier =
        widget.constraintsComposition.viewConstraintsNotifier;
    viewConstraintsNotifier.addListener(_updateControllers);
    for (final parameter in ViewConstraintsParameter.values) {
      final controller = controllerFor(parameter);
      final focusNode = focusNodeFor(parameter);
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          _onSubmitted(controller.text, parameter);
        }
      });
    }
    _updateControllers();
  }

  @override
  void didUpdateWidget(ViewConstraintsSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (viewConstraintsNotifier !=
        widget.constraintsComposition.viewConstraintsNotifier) {
      viewConstraintsNotifier.removeListener(_updateControllers);
      viewConstraintsNotifier =
          widget.constraintsComposition.viewConstraintsNotifier;
      viewConstraintsNotifier.addListener(_updateControllers);
      _updateControllers();
    }
  }

  void _updateControllers() {
    final viewConstraints = viewConstraintsNotifier.value;
    for (final parameter in ViewConstraintsParameter.values) {
      controllerFor(parameter).text = _constraintParameterToString(
        viewConstraints.valueOf(parameter),
      );
    }
  }

  String _constraintParameterToString(double? value) {
    if (value == null) {
      return 'view';
    }
    return value.isFinite ? value.round().toString() : 'inf';
  }

  (double?,)? _constraintParameterFromString(String value, bool isMin) {
    switch (value.toLowerCase()) {
      case 'inf':
        return (double.infinity,);
      case 'view' || '' when !isMin:
        return (null,);
      case '' when isMin:
        return (0,);
      case _:
        final parsed = double.tryParse(value);
        if (parsed == null || parsed.isNegative || !parsed.isFinite) {
          return null;
        }
        return (parsed,);
    }
  }

  void _swapAxis() {
    final viewConstraints = viewConstraintsNotifier.value;
    final newViewConstraints = ViewConstraints(
      minWidth: viewConstraints.minHeight,
      maxWidth: viewConstraints.maxHeight,
      minHeight: viewConstraints.minWidth,
      maxHeight: viewConstraints.maxWidth,
    );
    viewConstraintsNotifier.value = newViewConstraints;
    _updateControllers();
  }

  void _onSubmitted(String value, ViewConstraintsParameter parameter) {
    final viewConstraints = viewConstraintsNotifier.value;
    final parameterValueRecord = _constraintParameterFromString(
      value,
      parameter.isMin,
    );
    if (parameterValueRecord == null) {
      _updateControllers();
      return;
    }
    final parameterValue = parameterValueRecord.$1;
    var newViewConstraints = viewConstraints.copyWithParameter(
      parameter,
      parameterValue,
    );
    if (parameter.isMin) {
      newViewConstraints = newViewConstraints.normalizeWithMinPriority();
    } else {
      newViewConstraints = newViewConstraints.normalizeWithMaxPriority();
    }
    viewConstraintsNotifier.value = newViewConstraints;
    _updateControllers();
  }

  @override
  void dispose() {
    widget.constraintsComposition.viewConstraintsNotifier.removeListener(
      _updateControllers,
    );
    for (final parameter in ViewConstraintsParameter.values) {
      controllerFor(parameter).dispose();
      focusNodeFor(parameter).dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WControlItem(
      title: Text(context.sL10n.addons.constraints.controls.constraints.name),
      layout: ControlItemLayout.spacious,
      control: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: WIconButton(
                onPressed: _swapAxis,
                icon: const Icon(Icons.autorenew_rounded),
              ),
            ),
            Expanded(
              child: _ConstraintsGrid(
                minWidthController: minWidthController,
                maxWidthController: maxWidthController,
                minHeightController: minHeightController,
                maxHeightController: maxHeightController,
                minWidthFocusNode: minWidthFocusNode,
                maxWidthFocusNode: maxWidthFocusNode,
                minHeightFocusNode: minHeightFocusNode,
                maxHeightFocusNode: maxHeightFocusNode,
                onSubmitted: _onSubmitted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ConstraintsGrid extends StatelessWidget {
  const _ConstraintsGrid({
    required this.minWidthController,
    required this.maxWidthController,
    required this.minHeightController,
    required this.maxHeightController,
    required this.minWidthFocusNode,
    required this.maxWidthFocusNode,
    required this.minHeightFocusNode,
    required this.maxHeightFocusNode,
    required this.onSubmitted,
  });

  final TextEditingController minWidthController;
  final TextEditingController maxWidthController;
  final TextEditingController minHeightController;
  final TextEditingController maxHeightController;
  final FocusNode minWidthFocusNode;
  final FocusNode maxWidthFocusNode;
  final FocusNode minHeightFocusNode;
  final FocusNode maxHeightFocusNode;
  final void Function(String, ViewConstraintsParameter) onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: WTextField(
                controller: minWidthController,
                focusNode: minWidthFocusNode,
                label: Text(
                  context
                      .sL10n
                      .addons
                      .constraints
                      .controls
                      .constraints
                      .values
                      .minWidth,
                ),
                onSubmitted: (value) =>
                    onSubmitted(value, ViewConstraintsParameter.minWidth),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: WTextField(
                controller: maxWidthController,
                focusNode: maxWidthFocusNode,
                label: Text(
                  context
                      .sL10n
                      .addons
                      .constraints
                      .controls
                      .constraints
                      .values
                      .maxWidth,
                ),
                onSubmitted: (value) =>
                    onSubmitted(value, ViewConstraintsParameter.maxWidth),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: WTextField(
                controller: minHeightController,
                focusNode: minHeightFocusNode,
                label: Text(
                  context
                      .sL10n
                      .addons
                      .constraints
                      .controls
                      .constraints
                      .values
                      .minHeight,
                ),
                onSubmitted: (value) =>
                    onSubmitted(value, ViewConstraintsParameter.minHeight),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: WTextField(
                controller: maxHeightController,
                focusNode: maxHeightFocusNode,
                label: Text(
                  context
                      .sL10n
                      .addons
                      .constraints
                      .controls
                      .constraints
                      .values
                      .maxHeight,
                ),
                onSubmitted: (value) =>
                    onSubmitted(value, ViewConstraintsParameter.maxHeight),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

enum ViewConstraintsParameter<T extends double?> {
  minWidth<double>(),
  maxWidth<double?>(),
  minHeight<double>(),
  maxHeight<double?>();

  bool get isMin => switch (this) {
    minWidth => true,
    maxWidth => false,
    minHeight => true,
    maxHeight => false,
  };
}

extension on ViewConstraints {
  ViewConstraints copyWithParameter<T extends double?>(
    ViewConstraintsParameter<T> parameter,
    T value,
  ) {
    switch (parameter) {
      case ViewConstraintsParameter.minWidth:
        return copyWith(minWidth: value);
      case ViewConstraintsParameter.maxWidth:
        return copyWith(maxWidth: () => value);
      case ViewConstraintsParameter.minHeight:
        return copyWith(minHeight: value);
      case ViewConstraintsParameter.maxHeight:
        return copyWith(maxHeight: () => value);
    }
  }

  T valueOf<T extends double?>(ViewConstraintsParameter<T> parameter) {
    return switch (parameter) {
      ViewConstraintsParameter.minWidth => minWidth as T,
      ViewConstraintsParameter.maxWidth => maxWidth as T,
      ViewConstraintsParameter.minHeight => minHeight as T,
      ViewConstraintsParameter.maxHeight => maxHeight as T,
    };
  }
}
