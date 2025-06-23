import 'package:flutter/material.dart';

class DatePickerButton extends StatelessWidget {
  const DatePickerButton({
    super.key,
    required this.date,
    required this.onDateSelected,
  });

  final DateTime date;
  final ValueChanged<DateTime>? onDateSelected;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: onDateSelected == null
          ? null
          : () async {
              // Check if we are in a WerkbankApp without needing
              // `werkbank` as dependency.
              final isInWerkbankApp =
                  SharedAppData.getValue(
                    context,
                    'werkbank_environment',
                    () => 'none',
                  ) ==
                  'app';

              final newDate = await showDatePicker(
                context: context,
                initialDate: date,
                firstDate: DateTime(0),
                lastDate: DateTime(3000),
                useRootNavigator: !isInWerkbankApp,
              );
              if (newDate != null) {
                onDateSelected?.call(newDate);
              }
            },
      child: Text(MaterialLocalizations.of(context).formatCompactDate(date)),
    );
  }
}
