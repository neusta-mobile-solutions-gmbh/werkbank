import 'package:werkbank/src/addon_api/src/accessor/addon_layer_accessor.dart';
import 'package:werkbank/src/addon_api/src/accessor/werkbank_app_only_accessor.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/addon_layer_entry.dart';
import 'package:werkbank/src/utils/utils.dart';

class ApplicationOverlayLayerEntry extends AddonLayerEntry {
  const ApplicationOverlayLayerEntry({
    required super.id,
    super.before = const [],
    super.after = const [],
    super.sortHint = SortHint.central,
    required super.builder,
  }) : super(appOnly: true, includeInOverlay: true);

  static const access = ApplicationOverlayLayerEntryAccessor();
}

class ApplicationOverlayLayerEntryAccessor extends AddonLayerAccessor
    with WerkbankAppOnlyAccessor {
  const ApplicationOverlayLayerEntryAccessor();

  @override
  String get containerName => 'ApplicationOverlayLayerEntry';
}
