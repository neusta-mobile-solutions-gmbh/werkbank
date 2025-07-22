import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

/// {@category Werkbank Components}
class WTextField extends StatefulWidget {
  const WTextField({
    super.key,
    this.label,
    this.hintText,
    this.focusNode,
    this.enabled = true,
    this.showClearButton = false,
    this.onChanged,
    this.onSubmitted,
    this.initialValue,
    this.maxLines = 1,
    this.controller,
    this.maxLength,
  });

  final Widget? label;
  final String? hintText;
  final FocusNode? focusNode;
  final bool enabled;
  final bool showClearButton;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? initialValue;
  final int maxLines;
  final TextEditingController? controller;
  final int? maxLength;

  @override
  State<WTextField> createState() => _WTextFieldState();
}

class _WTextFieldState extends State<WTextField> {
  static const _textFieldRadius = 4.0;

  bool isHovering = false;
  TextEditingController? _localController;

  TextEditingController get _effectiveController =>
      widget.controller ?? _localController!;

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _localController = TextEditingController(text: widget.initialValue);
    }
  }

  @override
  void didUpdateWidget(WTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      _localController = TextEditingController.fromValue(
        oldWidget.controller!.value,
      );
    } else if (widget.controller != null && oldWidget.controller == null) {
      _localController?.dispose();
      _localController = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = context.werkbankTextTheme;
    final colorScheme = context.werkbankColorScheme;

    final style = textTheme.input.copyWith(
      color: colorScheme.fieldContent,
    );
    var backgroundColor = colorScheme.field;

    if (!widget.enabled) {
      backgroundColor = Colors.transparent;
    }
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) {
        setState(() => isHovering = false);
      },
      child: TextField(
        maxLength: widget.maxLength,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        focusNode: widget.focusNode,
        controller: _effectiveController,
        style: style,
        enabled: widget.enabled,
        cursorColor: colorScheme.tabFocus,
        showCursor: true,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          // prevent the counter text from showing when maxLength is set
          counterText: widget.maxLength != null ? '' : null,
          hoverColor: Colors.transparent,
          label: widget.label != null
              ? DefaultTextStyle.merge(
                  style: textTheme.input.copyWith(
                    color: colorScheme.fieldContent,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  child: widget.label!,
                )
              : null,
          hintText: widget.hintText,
          hintStyle: style.copyWith(color: colorScheme.fieldContent),
          filled: true,
          focusColor: colorScheme.tabFocus,
          fillColor: backgroundColor,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          suffixIcon: widget.showClearButton
              ? ListenableBuilder(
                  listenable: _effectiveController,
                  builder: (context, _) {
                    if (_effectiveController.text.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return WButtonBase(
                      backgroundColor: Colors.transparent,
                      showBorder: false,
                      onPressed: () => _effectiveController.clear(),
                      child: const Icon(Icons.clear),
                    );
                  },
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_textFieldRadius),
            borderSide: BorderSide(
              color: colorScheme.field,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_textFieldRadius),
            borderSide: BorderSide(
              color: colorScheme.tabFocus,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_textFieldRadius),
            borderSide: BorderSide(
              color: colorScheme.field,
              width: 2,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(_textFieldRadius),
            borderSide: BorderSide(
              color: isHovering ? colorScheme.hoverFocus : colorScheme.field,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
