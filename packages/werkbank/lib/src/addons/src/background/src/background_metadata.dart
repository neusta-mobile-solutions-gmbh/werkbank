import 'package:flutter/material.dart';
import 'package:werkbank/src/use_case/use_case.dart';

extension BackgroundMetadataExtension on UseCaseMetadata {
  DefaultBackgroundOption? get backgroundOption =>
      get<DefaultBackgroundOption>();
}

sealed class DefaultBackgroundOption
    extends UseCaseMetadataEntry<DefaultBackgroundOption> {}

class NamedBackgroundOption extends DefaultBackgroundOption {
  NamedBackgroundOption({required this.name});

  final String name;
}

class CustomBackgroundOption extends DefaultBackgroundOption {
  CustomBackgroundOption({required this.backgroundWidget});

  final Widget backgroundWidget;
}
