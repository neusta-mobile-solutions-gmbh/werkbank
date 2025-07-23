import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addons/src/constraints/src/constraints_composition.dart';
import 'package:werkbank/src/addons/src/constraints/src/view_constraints.dart';
import 'package:werkbank/src/components/components.dart';

class SizeSelector extends StatefulWidget {
  const SizeSelector({
    super.key,
    required this.constraintsComposition,
  });

  final ConstraintsComposition constraintsComposition;

  @override
  State<SizeSelector> createState() => _SizeSelectorState();
}

class _SizeSelectorState extends State<SizeSelector> {
  // We initialize with a space to avoid the label animating away
  // one frame later.
  final TextEditingController widthController = TextEditingController(
    text: ' ',
  );
  final TextEditingController heightController = TextEditingController(
    text: ' ',
  );

  final FocusNode widthFocusNode = FocusNode();
  final FocusNode heightFocusNode = FocusNode();

  TextEditingController controllerFor(Axis axis) {
    return switch (axis) {
      Axis.horizontal => widthController,
      Axis.vertical => heightController,
    };
  }

  FocusNode focusNodeFor(Axis axis) {
    return switch (axis) {
      Axis.horizontal => widthFocusNode,
      Axis.vertical => heightFocusNode,
    };
  }

  late ValueNotifier<ViewConstraints> viewConstraintsNotifier;
  late ValueListenable<Size?> sizeListenable;

  @override
  void initState() {
    super.initState();
    viewConstraintsNotifier =
        widget.constraintsComposition.viewConstraintsNotifier;
    sizeListenable = widget.constraintsComposition.sizeListenable;
    sizeListenable.addListener(_updateControllers);
    for (final axis in Axis.values) {
      final controller = controllerFor(axis);
      final focusNode = focusNodeFor(axis);
      focusNode.addListener(() {
        if (!focusNode.hasFocus) {
          _onSubmitted(controller.text, axis);
        }
      });
    }
    _updateControllers();
  }

  @override
  void didUpdateWidget(SizeSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.constraintsComposition != oldWidget.constraintsComposition) {
      viewConstraintsNotifier =
          widget.constraintsComposition.viewConstraintsNotifier;
      sizeListenable.removeListener(_updateControllers);
      sizeListenable = widget.constraintsComposition.sizeListenable;
      sizeListenable.addListener(_updateControllers);
      _updateControllers();
    }
  }

  void _updateControllers() {
    final size = sizeListenable.value;
    // We can't update the controllers directly because the sizeNotifier
    // updates after the build phase.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widthController.text = _sizeParameterToString(size?.width);
        heightController.text = _sizeParameterToString(size?.height);
      }
    });
  }

  String _sizeParameterToString(double? value) {
    return value?.round().toString() ?? ' ';
  }

  double? _sizeParameterFromString(String value) {
    final parsed = double.tryParse(value);
    if (parsed == null || parsed.isNegative || !parsed.isFinite) {
      return null;
    }
    return parsed;
  }

  void _tighten() {
    final size = sizeListenable.value;
    if (size == null) {
      return;
    }
    viewConstraintsNotifier.value = ViewConstraints(
      minWidth: size.width,
      maxWidth: size.width,
      minHeight: size.height,
      maxHeight: size.height,
    );
  }

  void _onSubmitted(String value, Axis axis) {
    final viewConstraints = viewConstraintsNotifier.value;
    final parameterValue = _sizeParameterFromString(value);
    if (parameterValue == null) {
      _updateControllers();
      return;
    }
    viewConstraintsNotifier.value = switch (axis) {
      Axis.horizontal => viewConstraints.copyWith(
        minWidth: parameterValue,
        maxWidth: () => parameterValue,
      ),
      Axis.vertical => viewConstraints.copyWith(
        minHeight: parameterValue,
        maxHeight: () => parameterValue,
      ),
    };
    _updateControllers();
  }

  @override
  void dispose() {
    widget.constraintsComposition.viewConstraintsNotifier.removeListener(
      _updateControllers,
    );
    for (final axis in Axis.values) {
      controllerFor(axis).dispose();
      focusNodeFor(axis).dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WControlItem(
      title: Text(context.sL10n.addons.constraints.controls.size.name),
      layout: ControlItemLayout.spacious,
      control: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Row(
          children: [
            WIconButton(
              onPressed: _tighten,
              icon: const Icon(Icons.lock_outline_rounded),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: WTextField(
                controller: widthController,
                focusNode: widthFocusNode,
                label: Text(
                  context.sL10n.addons.constraints.controls.size.values.width,
                ),
                onSubmitted: (value) => _onSubmitted(value, Axis.horizontal),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: WTextField(
                controller: heightController,
                focusNode: heightFocusNode,
                label: Text(
                  context.sL10n.addons.constraints.controls.size.values.height,
                ),
                onSubmitted: (value) => _onSubmitted(value, Axis.vertical),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
