import 'package:werkbank/src/addon_api/addon_api.dart';
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
    with UseCaseAccessor {
  const InspectControlSectionAccessor();

  @override
  String get containerName => 'InspectControlSection';
}
