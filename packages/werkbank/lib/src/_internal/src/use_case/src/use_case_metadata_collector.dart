import 'package:werkbank/src/_internal/src/use_case/src/_internal/use_case_composer_lifecycle_manager.dart';
import 'package:werkbank/werkbank.dart';

// TODO(lzuttermeister): Do not expose publicly.
class UseCaseMetadataCollector {
  UseCaseMetadataCollector._();

  static UseCaseMetadata collect({
    required UseCaseDescriptor useCaseDescriptor,
    required AddonConfig addonConfig,
  }) {
    final composerManager = UseCaseComposerLifecycleManager.initialize(
      useCaseDescriptor,
      addonConfig: addonConfig,
    );
    return composerManager.getMetadataAndDispose();
  }
}
