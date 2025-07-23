import 'package:werkbank/src/addon_api/src/accessor/addon_control_section_accessor.dart';
import 'package:werkbank/src/addon_api/src/addon_control_sections/addon_control_section.dart';
import 'package:werkbank/src/utils/utils.dart';

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
