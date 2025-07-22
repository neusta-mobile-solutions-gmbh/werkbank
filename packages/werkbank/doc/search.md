Werkbank provides a search feature in the navigation panel, helping to find specific Use Cases, Components, or Folders ([WerkbankNode](../werkbank/WerkbankNode-class.html)'s) within your [WerkbankRoot](../werkbank/WerkbankRoot-class.html). It does more than a simple text search and keeps the familiar tree structure, only hiding nodes that do not match your query. The search is designed to be flexible and extensible.

## How Search Works

By default, search is fuzzy and case-insensitive. You can search for:

- Use Case, Component, or Folder names
- Tags
- Descriptions
- Constraints Preset names
- Knob Preset names

Adding new searchable fields is straightforward. See [Adding Custom Search Entries](#adding-custom-search-entries) below.

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
- `cPreset` — Constraints Preset name
- `kPreset` — Knob Preset name

## Adding Custom Search Entries

Werkbank’s Addon API lets you extend the search to custom [SearchEntries](../werkbank/SearchEntry-class.html). You can add a [SearchCluster](../werkbank/SearchCluster-class.html) with [SearchEntries](../werkbank/SearchEntry-class.html) to the [UseCaseComposition](../werkbank/UseCaseComposition-class.html) of any [WerkbankNode](../werkbank/WerkbankNode-class.html), making them discoverable via search.

For example, tags are searchable using this implementation:

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

This allows you to call `c.tags(['some', 'words'])` on [UseCaseComposer](../werkbank/UseCaseComposer-class.html). Each tag becomes a searchable entry.

> [!Note]
> All [SearchCluster's](../werkbank/SearchCluster-class.html) must be setup during composing the Use Cases. That's why `addSearchCluster` is called on [UseCaseComposer](../werkbank/UseCaseComposer-class.html).

### Debugging search matches

To better understand why certain use cases are shown or hidden in search, you can enable a debug mode. This is mainly for advanced users fine-tuning their [SearchCluster](../werkbank/SearchCluster-class.html) or [SearchEntry](../werkbank/SearchEntry-class.html) setup.

Enable debugging by setting the [DebugWerkbankFilter](../werkbank/DebugWerkbankFilter-class.html) in your app, for example in your `main()`:

```dart
void main() {
  updateDebugWerkbankFilter(DebugWerkbankFilter.displayAllResults);
  runApp(const YourWerkbank());
}
```

You can also change the setting at runtime. This will show additional information about why nodes are included or excluded in the search results.

