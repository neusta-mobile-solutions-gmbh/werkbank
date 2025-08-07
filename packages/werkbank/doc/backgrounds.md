> [!CAUTION]
> This topic is under construction.

The [BackgroundAddon](../werkbank/BackgroundAddon-class.html) allows you to configure the backgrounds of your use cases.

You have two ways to set the backgrounds of use cases:
- In the Code, define a default background for **individual use cases**.
- In the UI, override the background for **all use cases**.

To set the background for all use cases, go to the "SETTINGS" tab and use the dropdown in the "Background" section.
The available options are:
- "Use Case Default" - Uses the default background set in the code.
- "White" - Pure white background.
- "Black" - Pure black background.
- "None" - Transparent background, which reveals the Werkbank UI color behind it.
- "Checkerboard" - A checkerboard pattern background, useful for testing transparency.
- Any additional [BackgroundOption](../werkbank/BackgroundOption-class.html)s added to the addon.

Like most other addons, the [BackgroundAddon](../werkbank/BackgroundAddon-class.html) is enabled by default.
But if you want add additional background options, you need to add
the [BackgroundAddon](../werkbank/BackgroundAddon-class.html) to your
[AddonConfig](../werkbank/AddonConfig-class.html) to overwrite the one added by default.

```dart
AddonConfig get addonConftig => AddonConfig(
  addons: [
    /* ... */
    // If you don't need to add additional background options,
    // you can omit the BackgroundAddon, since it is enabled by default.
    BackgroundAddon(
      backgroundOptions: [
        // Add a custom background option.
        BackgroundOption.colorBuilder(
          name: 'Surface',
          colorBuilder: (context) => Theme.of(context).colorScheme.surface,
        ),
      ],
    ),
  ],
);
```
