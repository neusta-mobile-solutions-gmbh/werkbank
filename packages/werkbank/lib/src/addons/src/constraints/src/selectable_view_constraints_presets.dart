import 'package:equatable/equatable.dart';

sealed class SelectableViewConstraintsPreset with EquatableMixin {
  const SelectableViewConstraintsPreset();
}

class InitialViewConstraintsPreset extends SelectableViewConstraintsPreset {
  const InitialViewConstraintsPreset();

  @override
  List<Object?> get props => [];
}

class DefinedViewConstraintsPreset extends SelectableViewConstraintsPreset {
  const DefinedViewConstraintsPreset(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}
