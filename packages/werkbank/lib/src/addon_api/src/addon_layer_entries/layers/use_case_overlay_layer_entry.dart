import 'package:werkbank/src/addon_api/src/accessor/addon_layer_accessor.dart';
import 'package:werkbank/src/addon_api/src/accessor/use_case_accessor_mixin.dart';
import 'package:werkbank/src/addon_api/src/accessor/werkbank_app_only_accessor.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/addon_layer_entry.dart';
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
