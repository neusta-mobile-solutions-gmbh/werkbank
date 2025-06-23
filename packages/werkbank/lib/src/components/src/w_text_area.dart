import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

const _defaultContentPadding = EdgeInsets.symmetric(
  horizontal: 16,
  vertical: 12,
);

/// {@category Werkbank Components}
class WTextArea extends StatelessWidget {
  WTextArea({
    super.key,
    required String text,
    this.trailing,
    // TODO(jthranitz): Remove when ColorPicker does not use WTextArea anymore
    this.contentPadding = _defaultContentPadding,
  }) : textSpan = TextSpan(text: text);

  const WTextArea.textSpan({
    super.key,
    required this.textSpan,
    this.trailing,
    this.contentPadding = _defaultContentPadding,
  });

  final TextSpan textSpan;
  final Widget? trailing;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.werkbankTextTheme;
    final colorScheme = context.werkbankColorScheme;

    final textStyle = textTheme.defaultText.copyWith(
      color: colorScheme.fieldContent,
    );

    return WFieldBox(
      contentPadding: contentPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text.rich(
              textSpan,
              style: textStyle,
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
