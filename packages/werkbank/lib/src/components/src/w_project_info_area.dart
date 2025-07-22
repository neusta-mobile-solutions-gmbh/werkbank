import 'package:flutter/material.dart';

/// {@category Werkbank Components}
class WProjectInfoArea extends StatelessWidget {
  const WProjectInfoArea({
    super.key,
    required this.logo,
    required this.title,
    required this.lastUpdated,
    required this.onTap,
    this.trailing,
  });

  final Widget? logo;
  final Widget title;
  final DateTime? lastUpdated;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.werkbankTextTheme;
    final colorScheme = context.werkbankColorScheme;

    final formatedDate = lastUpdated != null
        // TODO(lzuttermeister): Use our own localizations.
        ? MaterialLocalizations.of(context).formatCompactDate(lastUpdated!)
        : null;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (logo != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: SizedBox(
                width: 32,
                height: 32,
                child: logo,
              ),
            ),
          Row(
            children: [
              Expanded(
                child: DefaultTextStyle.merge(
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.headline.copyWith(color: colorScheme.text),
                  child: title,
                ),
              ),
              if (trailing != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: trailing,
                ),
            ],
          ),
          if (formatedDate != null)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                context.sL10n.navigationPanel.lastUpdated(date: formatedDate),
                overflow: TextOverflow.ellipsis,
                style: textTheme.indicator.copyWith(
                  color: colorScheme.textLight,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
