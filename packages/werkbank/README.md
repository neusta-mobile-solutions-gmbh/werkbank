A powerful tool that helps you develop, test, visualize, and organize your Flutter UI components.
<p align="center">
  <a href="https://pub.dev/documentation/werkbank/latest/topics/Welcome-topic.html">Documentation</a> •
  <a href="https://pub.dev/documentation/werkbank/latest/topics/Get%20Started-topic.html">Get Started</a> •
  <a href="https://example-werkbank-246cea10e259.playground.neusta-ms.de/">Web Demo</a>
</p>

> [!WARNING]
> Werkbank is feature-rich but still evolving. Documentation is incomplete and APIs may change before the stable release.

## Features

### **🧩 Use Cases**
- Write use cases for your UI components and view and test them in isolation.
- Visually navigate use cases in a grid **overview** that shows thumbnails of your widgets, updating in real time.
- Sort them in a **tree hierarchy** and navigate them using it.
- **Search** for use cases even with **typos** or **abbreviations**.
- Browse **Recently Used** or **Recently Added** in the home page.
- Categorize your use cases using **Tags**.
<video width="768" height="432" loop autoplay src="https://github.com/user-attachments/assets/4b270492-2b54-4d6c-bbf6-ce755372ff3f">
</video>

### **🎛️ Knobs**
- Configure your use case widgets using knobs that control your widget and *can be controlled by your widget* at the same time.
- Define **knob presets** to configure predefined sets of values for your knobs and *view the widget in all its possible states* simultaneously using the overview.
- There are knobs for most common types, like `double`, `int`, `bool`, `String`, `List<T>` etc. and their *nullable* counterparts.
- There are even special knobs for **AnimationControllers** and **FocusNodes**.
<video width="768" height="432" loop autoplay src="https://github.com/user-attachments/assets/4510ff50-54f6-4322-85da-d4aa424da681">
</video>

### **📏 Constraints**
- **Interactively change** the `BoxConstraints` passed to your widgets and see how your widgets react to different sizes.
- Or change the constraints more **precisely using input fields**.
- Define **custom presets** for the constraints.
- Or use predefined **device presets** for common device sizes.
- Use the **zoom and pan gestures** to view use cases in sizes **larger than the viewport**.
<video width="768" height="432" loop autoplay src="https://github.com/user-attachments/assets/6a6d95b4-e0d4-4e24-9c28-d4dc4d169be0">
</video>

### **♿ Accessibility**
- Inspect the **semantic nodes** of your use cases and *all of their properties* using interactive semantics overlays.
- Change **Text Scale** and **Bold Text** to test under different accessibility conditions.
- Simulate **Color Blindness** to verify sufficient contrasts for all users.
<video width="768" height="432" loop autoplay src="https://github.com/user-attachments/assets/5f1495c5-8685-4549-a00e-04e9adc00064">
</video>

### **🖼️ Theme, Background and Localization**
- Change the **theme** of your use cases, even while viewing them in the overview.
- Define **default backgrounds** for your use cases or select from **predefined background** to override the default ones.
- Switch the **locale** used by your use cases.
<video width="768" height="432" loop autoplay src="https://github.com/user-attachments/assets/9481f912-3dd8-4b72-ba3f-5955495ea979">
</video>

### **🛠 Customize your Werkbank**
- **Resize** or **collapse** panels.
- Enter a **focus mode** for no distractions.
- Toggle between **light mode** and **dark mode** of your Werkbank.
- **Reorder** and **collapse panels**  to prioritize the ones you need most.
<video width="768" height="432" loop autoplay src="https://github.com/user-attachments/assets/379b3d2d-f75e-4f4e-b70b-7f31d1fa4fab">
</video>

### **And much more!**
- **🔍 Zoom and Pan**
  - Navigate your use cases using Figma-like zoom and pan gestures.
- **🏷️ Metadata**
  - Augment use cases with metadata such as descriptions, tags, and URLs.
- **🧪 Tests**
  - Use your use cases for golden tests and widget tests by displaying them without the UI of Werkbank.
- **🛠️ Addons**
  - Create your own Addons using the *extremely powerful Addon API*, which is also used to implement knobs, constraints selection, semantics inspection, and much more.
- **🌐 Deployment**
  - Deploy your Werkbank using Flutter's web support to share it with your team and use it for *design reviews*.
- **🔄 Hot Reload**
  - Update everything with just a hot reload.

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
