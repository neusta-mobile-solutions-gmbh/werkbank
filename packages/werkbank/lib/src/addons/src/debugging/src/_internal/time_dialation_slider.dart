import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:werkbank/src/_internal/src/localizations/localizations.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/theme/theme.dart';

class TimeDialationSlider extends StatefulWidget {
  const TimeDialationSlider({super.key});

  @override
  State<TimeDialationSlider> createState() => _TimeDialationSliderState();
}

class _TimeDialationSliderState extends State<TimeDialationSlider> {
  int? _index;

  @override
  void initState() {
    super.initState();
    _updateIndexUsingTimeDilation();
  }

  void _updateIndexUsingTimeDilation() {
    final sliderHasThisValue = _timeDialationValues.contains(timeDilation);
    if (!sliderHasThisValue) {
      _index = null;
      return;
    }
    _index = _timeDialationValues.indexOf(timeDilation);
  }

  @override
  Widget build(BuildContext context) {
    return WControlItem(
      title: Text(context.sL10n.addons.debugging.controls.timeDilation),
      control: Row(
        children: [
          WIconButton(
            onPressed: () {
              timeDilation = 1;
              _updateIndexUsingTimeDilation();
              setState(() {});
            },
            icon: const Icon(
              WerkbankIcons.x,
            ),
          ),
          const SizedBox(width: 2),
          if (_index != null)
            Expanded(
              child: WSlider(
                value: _index!.toDouble(),
                onChanged: (index) {
                  timeDilation = _timeDialationValues[index.toInt()];
                  _index = index.toInt();
                  setState(() {});
                },
                valueFormatter: (_) {
                  final value = _timeDialationValues[_index!];
                  return '${value.toStringAsFixed(2)}x';
                },
                min: _timeDialationValues.first,
                max: _timeDialationValues.length - 1,
                divisions: _timeDialationValues.length - 1,
              ),
            )
          else
            // This is a fallback.
            // When some other party is using the time dialation,
            // we just display the current value, but don't interfere
            // with it.
            Flexible(
              child: Center(
                child: Text(
                  timeDilation.toStringAsFixed(2),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

const List<double> _timeDialationValues = [
  1 / 32,
  1 / 16,
  1 / 8,
  1 / 6,
  1 / 4,
  1 / 3,
  1 / 2,
  1.0,
  2,
  3,
  4,
  6,
  8,
  16,
  32,
];
