import 'package:werkbank/werkbank.dart';

class SettingsControlSection extends AddonControlSection {
  const SettingsControlSection({
    required super.id,
    required super.title,
    required super.children,
    super.sortHint = SortHint.central,
  });

  static const access = SettingsControlSectionAccessor();
}

class SettingsControlSectionAccessor extends AddonControlSectionAccessor {
  const SettingsControlSectionAccessor();

  @override
  String get containerName => 'SettingsControlSection';
}
