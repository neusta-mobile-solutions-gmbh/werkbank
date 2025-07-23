import 'package:werkbank/werkbank_old.dart';

class WrappingStateEntry
    extends
        TransientUseCaseStateEntry<
          WrappingStateEntry,
          TransientUseCaseStateSnapshot
        > {
  final Map<WrappingLayer, List<WrapperBuilder>> _wrappersForLayer = {};

  void addWrapper(
    WrapperBuilder builder, {
    WrappingLayer layer = WrappingLayer.fitted,
  }) {
    (_wrappersForLayer[layer] ??= []).add(builder);
  }

  List<WrapperBuilder> getWrappers(WrappingLayer layer) =>
      _wrappersForLayer[layer] ?? [];

  @override
  void loadSnapshot(TransientUseCaseStateSnapshot snapshot) {}

  @override
  TransientUseCaseStateSnapshot saveSnapshot() =>
      const TransientUseCaseStateSnapshot();
}
