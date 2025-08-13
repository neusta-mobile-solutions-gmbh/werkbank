import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/addons/src/knobs/knobs.dart';
import 'package:werkbank/src/components/components.dart';

class IntervalKnobWidget extends StatelessWidget {
  const IntervalKnobWidget({
    required this.currentInterval,
    required this.beginOptions,
    required this.endOptions,
    required this.onBeginChanged,
    required this.onEndChanged,
    super.key,
  });

  final NamedInterval currentInterval;
  final List<NamedDouble> beginOptions;
  final List<NamedDouble> endOptions;
  final ValueChanged<NamedDouble?>? onBeginChanged;
  final ValueChanged<NamedDouble?>? onEndChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        WControlItem(
          title: Text(context.sL10n.addons.knobs.knobs.interval.begin),
          control: WDropdown<NamedDouble>(
            onChanged: onBeginChanged,
            value: currentInterval.begin,
            items: [
              for (final begin in beginOptions)
                WDropdownMenuItem(
                  value: begin,
                  child: Text(
                    begin.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        WControlItem(
          title: Text(context.sL10n.addons.knobs.knobs.interval.end),
          control: WDropdown<NamedDouble>(
            onChanged: onEndChanged,
            value: currentInterval.end,
            items: [
              for (final end in endOptions)
                WDropdownMenuItem(
                  value: end,
                  child: Text(
                    end.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
