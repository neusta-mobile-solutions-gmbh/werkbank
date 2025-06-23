import 'package:werkbank/werkbank.dart';

/// An enum that describes in which environment the use case is displayed
/// within a [WerkbankApp].
enum UseCaseEnvironment {
  /// The use case is displayed fully within the main view.
  regular,

  /// The use case is displayed as a thumbnail in the overview.
  overview,
}
