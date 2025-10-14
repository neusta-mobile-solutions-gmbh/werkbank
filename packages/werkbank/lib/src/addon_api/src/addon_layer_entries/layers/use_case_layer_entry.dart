import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/utils/utils.dart';

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
    with MaybeWerkbankAppAccessor, UseCaseAccessor {
  const UseCaseLayerEntryAccessor();

  @override
  String get containerName => 'UseCaseLayerEntry';
}
