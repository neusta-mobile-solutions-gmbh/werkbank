import 'package:werkbank/src/addon_api/src/accessor/addon_layer_accessor.dart';
import 'package:werkbank/src/addon_api/src/addon_layer_entries/addon_layer_entry.dart';
import 'package:werkbank/src/utils/utils.dart';

class ManagementLayerEntry extends AddonLayerEntry {
  const ManagementLayerEntry({
    required super.id,
    super.appOnly = false,
    super.before = const [],
    super.after = const [],
    super.sortHint = SortHint.central,
    required super.builder,
  }) : super(includeInOverlay: true);

  static const access = ManagementLayerEntryAccessor();
}

class ManagementLayerEntryAccessor extends AddonLayerAccessor {
  const ManagementLayerEntryAccessor();

  @override
  String get containerName => 'ManagementLayerEntry';
}
