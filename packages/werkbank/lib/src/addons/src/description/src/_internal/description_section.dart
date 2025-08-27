import 'package:flutter/material.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/theme/theme.dart';

class DescriptionSection extends StatelessWidget {
  const DescriptionSection({
    required this.data,
    this.hint,
    super.key,
  });

  final String data;
  final Widget? hint;

  @override
  Widget build(BuildContext context) {
    final widget = WFieldBox(
      child: WMarkdown(
        data: data,
      ),
    );

    if (hint == null) return widget;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DefaultTextStyle.merge(
          style: context.werkbankTextTheme.textSmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.end,
          child: hint!,
        ),
        const SizedBox(height: 4),
        widget,
      ],
    );
  }
}
