import 'package:werkbank/werkbank.dart';

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

/* TODO(lzuttermeister): We likely want to remove the
     UseCaseSpecificAccessorMixin here. */
class AffiliationTransitionLayerEntryAccessor extends AddonLayerAccessor
    with MaybeWerkbankAppAccessor {
  const AffiliationTransitionLayerEntryAccessor();

  @override
  String get containerName => 'AffiliationTransitionLayerEntry';
}
