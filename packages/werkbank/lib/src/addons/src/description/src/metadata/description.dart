import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class Descriptions extends UseCaseMetadataEntry<Descriptions> {
  const Descriptions({
    required this.sectionsDescription,
    required this.folderDescriptions,
    required this.componentDescription,
    required this.useCaseDescription,
  });

  static const empty = Descriptions(
    sectionsDescription: null,
    folderDescriptions: [],
    componentDescription: null,
    useCaseDescription: null,
  );

  final DescriptionEntry<WerkbankSections>? sectionsDescription;
  final List<DescriptionEntry<WerkbankFolder>> folderDescriptions;
  final DescriptionEntry<WerkbankComponent>? componentDescription;
  final DescriptionEntry<WerkbankUseCase>? useCaseDescription;

  Descriptions copyWith({
    DescriptionEntry<WerkbankSections>? sectionsDescription,
    List<DescriptionEntry<WerkbankFolder>>? folderDescriptions,
    DescriptionEntry<WerkbankComponent>? componentDescription,
    DescriptionEntry<WerkbankUseCase>? useCaseDescription,
  }) => Descriptions(
    sectionsDescription: sectionsDescription ?? this.sectionsDescription,
    folderDescriptions: folderDescriptions ?? this.folderDescriptions,
    componentDescription: componentDescription ?? this.componentDescription,
    useCaseDescription: useCaseDescription ?? this.useCaseDescription,
  );
}

extension DescriptionMetadataExtension on UseCaseMetadata {
  Descriptions get descriptions => get<Descriptions>() ?? Descriptions.empty;
}

/// Defines how a new description should be merged with an existing one.
enum DescriptionMergeStrategy {
  /// Appends the new description to the existing one.
  append,

  /// Prepends the new description before the existing one.
  prepend,

  /// Replaces the existing description with the new one.
  overwrite,
}

extension DescriptionComposerExtension on UseCaseComposer {
  /// Adds a [description] to a use case, component, folder or the root.
  /// The descriptions of a use case and all its ancestors are displayed
  /// for a use case in the "INSPECT" tab.
  ///
  /// The [mergeStrategy] defines how the new description
  /// should be merged with an existing one.
  /// See [DescriptionMergeStrategy] for its values.
  ///
  /// If [forUseCase] is `true`, the description is added
  /// to the [useCase] instead of the current [node].
  void description(
    String description, {
    DescriptionMergeStrategy mergeStrategy = DescriptionMergeStrategy.append,
    bool forUseCase = false,
  }) {
    final currentDescriptions =
        getMetadata<Descriptions>() ?? Descriptions.empty;
    final descriptionNode = forUseCase ? useCase : node;
    final trimmedDescription = description.trim();

    DescriptionEntry<T> tryMergeIntoEntry<T extends WerkbankNode>({
      required DescriptionEntry<T>? entry,
      required T node,
    }) {
      assert(
        entry == null || entry.node == node,
        'The node of the entry must match the current node.',
      );

      if (entry == null) {
        return DescriptionEntry<T>(
          description: trimmedDescription,
          node: node,
        );
      }

      // Apply the merge strategy
      final mergedDescription = switch (mergeStrategy) {
        DescriptionMergeStrategy.append =>
          '${entry.description}\n\n$trimmedDescription',
        DescriptionMergeStrategy.prepend =>
          '$trimmedDescription\n\n${entry.description}',
        DescriptionMergeStrategy.overwrite => trimmedDescription,
      };

      return DescriptionEntry<T>(
        description: mergedDescription,
        node: node,
      );
    }

    switch (descriptionNode) {
      // We treat description on the root as a folder description.
      case WerkbankSections():
        setMetadata(
          currentDescriptions.copyWith(
            sectionsDescription: tryMergeIntoEntry(
              entry: currentDescriptions.sectionsDescription,
              node: descriptionNode,
            ),
          ),
        );
      case WerkbankFolder():
        final lastFolder = currentDescriptions.folderDescriptions.lastOrNull;
        final current = lastFolder?.node == descriptionNode ? lastFolder : null;
        final newEntry = tryMergeIntoEntry(
          entry: current,
          node: descriptionNode,
        );
        final newFolderDescriptions = currentDescriptions.folderDescriptions
            .toList();
        if (current != null) {
          newFolderDescriptions[newFolderDescriptions.length - 1] = newEntry;
        } else {
          newFolderDescriptions.add(newEntry);
        }
        setMetadata(
          currentDescriptions.copyWith(
            folderDescriptions: newFolderDescriptions,
          ),
        );
      case WerkbankComponent():
        setMetadata(
          currentDescriptions.copyWith(
            componentDescription: tryMergeIntoEntry(
              entry: currentDescriptions.componentDescription,
              node: descriptionNode,
            ),
          ),
        );
      case WerkbankUseCase():
        setMetadata(
          currentDescriptions.copyWith(
            useCaseDescription: tryMergeIntoEntry(
              entry: currentDescriptions.useCaseDescription,
              node: descriptionNode,
            ),
          ),
        );
    }

    /* TODO(lzuttermeister): We probably need to add a minimum match size
         or something, so that this does not produce to many matches. */
    addSearchCluster(
      SearchCluster(
        semanticDescription: 'Description',
        field: 'desc',
        entries: [
          FuzzySearchEntry(
            searchString: trimmedDescription,
            scoreThreshold: .1,
          ),
        ],
      ),
    );
  }
}

class DescriptionEntry<T extends WerkbankNode> {
  DescriptionEntry({
    required this.description,
    required this.node,
  });

  final String description;
  final T node;
}
