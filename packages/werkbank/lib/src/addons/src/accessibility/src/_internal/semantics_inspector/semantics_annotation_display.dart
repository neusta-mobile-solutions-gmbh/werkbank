import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_data_utils.dart';

class SemanticsAnnotationDisplay extends StatelessWidget {
  const SemanticsAnnotationDisplay({
    super.key,
    required this.annotation,
    required this.normalStyle,
    required this.verbatimStyle,
    required this.replacementVerbatimStyle,
  });

  final SemanticsAnnotation annotation;
  final TextStyle normalStyle;
  final TextStyle verbatimStyle;
  final TextStyle replacementVerbatimStyle;

  @override
  Widget build(BuildContext context) {
    final valueSpan = annotation.getValueSpan(
      normalStyle: normalStyle,
      verbatimStyle: verbatimStyle,
      replacementVerbatimStyle: replacementVerbatimStyle,
    );
    if (valueSpan == null) {
      return Text(
        '[${annotation.label}]',
        style: normalStyle,
        maxLines: 1,
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '[${annotation.label}=',
          style: normalStyle,
          maxLines: 1,
        ),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 100),
          child: Text.rich(
            valueSpan,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          ']',
          style: normalStyle,
          maxLines: 1,
        ),
      ],
    );
  }
}
