import 'package:flutter/material.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/tree/tree.dart';
import 'package:werkbank/src/use_case/use_case.dart';
import 'package:werkbank/src/widgets/widgets.dart';

class UseCaseMetadataProvider extends StatefulWidget {
  const UseCaseMetadataProvider({
    super.key,
    required this.child,
  });

  final Widget child;

  static UseCaseMetadata? maybeMetadataForUseCaseOf(
    BuildContext context,
    UseCaseDescriptor useCase,
  ) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<_InheritedMetadataProvider>(
          aspect: useCase,
        );
    if (widget == null) {
      return null;
    }
    final metadata = widget.metadata[useCase];
    if (metadata == null) {
      throw ArgumentError('No metadata found for ${useCase.path}.');
    }
    return metadata;
  }

  static UseCaseMetadata metadataOf(
    BuildContext context,
    UseCaseDescriptor useCase,
  ) {
    final metadata = maybeMetadataForUseCaseOf(context, useCase);
    assert(
      metadata != null,
      'No UseCaseMetadataProvider found in the context.',
    );
    return metadata!;
  }

  static Map<UseCaseDescriptor, UseCaseMetadata>? maybeMetadataMapOf(
    BuildContext context,
  ) {
    final widget = context
        .dependOnInheritedWidgetOfExactType<_InheritedMetadataProvider>();
    return widget?.metadata;
  }

  static Map<UseCaseDescriptor, UseCaseMetadata> metadataMapOf(
    BuildContext context,
  ) {
    final metadataMap = maybeMetadataMapOf(context);
    assert(
      metadataMap != null,
      'No UseCaseMetadataProvider found in the context.',
    );
    return metadataMap!;
  }

  @override
  State<UseCaseMetadataProvider> createState() =>
      _UseCaseMetadataProviderState();
}

class _UseCaseMetadataProviderState extends State<UseCaseMetadataProvider> {
  late Map<UseCaseDescriptor, UseCaseMetadata> metadata;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final addonConfig = AddonConfigProvider.of(context);
    final rootDescriptor = WerkbankAppInfo.rootDescriptorOf(context);
    setState(() {
      metadata = {
        for (final useCase in rootDescriptor.useCases)
          useCase: useCase.computeMetadata(addonConfig),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return _InheritedMetadataProvider(
      metadata: Map.unmodifiable(metadata),
      child: widget.child,
    );
  }
}

class _InheritedMetadataProvider extends InheritedModel<UseCaseDescriptor> {
  const _InheritedMetadataProvider({
    required this.metadata,
    required super.child,
  });

  final Map<UseCaseDescriptor, UseCaseMetadata> metadata;

  @override
  bool updateShouldNotify(_InheritedMetadataProvider oldWidget) {
    return metadata != oldWidget.metadata;
  }

  @override
  bool updateShouldNotifyDependent(
    _InheritedMetadataProvider oldWidget,
    Set<UseCaseDescriptor> dependencies,
  ) {
    return dependencies.any((useCase) {
      final oldMetadata = oldWidget.metadata[useCase];
      final newMetadata = metadata[useCase];
      return oldMetadata != newMetadata;
    });
  }
}
