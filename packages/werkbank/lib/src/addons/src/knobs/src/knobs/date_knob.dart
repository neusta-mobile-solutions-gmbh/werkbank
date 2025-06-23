import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:werkbank/werkbank.dart';

/// {@category Knobs}
extension DateKnobExtension on KnobsComposer {
  WritableKnob<DateTime> date(
    String label, {
    required DateTime initialValue,
  }) {
    return makeRegularKnob(
      label,
      initialValue: initialValue,
      knobBuilder: (context, valueNotifier) => _DateKnob(
        valueNotifier: valueNotifier,
        enabled: true,
      ),
    );
  }
}

extension NullableDateKnobExtension on NullableKnobs {
  WritableKnob<DateTime?> date(
    String label, {
    required DateTime initialValue,
    bool initiallyNull = false,
  }) {
    return makeNullableKnob(
      label,
      initialValue: initialValue,
      initiallyNull: initiallyNull,
      knobBuilder: (context, enabled, valueNotifier) => _DateKnob(
        valueNotifier: valueNotifier,
        enabled: enabled,
      ),
    );
  }
}

class _DateKnob extends StatelessWidget {
  const _DateKnob({
    required this.valueNotifier,
    required this.enabled,
  });

  final ValueNotifier<DateTime> valueNotifier;
  final bool enabled;
  DateTime get effectiveFirstDate => DateTime(2000);
  DateTime get effectiveLastDate => DateTime(2050);

  @override
  Widget build(BuildContext context) {
    const spaceBetweenTitleAndTrailing = 16.0;

    const textPadding = EdgeInsets.symmetric(vertical: 10, horizontal: 12);
    final textStyle = context.werkbankTextTheme.interaction.apply(
      color: context.werkbankColorScheme.fieldContent,
    );

    return WTempDisabler(
      enabled: enabled,
      child: WButtonBase(
        onPressed: () async {
          final result = await showDatePicker(
            context: context,
            initialDate: valueNotifier.value,
            firstDate: effectiveFirstDate,
            lastDate: effectiveLastDate,
          );
          if (result != null) {
            valueNotifier.value = result;
          }
        },
        child: Padding(
          padding: textPadding,
          child: Column(
            children: [
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      DateFormat('dd.MM.yyyy').format(valueNotifier.value),
                      maxLines: 1,
                      style: textStyle,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: spaceBetweenTitleAndTrailing),
                  const Icon(Icons.date_range),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
