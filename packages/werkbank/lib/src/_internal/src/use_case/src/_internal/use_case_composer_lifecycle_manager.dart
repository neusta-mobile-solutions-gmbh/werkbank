import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/use_case/src/_internal/use_case_composer_impl.dart';
import 'package:werkbank/src/_internal/src/use_case/src/_internal/use_case_composition_impl.dart';

class UseCaseComposerLifecycleManager {
  UseCaseComposerLifecycleManager._(
    this._buildResult,
    this._composer,
  );

  factory UseCaseComposerLifecycleManager.initialize(
    UseCaseDescriptor useCaseDescriptor, {
    required AddonConfig addonConfig,
  }) {
    return UseCaseComposerLifecycleManager._initialize(
      useCaseDescriptor,
      addonConfig: addonConfig,
      failedBuild: null,
    );
  }

  factory UseCaseComposerLifecycleManager._initialize(
    UseCaseDescriptor useCaseDescriptor, {
    required AddonConfig addonConfig,
    required UseCaseFailedBuild? failedBuild,
  }) {
    final hasFailedBuild = failedBuild != null;
    try {
      final composer = UseCaseComposerImpl(
        useCase: useCaseDescriptor.node,
        transientStateEntries: [
          for (final addon in addonConfig.addons)
            ...addon.createTransientUseCaseStateEntries(),
        ],
        activeAddonIds: {
          for (final addon in addonConfig.addons) addon.id,
        },
      );
      try {
        for (final node in useCaseDescriptor.nodePath) {
          switch (node) {
            case WerkbankParentNode():
              composer.setNode(node);
              if (!hasFailedBuild) {
                node.builder?.call(composer);
              }
            case WerkbankUseCase():
              // This can only be the last node, so we handle the case below.
              break;
          }
        }
        composer.setNode(useCaseDescriptor.node);
        final buildResult =
            failedBuild ??
            UseCaseSuccessfulBuild(
              useCaseDescriptor.node.builder(composer),
            );
        composer.runLateExecutionCallbacks();
        return UseCaseComposerLifecycleManager._(
          buildResult,
          composer,
        );
      } catch (_) {
        composer.abortAndDispose();
        rethrow;
      }
    } on Object catch (e, stackTrace) {
      debugPrint(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      return UseCaseComposerLifecycleManager._initialize(
        useCaseDescriptor,
        addonConfig: addonConfig,
        failedBuild: UseCaseFailedBuild(e, stackTrace),
      );
    }
  }

  final UseCaseBuildResult _buildResult;
  final UseCaseComposerImpl _composer;

  UseCaseMetadata getMetadataAndDispose() {
    return _composer.getMetadataAndDispose();
  }

  CompositionResult convertToCompositionAndDispose({
    required BuildContext context,
    UseCaseSnapshot? useCaseSnapshot,
    UseCaseStateMutation? initialMutation,
    required UseCaseController controller,
  }) {
    final composition = _composer.composeAndDispose(controller);
    for (final entry in composition.transientStateEntries) {
      entry.prepareForBuild(composition, context);
    }
    composition.rebuildListenable = Listenable.merge(
      composition.transientStateEntries.map(
        (entry) => entry.createRebuildListenable(),
      ),
    );
    if (initialMutation != null) {
      composition.mutate(initialMutation);
    }
    if (useCaseSnapshot != null) {
      composition.loadSnapshot(useCaseSnapshot);
    }
    return CompositionResult._(
      composition,
      _buildResult,
    );
  }
}

sealed class UseCaseBuildResult {
  const UseCaseBuildResult();
}

class UseCaseSuccessfulBuild extends UseCaseBuildResult {
  const UseCaseSuccessfulBuild(this.widgetBuilder);

  final WidgetBuilder widgetBuilder;
}

class UseCaseFailedBuild extends UseCaseBuildResult {
  const UseCaseFailedBuild(this.error, this.stackTrace);

  final Object error;
  final StackTrace stackTrace;
}

class CompositionResult {
  const CompositionResult._(this.composition, this.buildResult);

  final UseCaseCompositionImpl composition;
  final UseCaseBuildResult buildResult;
}
