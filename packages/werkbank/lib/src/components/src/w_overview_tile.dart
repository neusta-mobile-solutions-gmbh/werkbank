import 'package:flutter/material.dart';
import 'package:werkbank/src/components/src/w_button_base.dart';
import 'package:werkbank/src/components/src/w_delayed_reveal.dart';
import 'package:werkbank/src/components/src/w_path_text.dart';
import 'package:werkbank/src/theme/theme.dart';

/// {@category Werkbank Components}
class WOverviewTile extends StatelessWidget {
  const WOverviewTile({
    super.key,
    required this.onPressed,
    required this.nameSegments,
    required this.thumbnail,
  });

  final VoidCallback onPressed;
  final List<String> nameSegments;
  final Widget? thumbnail;

  @override
  Widget build(BuildContext context) {
    final Widget effectiveThumbnail;
    if (thumbnail != null) {
      effectiveThumbnail = WDelayedReveal.randomDelay(
        minDelay: Durations.short1,
        delayCurve: Curves.easeInCirc,
        placeholder: const SizedBox.expand(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: thumbnail,
        ),
      );
    } else {
      effectiveThumbnail = const Center(
        child: Icon(
          WerkbankIcons.empty,
          size: 96,
        ),
      );
    }
    return WButtonBase(
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: effectiveThumbnail,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _PathLabel(
                nameSegments: nameSegments,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PathLabel extends StatelessWidget {
  const _PathLabel({
    required this.nameSegments,
  });

  final List<String> nameSegments;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.werkbankTextTheme;
    final colorScheme = context.werkbankColorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        WPathText(
          nameSegments: nameSegments.take(nameSegments.length - 1).toList(),
          isRelative: true,
          isDirectory: true,
          overflow: TextOverflow.ellipsis,
          style: textTheme.textSmall.copyWith(
            color: colorScheme.textLight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          nameSegments.last,
          overflow: TextOverflow.ellipsis,
          style: textTheme.detail.copyWith(
            color: colorScheme.text,
          ),
        ),
      ],
    );
  }
}
