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

    if (data.hasFlag(SemanticsFlag.isHeader)) {
      annotations.add(_TagSemanticsAnnotation(label: 'header'));
    }

    if (data.hasFlag(SemanticsFlag.isImage)) {
      annotations.add(_TagSemanticsAnnotation(label: 'image'));
    }

    if (data.hasFlag(SemanticsFlag.isLiveRegion)) {
      annotations.add(_TagSemanticsAnnotation(label: 'live region'));
    }

    if (data.hasFlag(SemanticsFlag.hasCheckedState)) {
      bool? value = false;
      if (data.hasFlag(SemanticsFlag.isChecked)) {
        value = true;
      }
      if (data.hasFlag(SemanticsFlag.isCheckStateMixed)) {
        value = null;
      }
      annotations.add(
        _ValueSemanticsAnnotation(
          label: 'checked',
          value: switch (value) {
            false => 'no',
            true => 'yes',
            null => 'mixed',
          },
        ),
      );
    }

    if (data.hasFlag(SemanticsFlag.hasToggledState)) {
      annotations.add(
        _ValueSemanticsAnnotation(
          label: 'toggled',
          value: data.hasFlag(SemanticsFlag.isToggled) ? 'yes' : 'no',
        ),
      );
    }

    if (data.hasFlag(SemanticsFlag.hasExpandedState)) {
      annotations.add(
        _ValueSemanticsAnnotation(
          label: 'expanded',
          value: data.hasFlag(SemanticsFlag.isExpanded) ? 'yes' : 'no',
        ),
      );
    }

    var wantsTap = false;
    if (data.hasFlag(SemanticsFlag.isTextField)) {
      final textFieldLabel = [
        if (data.hasFlag(SemanticsFlag.isReadOnly)) 'read-only',
        if (data.hasFlag(SemanticsFlag.isMultiline)) 'multi-line',
        'text field',
      ];
      annotations.add(_TagSemanticsAnnotation(label: textFieldLabel.join(' ')));
      wantsTap = true;
    }
    if (data.hasFlag(SemanticsFlag.isButton)) {
      annotations.add(_TagSemanticsAnnotation(label: 'button'));
      wantsTap = true;
    }
    var isSlider = false;
    if (data.hasFlag(SemanticsFlag.isSlider)) {
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

    if (data.hasFlag(SemanticsFlag.hasEnabledState) &&
        !data.hasFlag(SemanticsFlag.isEnabled)) {
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
