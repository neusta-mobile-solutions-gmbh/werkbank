import 'package:werkbank/werkbank.dart';

/// An [AddonSpecification] is a simplified representation of an [Addon] that
/// is available to other addons. It can be used in an [Addon] to make
/// conditional decisions based on the availability of other addons, but not
/// on their actual implementation.
class AddonSpecification {
  AddonSpecification({
    required this.id,
    required this.description,
  });

  final String id;

  final AddonDescription? description;
}
