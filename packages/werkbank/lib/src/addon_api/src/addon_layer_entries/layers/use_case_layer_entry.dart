import 'package:werkbank/src/addon_api/src/accessor/addon_layer_accessor.dart';
import 'package:werkbank/src/addon_api/src/accessor/maybe_werkbank_app_accessor.dart';
import 'package:werkbank/src/addon_api/src/accessor/use_case_accessor_mixin.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/addon_layer_entry.dart';
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
    with MaybeWerkbankAppAccessor, UseCaseAccessorMixin {
  const UseCaseLayerEntryAccessor();

  @override
  String get containerName => 'UseCaseLayerEntry';
}
