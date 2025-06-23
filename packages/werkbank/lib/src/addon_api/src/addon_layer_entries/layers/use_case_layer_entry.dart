import 'package:werkbank/werkbank.dart';

class UseCaseLayerEntry extends AddonLayerEntry {
  const UseCaseLayerEntry({
    required super.id,
    super.appOnly = false,
    super.includeInOverlay = true,
    super.before = const [],
    super.after = const [],
    super.sortHint = SortHint.central,
    required super.builder,
  });

  static const access = UseCaseLayerEntryAccessor();
}

class UseCaseLayerEntryAccessor extends AddonLayerAccessor
    with MaybeWerkbankAppAccessor, UseCaseAccessorMixin {
  const UseCaseLayerEntryAccessor();

  @override
  String get containerName => 'UseCaseLayerEntry';
}
