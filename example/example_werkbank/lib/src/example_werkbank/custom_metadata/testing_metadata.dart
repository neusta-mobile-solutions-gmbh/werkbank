import 'package:werkbank/werkbank.dart';

/// A class that holds metadata that influences the behavior of
/// the use case tests.
class TestingMetadata extends UseCaseMetadataEntry<TestingMetadata> {
  const TestingMetadata({this.include = true});

  /// Whether to include the use case in testing.
  final bool include;

  UseCaseMetadataEntry<TestingMetadata> copyWith({
    bool? include,
  }) {
    return TestingMetadata(
      include: include ?? this.include,
    );
  }
}

/// An extension on [UseCaseComposer] that provides a [testing] object to
/// configure testing-related metadata for the use case.
extension TestingComposerExtension on UseCaseComposer {
  TestingComposer get testing => TestingComposer._(this);
}

/// An extension type that provides methods to configure testing-related
/// metadata.
extension type TestingComposer._(UseCaseComposer _c) {
  TestingMetadata get _current =>
      _c.getMetadata<TestingMetadata>() ?? const TestingMetadata();

  /// Exclude the use case from testing.
  void exclude() => _c.setMetadata(_current.copyWith(include: false));
}

/// An extension on [UseCaseMetadata] that provides a [testing] object to
extension TestingMetadataExtension on UseCaseMetadata {
  TestingMetadata get testing =>
      get<TestingMetadata>() ?? const TestingMetadata();
}
