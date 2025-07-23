import 'package:werkbank/src/addon_api/src/accessor/addon_control_section_accessor.dart';
import 'package:werkbank/src/addon_api/src/accessor/use_case_accessor_mixin.dart';
import 'package:werkbank/src/addon_api/src/addon_control_sections/addon_control_section.dart';
import 'package:werkbank/src/utils/utils.dart';

class ConfigureControlSection extends AddonControlSection {
  const ConfigureControlSection({
    required super.id,
    required super.title,
    required super.children,
    super.sortHint = SortHint.central,
  });

  static const access = ConfigureControlSectionAccessor();
}

class ConfigureControlSectionAccessor extends AddonControlSectionAccessor
    with UseCaseAccessorMixin {
  const ConfigureControlSectionAccessor();

  @override
  String get containerName => 'ConfigureControlSection';
}
