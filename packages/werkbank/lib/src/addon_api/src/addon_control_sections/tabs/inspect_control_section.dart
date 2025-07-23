import 'package:werkbank/src/addon_api/src/accessor/addon_control_section_accessor.dart';
import 'package:werkbank/src/addon_api/src/accessor/use_case_accessor_mixin.dart';
import 'package:werkbank/src/addon_api/src/addon_control_sections/addon_control_section.dart';
import 'package:werkbank/src/utils/utils.dart';

class InspectControlSection extends AddonControlSection {
  const InspectControlSection({
    required super.id,
    required super.title,
    required super.children,
    super.sortHint = SortHint.central,
  });

  static const access = InspectControlSectionAccessor();
}

class InspectControlSectionAccessor extends AddonControlSectionAccessor
    with UseCaseAccessorMixin {
  const InspectControlSectionAccessor();

  @override
  String get containerName => 'InspectControlSection';
}
