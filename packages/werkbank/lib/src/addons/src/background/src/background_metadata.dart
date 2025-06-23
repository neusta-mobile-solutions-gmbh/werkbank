import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

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
  CustomBackgroundOption({required this.backgroundBox});

  final Widget backgroundBox;
}
