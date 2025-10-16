import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/utils/utils.dart';

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
    with MaybeWerkbankAppAccessor, UseCaseAccessor {
  const UseCaseFittedLayerEntryAccessor();

  @override
  String get containerName => 'UseCaseFittedLayerEntry';
}
