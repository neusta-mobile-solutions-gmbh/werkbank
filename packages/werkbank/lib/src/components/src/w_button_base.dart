import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Werkbank Components}
class WButtonBase extends StatefulWidget {
  const WButtonBase({
    super.key,
    required this.onPressed,
    this.isActive = false,
    this.semanticActiveState = false,
    this.backgroundColor,
    this.activeBackgroundColor,
    this.borderRadius = const BorderRadius.all(Radius.circular(4)),
    required this.child,
    this.showBorder = true,
  });

  final VoidCallback? onPressed;
  final bool isActive;
  final bool semanticActiveState;
  final Color? backgroundColor;
  final Color? activeBackgroundColor;
  final bool showBorder;
  final BorderRadius borderRadius;
  final Widget child;

  @override
  State<WButtonBase> createState() => _WButtonBaseState();
}

class _WButtonBaseState extends State<WButtonBase> {
  bool _focused = false;
  bool _hovering = false;
  late final Map<Type, Action<Intent>> _actionMap = <Type, Action<Intent>>{
    ActivateIntent: CallbackAction<ActivateIntent>(
      onInvoke: (_) => widget.onPressed?.call(),
    ),
  };

  void _handleFocusHighlight(bool value) => setState(() => _focused = value);

  void _handleHoverHighlight(bool value) => setState(() => _hovering = value);

  @override
  Widget build(BuildContext context) {
    Color? borderColor;
    if (_hovering) {
      borderColor = context.werkbankColorScheme.hoverFocus;
    }
    if (_focused) {
      if (widget.isActive) {
        /* TODO(lzuttermeister): This is not in the design, but otherwise
             it is not possible to see the focus. */
        borderColor = context.werkbankColorScheme.field;
      } else {
        borderColor = context.werkbankColorScheme.tabFocus;
      }
    }
    var backgroundColor =
        widget.backgroundColor ?? context.werkbankColorScheme.field;
    if (widget.isActive) {
      backgroundColor =
          widget.activeBackgroundColor ??
          context.werkbankColorScheme.backgroundActive;
    }
    return Semantics(
      toggled: widget.semanticActiveState ? widget.isActive : null,
      enabled: widget.onPressed != null,
      child: GestureDetector(
        onTap: widget.onPressed,
        child: FocusableActionDetector(
          enabled: widget.onPressed != null,
          actions: _actionMap,
          onShowFocusHighlight: _handleFocusHighlight,
          onShowHoverHighlight: _handleHoverHighlight,
          child: WBorderedBox(
            borderRadius: widget.borderRadius,
            borderColor: widget.showBorder ? borderColor : null,
            backgroundColor: backgroundColor,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
