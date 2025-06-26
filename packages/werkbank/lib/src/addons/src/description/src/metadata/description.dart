import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:werkbank/src/werkbank_internal.dart';

class Descriptions extends UseCaseMetadataEntry<Descriptions> {
  const Descriptions({
    required this.folderDescriptions,
    required this.componentDescription,
    required this.useCaseDescription,
  });

  static const empty = Descriptions(
    folderDescriptions: IList.empty(),
    componentDescription: null,
    useCaseDescription: null,
  );

  final IList<String> folderDescriptions;
  final String? componentDescription;
  final String? useCaseDescription;

  Descriptions copyWith({
    IList<String>? folderDescriptions,
    String? componentDescription,
    String? useCaseDescription,
  }) => Descriptions(
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
    switch (node) {
      // We treat description on the root as a folder description.
      case WerkbankSections():
      case WerkbankFolder():
        setMetadata(
          currentDescriptions.copyWith(
            folderDescriptions: currentDescriptions.folderDescriptions.add(
              description,
            ),
          ),
        );
      case WerkbankComponent():
        setMetadata(
          currentDescriptions.copyWith(componentDescription: description),
        );
      case WerkbankUseCase():
        setMetadata(
          currentDescriptions.copyWith(useCaseDescription: description),
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
            searchString: description,
            scoreThreshold: .1,
          ),
        ],
      ),
    );
  }
}
