import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/utils/utils.dart';

class UseCaseOverlayLayerEntry extends AddonLayerEntry {
  const UseCaseOverlayLayerEntry({
    required super.id,
    super.includeInOverlay = true,
    super.before = const [],
    super.after = const [],
    super.sortHint = SortHint.central,
    required super.builder,
  }) : super(appOnly: true);

  static const access = UseCaseOverlayLayerEntryAccessor();
}

class UseCaseOverlayLayerEntryAccessor extends AddonLayerAccessor
    with WerkbankAppOnlyAccessor, UseCaseAccessorMixin {
  const UseCaseOverlayLayerEntryAccessor();

  @override
  String get containerName => 'UseCaseOverlayLayerEntry';
}
