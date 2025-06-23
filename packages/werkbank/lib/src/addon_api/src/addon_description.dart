import 'package:flutter/services.dart';
import 'package:meta/meta.dart';
import 'package:werkbank/werkbank.dart';

class AddonDescription {
  AddonDescription({
    required this.shortcuts,
    required this.markdownDescription,
    this.priority = DescriptionPriority.moderate,
  });

  static const access = AddonDescriptionAccessor();

  /// Shortcuts for the addon.
  /// This does not implement any behavior, it is just
  /// for the user to know what shortcuts are available.
  ///
  /// The priority does not affect the order of those shortcuts
  final List<ShortcutsSection> shortcuts;

  /// Not used yet
  /// A markdown description of the addon
  final String markdownDescription;

  /// Not used yet
  /// If the addon is self-explaning, you can set a lower priority
  /// Vice versa, if the addon is complex, set a higher priority
  /// and provide a detailed description
  final DescriptionPriority priority;
}

class AddonDescriptionAccessor extends AddonAccessor
    with WerkbankAppOnlyAccessor {
  const AddonDescriptionAccessor();

  @override
  String get containerName => 'AddonDescription';
}

class ShortcutsSection {
  ShortcutsSection({
    required this.title,
    this.subTitle,
    required this.shortcuts,
  });

  final String title;
  final String? subTitle;
  final AddonShortcutsInfoMap shortcuts;
}

typedef AddonShortcutsInfoMap = Map<Set<KeyOrText>, ShortcutInfo>;
typedef ShortcutInfo = String;

class KeyOrText {
  KeyOrText._({
    this.key,
    this.text,
  });

  factory KeyOrText.key(LogicalKeyboardKey key) {
    return KeyOrText._(key: key);
  }

  factory KeyOrText.text(String text) {
    return KeyOrText._(text: text);
  }

  final LogicalKeyboardKey? key;

  // For example if you want to represent a shortcut with a mouse click
  // or a gesture or some other text that is not a key
  final String? text;
}

@immutable
class DescriptionPriority implements Comparable<DescriptionPriority> {
  const DescriptionPriority(this.index);

  static const DescriptionPriority low = DescriptionPriority(-1000);
  static const DescriptionPriority moderate = DescriptionPriority(0);
  static const DescriptionPriority high = DescriptionPriority(1000);
  static const DescriptionPriority urgent = DescriptionPriority(2000);
  static const DescriptionPriority critical = DescriptionPriority(5000);

  final int index;

  @override
  int compareTo(DescriptionPriority other) => index.compareTo(other.index);
}
