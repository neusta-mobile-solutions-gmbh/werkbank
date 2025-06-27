# Search in Werkbank

Werkbank provides a search feature in the navigation panel, making it easy to find specific Use Cases, Components, or Folders (WerkbankNodes) within your WerkbankSections. It does more than a simple text search and keeps the familiar tree structure—only hiding nodes that do not match your query. The search is designed to be flexible and extensible, so you can quickly find what you are looking for—even in large projects.

## How Search Works

By default, search is fuzzy and case-insensitive. You can search for:

- Use Case, Component, or Folder names
- Tags
- Descriptions
- Constraint Preset names
- Knob Preset names

Adding new searchable fields is straightforward—see [Adding Custom Search Fields](#adding-custom-search-fields) below.

## Advanced Search

As your Werkbank grows, finding the right node can become challenging. Werkbank supports advanced search syntax to help you narrow down results:

- **Field-specific search:**
  - General: `<field>:fuzzy text`
  - Example: `tag:button`
- **Exact search:**
  - General: `"precise text search"`
- **Combine both:**
  - General: `<field>:"precise text"`
  - Example: `desc:"hot reload"`

### Supported Fields

You can target the following fields in your search:

- `name` — Use Case, Component, or Folder name
- `tag` — Tag
- `desc` — Description
- `cPreset` — Constraint Preset name
- `kPreset` — Knob Preset name

## Adding Custom Search Fields

Werkbank’s Addon API lets you extend the search to custom fields. You can add SearchClusters and SearchEntries to any WerkbankNode, making them discoverable via search.

For example, to make tags searchable:

```dart
extension TagsComposerExtension on UseCaseComposer {
  void tags(List<String> tags) {
    // ...
    addSearchCluster(
      SearchCluster(
        semanticDescription: 'Tag',
        field: DescriptionAddon.tagField,
        entries: tags
            .map((tag) => FuzzySearchEntry(
                  searchString: tag,
                  ignoreCase: true,
                ))
            .toList(),
      ),
    );
  }
}
```

This extension allows you to call `c.tags(['some', 'words'])` in your UseCaseComposer. Each tag becomes a searchable entry.

See `SearchCluster` and `SearchEntry` to learn more about how to use them.
