import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:werkbank/src/werkbank_internal.dart';

/// {@category Writing Your Own Addons}
/// {@category Custom Addons}
@immutable
abstract class Addon {
  const Addon({required this.id});

  /// A string that uniquely identifies this addon.
  final String id;

  /// Builds the [LocalizationsDelegate]s that are use for UI introduced by
  /// this addon.
  /// These localizations are not meant to be used inside the use case
  /// itself, but only for the UI that conceptually belongs to the interface of
  /// the addon.
  List<LocalizationsDelegate<Object?>> buildLocalizationsDelegates(
    BuildContext context,
  ) => [];

  // TODO: Document
  List<PersistentController> createPersistentControllers() => [];

  /// Creates [TransientUseCaseStateEntry]s which are attached to the
  /// [UseCaseComposer] at the beginning of the use case setup.
  /// The created transient state entries can be retrieved via the
  /// [UseCaseComposition] returned by
  /// [UseCaseAccessorMixin.compositionOf].
  /// See [UseCaseAccessorMixin] on how to obtain an instance.
  List<AnyTransientUseCaseStateEntry> createTransientUseCaseStateEntries() =>
      [];

  /// Creates [RetainedUseCaseStateEntry]s which can keep state for the whole
  /// lifetime of the use case.
  /// The created retained state entries can be retrieved via the
  /// [UseCaseComposition] returned by
  /// [UseCaseAccessorMixin.compositionOf].
  /// See [UseCaseAccessorMixin] on how to obtain an instance.
  List<AnyRetainedUseCaseStateEntry> createRetainedUseCaseStateEntries() => [];

  /// Builds the control sections to be added into the "CONFIGURE" tab.
  ///
  /// All methods on [ConfigureControlSection.access] can be used with the
  /// [context] of this builder and within the widgets built in the
  /// [ConfigureControlSection.children].
  ///
  /// {@template werkbank.application_layers_in_context}
  /// The widgets introduced in the [AddonLayerEntries.management] and
  /// [AddonLayerEntries.applicationOverlay] are
  /// ancestors of the [context] passed to this method.
  /// This means for example all inherited widgets introduced there are
  /// available in the [context].
  /// {@endtemplate}
  List<ConfigureControlSection> buildConfigureTabControlSections(
    BuildContext context,
  ) => [];

  /// Builds the control sections to be added into the "INSPECT" tab.
  ///
  /// All methods on [InspectControlSection.access] can be used with the
  /// [context] of this builder and within the widgets built in the
  /// [InspectControlSection.children].
  ///
  /// {@macro werkbank.application_layers_in_context}
  List<InspectControlSection> buildInspectTabControlSections(
    BuildContext context,
  ) => [];

  /// Builds the control sections to be added into the "ADDON" tab.
  ///
  /// All methods on [SettingsControlSection.access] can be used with the
  /// [context] of this builder and within the widgets built in the
  /// [SettingsControlSection.children].
  ///
  /// {@macro werkbank.application_layers_in_context}
  List<SettingsControlSection> buildSettingsTabControlSections(
    BuildContext context,
  ) => [];

  /// Builds a list of [HomePageComponent] for the homepage.
  /// This method can be overridden to provide custom
  /// components for the homepage.
  ///
  /// All methods on [HomePageComponent.access] can be used with the
  /// [context] of this builder and within the widgets built in the
  /// [HomePageComponent.child].
  ///
  /// {@macro werkbank.application_layers_in_context}
  List<HomePageComponent> buildHomePageComponents(
    BuildContext context,
  ) => [];

  AddonLayerEntries get layers => AddonLayerEntries();

  /// Add a description to the addon. This may be used in multiple ways
  /// and places in the future.
  /// For instance, the InfoAddon displays these descriptions on the homepage,
  /// if it is configured to do so.
  ///
  AddonDescription? buildDescription(BuildContext context) => null;
}
