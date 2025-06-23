import 'package:werkbank/werkbank.dart';

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
