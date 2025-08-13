import 'package:equatable/equatable.dart';
import 'package:werkbank/src/addons/src/constraints/constraints.dart';

class ViewConstraintsPreset with EquatableMixin {
  const ViewConstraintsPreset({
    required this.name,
    required this.viewConstraints,
  });

  final String name;
  final ViewConstraints viewConstraints;

  @override
  List<Object?> get props => [
    name,
    viewConstraints,
  ];
}
