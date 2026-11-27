import 'package:material_ui/material_ui.dart';

@immutable
class ImmutableStateHolderSnapshot {
  const ImmutableStateHolderSnapshot({
    required this.value,
  });

  final Object? value;
}
