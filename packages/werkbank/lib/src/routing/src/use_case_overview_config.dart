import 'package:werkbank/src/use_case/use_case.dart';

class UseCaseOverviewConfig {
  UseCaseOverviewConfig({required this.entryBuilder});

  final List<UseCaseOverviewEntry> Function(UseCaseMetadata metadata)
  entryBuilder;
}

class UseCaseOverviewEntry {
  UseCaseOverviewEntry({
    required this.name,
    this.initialMutation,
  });

  final String name;
  final UseCaseStateMutation? initialMutation;
}
