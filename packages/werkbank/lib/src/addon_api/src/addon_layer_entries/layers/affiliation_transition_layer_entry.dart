import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/utils/utils.dart';

class AffiliationTransitionLayerEntry extends AddonLayerEntry {
  const AffiliationTransitionLayerEntry({
    required super.id,
    super.appOnly = false,
    super.includeInOverlay = true,
    super.before = const [],
    super.after = const [],
    super.sortHint = SortHint.central,
    required super.builder,
  });

  static const access = AffiliationTransitionLayerEntryAccessor();
}

class AffiliationTransitionLayerEntryAccessor extends AddonLayerAccessor
    with MaybeWerkbankAppAccessor {
  const AffiliationTransitionLayerEntryAccessor();

  @override
  String get containerName => 'AffiliationTransitionLayerEntry';
}
