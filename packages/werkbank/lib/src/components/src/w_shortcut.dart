import 'package:flutter/material.dart';
import 'package:werkbank/src/werkbank_internal.dart';

/// {@category Werkbank Components}
class WShortcut extends StatelessWidget {
  const WShortcut({
    super.key,
    required this.keyStrokes,
    required this.description,
  });

  final List<String> keyStrokes;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.werkbankTextTheme;
    if (keyStrokes.length == 1 && keyStrokes.first == '') {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 8,
              bottom: 8,
            ),
            child: Text(
              description,
              textAlign: TextAlign.center,
              maxLines: 1,
              style: textTheme.defaultText,
            ),
          ),
        ],
      );
    }
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            for (final keyStroke in keyStrokes) ...[
              WKeyboardButton(text: keyStroke),
              if (keyStroke != keyStrokes.last)
                Text(
                  ' + ',
                  style: textTheme.defaultText,
                ),
            ],
          ],
        ),
        Text(
          description,
          style: textTheme.defaultText,
        ),
      ],
    );
  }
}
