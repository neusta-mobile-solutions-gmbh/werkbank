import 'package:werkbank/src/addon_api/src/accessor/addon_layer_accessor.dart';
import 'package:werkbank/src/addon_api/src/accessor/maybe_werkbank_app_accessor.dart';
import 'package:werkbank/src/addon_api/src/accessor/use_case_accessor_mixin.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/addon_layer_entry.dart';
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
    with MaybeWerkbankAppAccessor, UseCaseAccessorMixin {
  const UseCaseFittedLayerEntryAccessor();

  @override
  String get containerName => 'UseCaseFittedLayerEntry';
}
