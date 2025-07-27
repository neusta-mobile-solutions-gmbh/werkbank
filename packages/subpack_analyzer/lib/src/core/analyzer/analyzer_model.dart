import 'package:fast_immutable_collections/fast_immutable_collections.dart';

import 'package:subpack_analyzer/src/core/analyzer/analyzer_error_model.dart';

sealed class AnalyzerModel {}

class AnalyzerSuccessModel extends AnalyzerModel {}

class AnalyzerFailiureModel extends AnalyzerModel {
  AnalyzerFailiureModel({required this.errors});

  final ISet<AnalyzerError> errors;
}
