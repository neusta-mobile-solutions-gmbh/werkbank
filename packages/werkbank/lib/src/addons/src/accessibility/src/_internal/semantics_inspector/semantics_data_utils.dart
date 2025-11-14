import 'package:flutter/rendering.dart';

final class SemanticsDataUtils {
  SemanticsDataUtils._();

  static TextSpan escapeString(
    String string, {
    TextStyle? normalStyle,
    TextStyle? replacementStyle,
  }) {
    final replacements = {
      '\n': r'\n',
      '\t': r'\t',
    };
    final currentSpan = StringBuffer();
    final textSpans = <TextSpan>[];
    var normalText = true;
    void finishSpan() {
      if (currentSpan.isNotEmpty) {
        textSpans.add(
          TextSpan(
            text: currentSpan.toString(),
            style: normalText ? normalStyle : replacementStyle,
          ),
        );
        currentSpan.clear();
      }
    }

    for (final char in string.runes) {
      final charString = String.fromCharCode(char);
      final replacement = replacements[charString];
      if (replacement != null) {
        if (normalText) {
          finishSpan();
        }
        currentSpan.write(replacement);
        normalText = false;
      } else {
        if (!normalText) {
          finishSpan();
        }
        currentSpan.write(charString);
        normalText = true;
      }
    }
    finishSpan();
    return TextSpan(
      children: textSpans,
    );
  }

  static List<SemanticsAnnotation> getAnnotations(SemanticsData data) {
    final annotations = <SemanticsAnnotation>[];

    if (data.tooltip.isNotEmpty) {
      annotations.add(
        _VerbatimValueSemanticsAnnotation(
          label: 'tooltip',
          value: data.value,
        ),
      );
    }

    if (data.value.isNotEmpty) {
      annotations.add(
        _VerbatimValueSemanticsAnnotation(
          label: 'value',
          value: data.value,
        ),
      );
    }
    final flags = data.flagsCollection;

    if (flags.isHeader) {
      annotations.add(_TagSemanticsAnnotation(label: 'header'));
    }

    if (flags.isImage) {
      annotations.add(_TagSemanticsAnnotation(label: 'image'));
    }

    if (flags.isLiveRegion) {
      annotations.add(_TagSemanticsAnnotation(label: 'live region'));
    }

    if (flags.isChecked != .none) {
      annotations.add(
        _ValueSemanticsAnnotation(
          label: 'checked',
          value: switch (flags.isChecked) {
            .isFalse => 'no',
            .isTrue => 'yes',
            .mixed => 'mixed',
            .none => throw AssertionError('Unreachable'),
          },
        ),
      );
    }

    if (flags.isToggled != .none) {
      annotations.add(
        _ValueSemanticsAnnotation(
          label: 'toggled',
          value: switch (flags.isToggled) {
            .isFalse => 'no',
            .isTrue => 'yes',
            .none => throw AssertionError('Unreachable'),
          },
        ),
      );
    }

    if (flags.isExpanded != .none) {
      annotations.add(
        _ValueSemanticsAnnotation(
          label: 'expanded',
          value: switch (flags.isExpanded) {
            .isFalse => 'no',
            .isTrue => 'yes',
            .none => throw AssertionError('Unreachable'),
          },
        ),
      );
    }

    var wantsTap = false;
    if (flags.isTextField) {
      final textFieldLabel = [
        if (flags.isReadOnly) 'read-only',
        if (flags.isMultiline) 'multi-line',
        'text field',
      ];
      annotations.add(_TagSemanticsAnnotation(label: textFieldLabel.join(' ')));
      wantsTap = true;
    }
    if (flags.isButton) {
      annotations.add(_TagSemanticsAnnotation(label: 'button'));
      wantsTap = true;
    }
    var isSlider = false;
    if (flags.isSlider) {
      annotations.add(_TagSemanticsAnnotation(label: 'slider'));
      wantsTap = true;
      isSlider = true;
    }

    if (data.hasAction(SemanticsAction.tap)) {
      if (!wantsTap) {
        annotations.add(_TagSemanticsAnnotation(label: 'tappable'));
      }
    } else {
      // The Flutter [SemanticsDebugger] displays this, but it conflicts with
      // the other enabled state annotation, which may cause confusion.
      // if (wantsTap) {
      //   annotations.add(_TagSemanticsAnnotation(label: 'disabled'));
      // }
    }

    if (flags.isEnabled == .isFalse) {
      annotations.add(_TagSemanticsAnnotation(label: 'disabled'));
    }

    if (data.hasAction(SemanticsAction.longPress)) {
      annotations.add(_TagSemanticsAnnotation(label: 'long-pressable'));
    }

    final isScrollable =
        data.hasAction(SemanticsAction.scrollLeft) ||
        data.hasAction(SemanticsAction.scrollRight) ||
        data.hasAction(SemanticsAction.scrollUp) ||
        data.hasAction(SemanticsAction.scrollDown);
    if (isScrollable) {
      annotations.add(_TagSemanticsAnnotation(label: 'scrollable'));
    }

    final isAdjustable =
        data.hasAction(SemanticsAction.increase) ||
        data.hasAction(SemanticsAction.decrease);

    if (isAdjustable && !isSlider) {
      annotations.add(_TagSemanticsAnnotation(label: 'adjustable'));
    }
    return annotations;
  }
}

abstract class SemanticsAnnotation {
  SemanticsAnnotation({required this.label});

  final String label;

  TextSpan? getValueSpan({
    required TextStyle? normalStyle,
    required TextStyle? verbatimStyle,
    required TextStyle? replacementVerbatimStyle,
  });
}

class _TagSemanticsAnnotation extends SemanticsAnnotation {
  _TagSemanticsAnnotation({
    required super.label,
  });

  @override
  TextSpan? getValueSpan({
    required TextStyle? normalStyle,
    required TextStyle? verbatimStyle,
    required TextStyle? replacementVerbatimStyle,
  }) => null;
}

class _ValueSemanticsAnnotation extends SemanticsAnnotation {
  _ValueSemanticsAnnotation({
    required super.label,
    required this.value,
  });

  final String value;

  @override
  TextSpan? getValueSpan({
    required TextStyle? normalStyle,
    required TextStyle? verbatimStyle,
    required TextStyle? replacementVerbatimStyle,
  }) {
    return TextSpan(
      text: value,
      style: normalStyle,
    );
  }
}

class _VerbatimValueSemanticsAnnotation extends SemanticsAnnotation {
  _VerbatimValueSemanticsAnnotation({
    required super.label,
    required this.value,
  });

  final String value;

  @override
  TextSpan? getValueSpan({
    required TextStyle? normalStyle,
    required TextStyle? verbatimStyle,
    required TextStyle? replacementVerbatimStyle,
  }) {
    return SemanticsDataUtils.escapeString(
      value,
      normalStyle: verbatimStyle,
      replacementStyle: replacementVerbatimStyle,
    );
  }
}
