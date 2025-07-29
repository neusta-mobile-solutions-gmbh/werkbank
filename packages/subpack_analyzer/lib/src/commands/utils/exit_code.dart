enum SubpackExitCode {
  success(0),
  invalidDependencies(3),
  undependedUsages(4);

  const SubpackExitCode(this.code);

  final int code;
}
