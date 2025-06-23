import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_annotation_display.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_data_utils.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/soft_max_constrained_box.dart';

class SemanticsDataSummary extends StatelessWidget {
  const SemanticsDataSummary({
    super.key,
    required this.data,
    required this.targetAspectRatio,
    required this.labelStyle,
    required this.labelReplacementStyle,
    required this.annotationStyle,
    required this.annotationVerbatimValueStyle,
    required this.annotationVerbatimValueReplacementStyle,
  });

  final SemanticsData data;
  final double targetAspectRatio;
  final TextStyle labelStyle;
  final TextStyle labelReplacementStyle;
  final TextStyle annotationStyle;
  final TextStyle annotationVerbatimValueStyle;
  final TextStyle annotationVerbatimValueReplacementStyle;

  TextSpan? _labelSpan() {
    final label = data.label;
    if (label.isEmpty) {
      return null;
    }
    return SemanticsDataUtils.escapeString(
      label,
      normalStyle: labelStyle,
      replacementStyle: labelReplacementStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelSpan = _labelSpan();
    final annotations = SemanticsDataUtils.getAnnotations(data);
    final estimatedWidth =
        (labelSpan == null ? 0 : 100) + annotations.length * 60;

    const estimatedHeight = 12;
    final layoutWidth = sqrt(
      estimatedWidth * estimatedHeight * targetAspectRatio,
    );
    return SoftMaxConstrainedBox(
      constrainedAxis: Axis.horizontal,
      softMaxAxisConstraint: layoutWidth,
      child: Wrap(
        spacing: 4,
        children: [
          if (labelSpan != null)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 200),
              child: Text.rich(
                labelSpan,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          for (final annotation in annotations)
            SemanticsAnnotationDisplay(
              annotation: annotation,
              normalStyle: annotationStyle,
              verbatimStyle: annotationVerbatimValueStyle,
              replacementVerbatimStyle: annotationVerbatimValueReplacementStyle,
            ),
        ],
      ),
    );
  }
}
