import 'package:werkbank/werkbank.dart';

class UseCaseControlSection extends AddonControlSection {
  const UseCaseControlSection({
    required super.id,
    required super.title,
    required super.children,
    super.sortHint = SortHint.central,
  });

  static const access = UseCaseControlSectionAccessor();
}

class UseCaseControlSectionAccessor extends AddonControlSectionAccessor
    with UseCaseAccessorMixin {
  const UseCaseControlSectionAccessor();

  @override
  String get containerName => 'UseCaseControlSection';
}
