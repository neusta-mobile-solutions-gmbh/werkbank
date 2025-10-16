import 'package:werkbank/src/addon_api/addon_api.dart';
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
    with UseCaseAccessor {
  const ConfigureControlSectionAccessor();

  @override
  String get containerName => 'ConfigureControlSection';
}
