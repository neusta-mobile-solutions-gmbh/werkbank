import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_error.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_logger.dart';

class SubpackErrorCollector<T extends SubpackError> with SubpackLogger {
  SubpackErrorCollector();
  final _errors = <T>[];

  bool get isEmpty => _errors.isEmpty;

  void add(T error) {
    _errors.add(error);
  }

  ISet<T> toISet() {
    return _errors.toISet();
  }
}
