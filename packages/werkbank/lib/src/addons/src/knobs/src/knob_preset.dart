import 'package:equatable/equatable.dart';

sealed class KnobPreset with EquatableMixin {
  const KnobPreset();
}

class InitialKnobPreset extends KnobPreset {
  const InitialKnobPreset();

  @override
  List<Object?> get props => [];
}

class DefinedKnobPreset extends KnobPreset {
  const DefinedKnobPreset(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}
