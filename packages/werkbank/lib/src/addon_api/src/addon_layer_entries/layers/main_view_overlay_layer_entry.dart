import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/utils/utils.dart';

class MainViewOverlayLayerEntry extends AddonLayerEntry {
  const MainViewOverlayLayerEntry({
    required super.id,
    super.before = const [],
    super.after = const [],
    super.sortHint = SortHint.central,
    required super.builder,
  }) : super(appOnly: true, includeInOverlay: true);

  static const access = MainViewOverlayLayerEntryAccessor();
}

class MainViewOverlayLayerEntryAccessor extends AddonLayerAccessor
    with WerkbankAppOnlyAccessor {
  const MainViewOverlayLayerEntryAccessor();

  @override
  String get containerName => 'MainViewOverlayLayerEntry';
}
