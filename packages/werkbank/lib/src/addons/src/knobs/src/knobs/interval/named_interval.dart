import 'package:equatable/equatable.dart';

class NamedInterval with EquatableMixin {
  const NamedInterval(
    this.begin,
    this.end,
  );

  final NamedDouble begin;
  final NamedDouble end;

  @override
  List<Object?> get props => [
    begin,
    end,
  ];
}

class NamedDouble with EquatableMixin {
  const NamedDouble(
    this.name,
    this.value,
  );

  final String name;
  final double value;

  @override
  List<Object?> get props => [
    name,
    value,
  ];
}
