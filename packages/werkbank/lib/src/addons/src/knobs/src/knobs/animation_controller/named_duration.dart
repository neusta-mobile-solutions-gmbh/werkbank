import 'package:equatable/equatable.dart';

class NamedDuration with EquatableMixin implements Comparable<NamedDuration> {
  const NamedDuration(
    this.name,
    this.duration,
  );

  final String name;
  final Duration duration;

  String millisString() => '${duration.inMilliseconds}ms';

  String nameWithMillis() => '$name (${millisString()})';

  @override
  int compareTo(NamedDuration other) => duration.compareTo(other.duration);

  @override
  List<Object?> get props => [
    name,
    duration,
  ];
}
