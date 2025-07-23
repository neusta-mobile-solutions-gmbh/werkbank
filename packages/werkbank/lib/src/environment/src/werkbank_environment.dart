import 'package:werkbank/src/widgets/widgets.dart';

/// An enum that describes in which environment everything is built.
enum WerkbankEnvironment {
  /// The widgets are in the context of a [WerkbankApp].
  app,

  /// The widgets are in the context of a [DisplayApp].
  display,
}
