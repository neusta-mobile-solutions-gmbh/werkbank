> [!CAUTION]
> This topic is under construction.

# Searching for UseCases

You may have noticed, Werkbank has a Search-Feature in it's Navigation-Panel. It can be used to find a specific UseCase, Component or Folder (WerkbankNodes) of your WerkbankSections. But it is not just a plain test WerkbankNode-Search.

While searching, the WerkbankSection Tree-Structure stays the same. Just the mismatches get filtered out.

Searching by default it fuzzy, and you can search for UseCase/Component/Folder-Names, Tags, Descriptions, Constraints names Names, and Knob Preset names for now.

This is due to adding things to Werkbank that can be searched for is easy. There is an API for that. See [here](#adding-something-searchable-to-werkbank-yourself).

## Advances search

However when dealing with very many WerkbankNodes, finding what you are looking for becomes harder. We have implemented some feature to help out with that.

For example, you can search for tags only by writing something like this

- General: `<field>:fuzzy text`
- Tag Example: `tag:button`

You can also override the default fuzzy-search behavior and do a more percise search, that is still case-insensitive for convinience.

- General: `"persice text search"`

And you can also combine those features.

- General: `<field>:"persice text"`
- Tag Example: `desc:"hot reload"`

### All defined fields

Fields you can search for are

- UseCase/Component/Folder-Name `name`
- Tag: `tag`
- Description `desc`
- Constraints Preset name `cPreset`
- Knob Preset name `kPreset`


## Adding something searchable to Werkbank yourself

Our Addon-API enables you to add SearchClusters and SearchEntries to Werkbank. to make searching for affected WerkbankNodes possible.

This for example

```dart
extension TagsComposerExtension on UseCaseComposer {
  void tags(List<String> tags) {
    // [...]
    addSearchCluster(
      SearchCluster(
        semanticDescription: 'Tag',
        field: DescriptionAddon.tagField,
        entries: tags
            .map(
              (tag) => FuzzySearchEntry(
                searchString: tag,
                ignoreCase: true,
              ),
            )
            .toList(),
      ),
    );
  }
}
```

demonstrates how tags are added to our Search API. This gets executed when you call `c.tags(['some', 'words'])` with the `UseCaseComposer c`;

Now what is happening here.

1. Add a `SearchCluster` to a WerkbankNode to add something, that can be searched for.
  - Give it meaning be setting `semanticDescription`.
  - Define what the user has to use for `field` to make use of the advanced search feature

2. Add the actual `SearchEntries` to the cluster. In many cases, this will just be one. Each entry holds one searchstring, than can actually be searched for. For our example each tag the WerkbankNode has, can be used to find it. And using `scoreThreshold` and and `ignoreCase` you can fine-tune how easy or hard it is to find that exact SearchEntry, leading to the SearchCluster, leading to it's WerkbankNode, for example its `UseCase`. You could also implement your own SearchEntry if your not happy with its Fuzzy Behavior.

