import 'package:werkbank/werkbank.dart';

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
