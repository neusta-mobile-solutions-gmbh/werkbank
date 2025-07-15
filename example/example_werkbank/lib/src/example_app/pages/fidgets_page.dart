import 'dart:math';

import 'package:example_werkbank/src/example_app/components/date_picker_button.dart';
import 'package:flutter/material.dart';

class FidgetsPage extends StatelessWidget {
  const FidgetsPage({super.key});

  void _showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: Durations.short1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fidgets = <Widget>[
      _StateHolder<double>(
        initialValue: 0,
        builder: (context, value, onValueChanged) {
          return Slider(
            value: value,
            max: 10,
            onChanged: onValueChanged,
          );
        },
      ),
      _StateHolder<double>(
        initialValue: 0,
        builder: (context, value, onValueChanged) {
          return Slider(
            value: value,
            max: 10,
            divisions: 10,
            onChanged: onValueChanged,
          );
        },
      ),
      const TextField(
        decoration: InputDecoration(
          border: OutlineInputBorder(),
        ),
      ),
      _StateHolder<bool?>(
        initialValue: false,
        builder: (context, value, onValueChanged) {
          return Checkbox(
            value: value,
            tristate: true,
            onChanged: onValueChanged,
            semanticLabel: 'Checkbox',
          );
        },
      ),
      _StateHolder<bool>(
        initialValue: false,
        builder: (context, value, onValueChanged) {
          return Semantics(
            label: 'Switch',
            child: Switch(
              value: value,
              onChanged: onValueChanged,
            ),
          );
        },
      ),
      FilledButton(
        onPressed: () {
          _showSnackbar(context, 'Button Pressed');
        },
        child: const Text('Press Me'),
      ),
      _StateHolder<DateTime>(
        initialValue: DateTime.now(),
        builder: (context, value, onValueChanged) {
          return DatePickerButton(
            date: value,
            onDateSelected: onValueChanged,
          );
        },
      ),
      IconButton(
        icon: const Icon(
          Icons.add,
          semanticLabel: 'Icon Button',
        ),
        onPressed: () {
          _showSnackbar(context, 'Icon Button Pressed');
        },
      ),
    ];
    final random = Random(0);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (var i = 0; i < 100; i++)
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: random.nextDouble() * 300 + 150,
                  ),
                  child: Transform.rotate(
                    angle: (random.nextDouble() - 0.5) * 0.1,
                    child: fidgets[random.nextInt(fidgets.length)],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef ValueBuilder<T> =
    Widget Function(
      BuildContext context,
      T value,
      ValueChanged<T> onValueChanged,
    );

class _StateHolder<T> extends StatefulWidget {
  const _StateHolder({
    required this.initialValue,
    required this.builder,
  });

  final T initialValue;
  final ValueBuilder<T> builder;

  @override
  State<_StateHolder<T>> createState() => _StateHolderState();
}

class _StateHolderState<T> extends State<_StateHolder<T>> {
  late T _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _value,
      (newValue) {
        setState(() {
          _value = newValue;
        });
      },
    );
  }
}
