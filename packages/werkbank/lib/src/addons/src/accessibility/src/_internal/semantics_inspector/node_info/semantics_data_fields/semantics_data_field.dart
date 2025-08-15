import 'package:flutter/material.dart';
import 'package:werkbank/src/theme/theme.dart';

class SemanticsDataField extends StatelessWidget {
  const SemanticsDataField({
    super.key,
    required this.name,
    required this.value,
  });

  final String name;
  final Widget value;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.werkbankTextTheme;
    final colorScheme = context.werkbankColorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Text(
            '$name:',
            style: textTheme.input.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.textLight,
            ),
          ),
        ),
        Expanded(
          child: value,
        ),
      ],
    );
  }
}
