import 'package:werkbank/werkbank.dart';

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
