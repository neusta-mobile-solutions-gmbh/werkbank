import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/node_info/semantics_data_fields/text_span_semantics_data_field.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_data_utils.dart';
import 'package:werkbank/src/theme/theme.dart';

class AttributedStringSemanticsDataField extends StatefulWidget {
  const AttributedStringSemanticsDataField({
    super.key,
    required this.name,
    required this.attributedString,
    this.textSelection,
  });

  final String name;
  final AttributedString attributedString;
  final TextSelection? textSelection;

  @override
  State<AttributedStringSemanticsDataField> createState() =>
      _AttributedStringSemanticsDataFieldState();
}

class _AttributedStringSemanticsDataFieldState
    extends State<AttributedStringSemanticsDataField> {
  StringAttribute? _hoveredAttribute;

  TextSpan _toSpanWithRange(
    String value,
    TextRange? range,
    WerkbankTheme theme,
  ) {
    final colorScheme = theme.colorScheme;
    TextSpan escape(String string) {
      return SemanticsDataUtils.escapeString(
        string,
        replacementStyle: TextStyle(
          // TODO(lzuttermeister): Use theme color
          color: colorScheme.textLight.withValues(alpha: 0.5),
          fontWeight: FontWeight.w100,
        ),
      );
    }

    if (range == null ||
        range.isCollapsed ||
        !range.isValid ||
        !range.isNormalized ||
        range.end > value.length) {
      return escape(value);
    }
    return TextSpan(
      children: [
        if (range.start > 0) escape(range.textBefore(value)),
        TextSpan(
          style: TextStyle(
            backgroundColor: colorScheme.text.withValues(alpha: 0.3),
          ),
          children: [escape(range.textInside(value))],
        ),
        if (range.end < value.length) escape(range.textAfter(value)),
      ],
    );
  }

  String _attributeToString(StringAttribute attribute) {
    return switch (attribute) {
      LocaleStringAttribute() =>
        'LocaleStringAttribute(${attribute.locale.toLanguageTag()})',
      SpellOutStringAttribute() => 'SpellOutStringAttribute()',
      _ => attribute.toString(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final attributes = widget.attributedString.attributes;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextSpanSemanticsDataField(
          name: widget.name,
          value: _toSpanWithRange(
            widget.attributedString.string,
            _hoveredAttribute?.range ?? widget.textSelection,
            context.werkbankTheme,
          ),
        ),
        if (attributes.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: TextSpanSemanticsDataField(
              name: 'attributes',
              value: TextSpan(
                children: [
                  for (final (i, attribute) in attributes.indexed) ...[
                    if (i > 0) const TextSpan(text: ', '),
                    TextSpan(
                      text: _attributeToString(attribute),
                      onEnter: (_) =>
                          setState(() => _hoveredAttribute = attribute),
                      onExit: (_) => setState(() => _hoveredAttribute = null),
                    ),
                  ],
                ],
              ),
            ),
          ),
      ],
    );
  }
}
