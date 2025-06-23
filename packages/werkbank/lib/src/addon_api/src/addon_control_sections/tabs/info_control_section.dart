import 'package:werkbank/werkbank.dart';

class InfoControlSection extends AddonControlSection {
  const InfoControlSection({
    required super.id,
    required super.title,
    required super.children,
    super.sortHint = SortHint.central,
  });

  static const access = InfoControlSectionAccessor();
}

class InfoControlSectionAccessor extends AddonControlSectionAccessor
    with UseCaseAccessorMixin {
  const InfoControlSectionAccessor();

  @override
  String get containerName => 'InfoControlSection';
}
