class DuplicateDescriptorPathsException implements Exception {
  DuplicateDescriptorPathsException(this.duplicatePaths);
  late final List<List<String>> duplicatePaths;

  @override
  String toString() =>
      'DuplicateFoundException: '
      '${duplicatePaths.map((path) => path.join('/')).join(', ')}';
}
