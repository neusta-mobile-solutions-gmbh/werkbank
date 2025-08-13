import 'package:werkbank/werkbank.dart';

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
