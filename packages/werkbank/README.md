A powerful tool that helps you develop, test, visualize, and organize your Flutter UI components.
<p align="center">
  <a href="https://pub.dev/documentation/werkbank/latest/topics/Welcome-topic.html">Documentation</a> •
  <a href="https://pub.dev/documentation/werkbank/latest/topics/Get%20Started-topic.html">Get Started</a> •
  <a href="https://example-werkbank-246cea10e259.playground.neusta-ms.de/">Web Demo</a>
</p>

> [!WARNING]
> Werkbank is feature-rich but still evolving. Documentation is incomplete and APIs may change before the stable release.

## Features
- **🧩 Use Cases**
  - Write use cases for your UI components and view and test them in isolation.
- **🖼️ Overview**
  - Visually navigate use cases in a grid overview that shows *thumbnails* of your widgets, updating in real time.
- **🎛️ Knobs**
  - Configure your use case widgets using knobs that control your widget and *can be controlled by your widget* at the same time.
- **🔍 Zoom and Pan**
  - Navigate your use cases using Figma-like zoom and pan gestures.
- **📏 Constraints**
  - Interactively change the `BoxConstraints` passed to your widgets and see how your widgets react to different sizes.
- **🧐 Semantics**
  - Inspect the semantic nodes of your use cases and *all of their properties* using interactive semantics overlays.
- **🔄 Hot Reload**
  - Update everything with just a hot reload.

Werkbank has many more features. Here are some of the more advanced ones that make Werkbank special:

- **📋 Knob Presets**
  - Define knob presets to configure predefined sets of values for your knobs and *view the widget in all its possible states* simultaneously using the overview.
- **🎨 Theme and Locale**
  - Control the theme and locale of your use cases to test them under different conditions.
- **🖼️ Backgrounds**
  - Define individual backgrounds for your use cases or select from predefined ones.
- **🏷️ Metadata**
  - Augment use cases with metadata such as descriptions, tags, and URLs.
- **📂 Folders**
  - Organize your use cases into folders and define many properties on the folders to apply to all contained use cases.
- **🧪 Tests**
  - Use your use cases for golden tests and widget tests by displaying them without the UI of Werkbank.
- **🛠️ Addons**
  - Create your own Addons using the *extremely powerful Addon API*, which is also used to implement knobs, constraints selection, semantics inspection, and much more.
- **🌐 Deployment**
  - Deploy your Werkbank using Flutter's web support to share it with your team and use it for *design reviews*.

## Writing Use Cases
To get a rough idea of how use cases are written, take a look at the following example.
For more detailed explanations, visit our [Documentation](https://pub.dev/documentation/werkbank/latest/topics/Welcome-topic.html).

```dart
// Use cases are written as functions returning a `WidgetBuilder`.
WidgetBuilder sliderUseCase(UseCaseComposer c) {
  //                        ^^^^^^^^^^^^^^^^^
  // Use the `UseCaseComposer c` to customize the use case in many ways.

  // Add metadata to augment the use case.
  c.description('A super cool slider!');
  c.tags(['input', 'slider']);
  c.urls(['https://api.flutter.dev/flutter/material/Slider-class.html']);

  // Set the default background for the use case.
  c.background.named('Surface');

  // Customize the thumbnail in the overview to improve looks or avoid overflows.
  c.overview.minimumSize(width: 150, height: 50);

  // Set initial `BoxConstraints` and presets for the use case.
  // They can still be interactively changed in the UI.
  c.constraints.initial(width: 200);
  c.constraints.preset('Wide', width: 400);

  // Define knobs to control the widget's properties.
  final valueKnob = c.knobs.doubleSlider(
    'Value',
    initialValue: 0.5,
  );

  // Return a `WidgetBuilder` that builds your widget.
  return (context) {
    return Slider(
      // Use knob values in the widget.
      value: valueKnob.value,
      // Even SET knob values in the widget.
      onChanged: (value) => valueKnob.value = value,
    );
  };
}
```

## Where to Go Next?
- 📖 [**Documentation**](https://pub.dev/documentation/werkbank/latest/topics/Welcome-topic.html)
  - Learn everything about what Werkbank is and its technical details.
- 🚀 [**Get Started**](https://pub.dev/documentation/werkbank/latest/topics/Get%20Started-topic.html)
  - If you already roughly know what Werkbank is, jump directly into setting up your Werkbank app.
- 🌐 [**Example Werkbank Web Demo**](https://example-werkbank-246cea10e259.playground.neusta-ms.de/)
  - Try out a Werkbank app in your browser.
- 🛠️ [**Example Werkbank Code**](https://github.com/neusta-mobile-solutions-gmbh/werkbank/tree/main/example/example_werkbank)
  - Take a look at the code of the example web demo above and use it as a starting point for your own Werkbank app. 
