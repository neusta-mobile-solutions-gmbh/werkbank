import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/node_info/semantics_data_fields/semantics_data_field.dart';
import 'package:werkbank/werkbank.dart';

class TextSpanSemanticsDataField extends StatelessWidget {
  const TextSpanSemanticsDataField({
    super.key,
    required this.name,
    required this.value,
  });

  final String name;
  final TextSpan value;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.werkbankTextTheme;
    final colorScheme = context.werkbankColorScheme;
    return SemanticsDataField(
      name: name,
      value: Text.rich(
        value,
        style: textTheme.input.apply(
          color: colorScheme.textLight,
        ),
      ),
    );
  }
}
