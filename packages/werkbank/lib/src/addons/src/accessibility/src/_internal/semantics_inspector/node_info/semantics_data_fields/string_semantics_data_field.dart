import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/node_info/semantics_data_fields/text_span_semantics_data_field.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_data_utils.dart';
import 'package:werkbank/werkbank.dart';

class StringSemanticsDataField extends StatelessWidget {
  const StringSemanticsDataField({
    super.key,
    required this.name,
    required this.value,
  });

  final String name;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.werkbankColorScheme;
    return TextSpanSemanticsDataField(
      name: name,
      value: SemanticsDataUtils.escapeString(
        value,
        replacementStyle: TextStyle(
          // TODO(lzuttermeister): Use theme color
          color: colorScheme.textLight.withValues(alpha: 0.5),
          fontWeight: FontWeight.w100,
        ),
      ),
    );
  }
}
