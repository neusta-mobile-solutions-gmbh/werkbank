import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class NamedCurve with EquatableMixin {
  const NamedCurve(
    this.name,
    this.trailing,
    this.curve,
  );

  final String name;
  final String? trailing;
  final Curve curve;

  @override
  List<Object?> get props => [
    name,
    trailing,
    curve,
  ];
}
