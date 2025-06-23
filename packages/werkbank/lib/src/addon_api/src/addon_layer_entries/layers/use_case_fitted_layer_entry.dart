import 'package:werkbank/werkbank.dart';

class UseCaseFittedLayerEntry extends AddonLayerEntry {
  const UseCaseFittedLayerEntry({
    required super.id,
    super.appOnly = false,
    super.includeInOverlay = true,
    super.before = const [],
    super.after = const [],
    super.sortHint = SortHint.central,
    required super.builder,
  });

  static const access = UseCaseFittedLayerEntryAccessor();
}

class UseCaseFittedLayerEntryAccessor extends AddonLayerAccessor
    with MaybeWerkbankAppAccessor, UseCaseAccessorMixin {
  const UseCaseFittedLayerEntryAccessor();

  @override
  String get containerName => 'UseCaseFittedLayerEntry';
}
