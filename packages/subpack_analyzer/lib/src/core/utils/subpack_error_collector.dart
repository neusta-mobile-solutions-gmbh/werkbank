import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mason_logger/mason_logger.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_logger.dart';
import 'package:subpack_analyzer/src/core/utils/subpack_error.dart';

class SubpackErrorCollector<T extends SubpackError> with SubpackLogger {
  SubpackErrorCollector({required Logger logger}) {
    logger = logger;
  }
  final _errors = <T>[];

  bool get isEmpty => _errors.isEmpty;

  void add(T error) {
    _errors.add(error);
  }

  ISet<T> toISet() {
    return _errors.toISet();
  }
}
