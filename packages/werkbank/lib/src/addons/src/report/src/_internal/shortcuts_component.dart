import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:werkbank/src/_internal/src/widgets/widgets.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/theme/theme.dart';
import 'package:werkbank/src/utils/utils.dart';

class ShortcutsComponent extends StatelessWidget {
  const ShortcutsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final addonsWithShortcuts = HomePageComponent.access
        .addonsOf(context)
        .values
        .where((addon) => addon.description != null)
        .where((addon) => addon.description!.shortcuts.isNotEmpty)
        .toList();
    final werkbankShortcutsSections = WerkbankShortcuts.shortcutsSections(
      context,
    );
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final (index, shortcutSection)
            in werkbankShortcutsSections.indexed)
          Padding(
            padding: EdgeInsets.only(
              bottom:
                  (index == werkbankShortcutsSections.length - 1 &&
                      addonsWithShortcuts.isEmpty)
                  ? 0
                  : 16,
            ),
            child: _ShortcutInfo(shortcutsSection: shortcutSection),
          ),
        for (final (index, addon) in addonsWithShortcuts.indexed)
          for (final (shortcutSection) in addon.description!.shortcuts)
            Padding(
              padding: EdgeInsets.only(
                bottom: index == addonsWithShortcuts.length - 1 ? 0 : 16,
              ),
              child: _ShortcutInfo(shortcutsSection: shortcutSection),
            ),
      ],
    );
  }
}

class _ShortcutInfo extends StatelessWidget {
  const _ShortcutInfo({
    required this.shortcutsSection,
  });

  final ShortcutsSection shortcutsSection;

  @override
  Widget build(BuildContext context) {
    const shift = '⇧';
    final ctlKey = context.isApple ? '⌘' : 'Ctrl';
    final altKey = context.isApple ? '⌥' : 'Alt';
    final textTheme = context.werkbankTextTheme;
    return DefaultTextStyle.merge(
      style: TextStyle(color: context.werkbankColorScheme.text),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            shortcutsSection.title,
            style: textTheme.headline,
          ),
          if (shortcutsSection.subTitle != null)
            Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                shortcutsSection.subTitle!,
                style: textTheme.defaultText,
              ),
            ),
          const SizedBox(height: 8),
          for (final (index, shortcut)
              in shortcutsSection.shortcuts.entries.indexed)
            Padding(
              padding: EdgeInsets.only(
                left: 4,
                right: 4,
                top: index == 0 ? 0 : 4,
              ),
              child: WShortcut(
                keyStrokes: shortcut.key.map((keyOrText) {
                  if (keyOrText.text != null) {
                    return keyOrText.text!;
                  }

                  final key = keyOrText.key!;

                  if (LogicalKeyboardKey.shift == key) {
                    return shift;
                  }
                  if ([
                    LogicalKeyboardKey.control,
                    LogicalKeyboardKey.meta,
                  ].contains(key)) {
                    return ctlKey;
                  }
                  if (LogicalKeyboardKey.alt == key) {
                    return altKey;
                  }

                  return key.keyLabel;
                }).toList(),
                description: shortcut.value,
              ),
            ),
        ],
      ),
    );
  }
}
