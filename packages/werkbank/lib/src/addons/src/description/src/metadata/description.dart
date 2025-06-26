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

extension DescriptionComposerExtension on UseCaseComposer {
  void description(String description) {
    final currentDescriptions =
        getMetadata<Descriptions>() ?? Descriptions.empty;
    final node = this.node;

    DescriptionEntry<T> tryMergeIntoEntry<T extends WerkbankNode>({
      required DescriptionEntry<T>? entry,
      required T node,
      required String description,
    }) {
      assert(
        entry == null || entry.node == node,
        'The node of the entry must match the current node.',
      );
      if (entry == null) {
        return DescriptionEntry<T>(
          description: description,
          node: node,
        );
      }
      return DescriptionEntry<T>(
        description: '${entry.description.trimRight()}\n\n$description',
        node: node,
      );
    }

    switch (node) {
      // We treat description on the root as a folder description.
      case WerkbankSections():
        setMetadata(
          currentDescriptions.copyWith(
            sectionsDescription: tryMergeIntoEntry(
              entry: currentDescriptions.sectionsDescription,
              node: node,
              description: description,
            ),
          ),
        );
      case WerkbankFolder():
        final lastFolder = currentDescriptions.folderDescriptions.lastOrNull;
        final current = lastFolder?.node == node ? lastFolder : null;
        final newEntry = tryMergeIntoEntry(
          entry: current,
          node: node,
          description: description,
        );
        final newFolderDescriptions = currentDescriptions.folderDescriptions
            .toList();
        if (current != null) {
          newFolderDescriptions[newFolderDescriptions.length - 1] = newEntry;
        } else {
          newFolderDescriptions.add(
            DescriptionEntry<WerkbankFolder>(
              description: description,
              node: node,
            ),
          );
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
              node: node,
              description: description,
            ),
          ),
        );
      case WerkbankUseCase():
        setMetadata(
          currentDescriptions.copyWith(
            useCaseDescription: tryMergeIntoEntry(
              entry: currentDescriptions.useCaseDescription,
              node: node,
              description: description,
            ),
          ),
        );
    }

    /* TODO(lzuttermeister): We probably need to add a minimum match size
         or something, so that this does not produce to many matches. */
    addSearchCluster(
      SearchCluster(
        semanticDescription: 'Description',
        entries: [
          FuzzySearchEntry(
            searchString: description,
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
