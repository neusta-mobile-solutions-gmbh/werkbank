import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

// --------------------------------
// THIS IS A VERY MINIMAL EXAMPLE.
// Check out
// https://github.com/neusta-mobile-solutions-gmbh/werkbank/tree/main/example/example_werkbank
// for a more complete example and for best practices.
// ( Also if you try to run this from the repo,
//   it won't work, because there are no platform folders.
//   Please run the bigger example under `example/example_werkbank` instead. )
// --------------------------------

void main() {
  runApp(const MinimalExample());
}

class MinimalExample extends StatelessWidget {
  const MinimalExample({super.key});

  @override
  Widget build(BuildContext context) {
    return WerkbankApp(
      // Your project name
      name: 'My Project Werkbank',
      // Your project logo
      logo: const FlutterLogo(),
      // A configuration for how use cases are wrapped with an app widget.
      // In this case a `MaterialApp` will be used.
      appConfig: AppConfig.material(),
      // The addons used.
      addonConfig: addonConfig,
      // The root node defining the tree of use cases.
      root: root,
    );
  }
}

// A configuration for the used addons.
AddonConfig get addonConfig => AddonConfig(
  // Many addons are implicitly included.
  // (Unless you set `includeDefaultAddons: false`.)
  addons: [
    // A theming addon to style the use cases.
    ThemingAddon(
      themeOptions: [
        ThemeOption.material(
          name: 'Pink',
          themeDataBuilder: (context) => ThemeData.from(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.pink,
              dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
            ),
          ),
        ),
      ],
    ),
    // A background addon that allows you to set a background color for the use
    // cases.
    BackgroundAddon(
      // Some background options are implicitly included.
      backgroundOptions: [
        // We add the theme's surface color as a background option.
        BackgroundOption.color(
          name: 'Surface',
          colorBuilder: (context) => Theme.of(context).colorScheme.surface,
        ),
      ],
    ),
  ],
);

// The root node of the use case tree.
WerkbankRoot get root => WerkbankRoot(
  // All parent nodes such as WerkbankRoot or WerkbankFolder can define
  // builders that apply properties to all children.
  builder: (c) {
    // Set the default background for all use cases.
    c.background.named('Surface');
  },
  children: [
    // A folder that can group other use cases or other nodes.
    WerkbankFolder(
      name: 'Example Folder',
      children: [
        // A use case showcasing a slider.
        WerkbankUseCase(
          name: 'Slider',
          builder: sliderUseCase,
        ),
      ],
    ),
  ],
);

WidgetBuilder sliderUseCase(UseCaseComposer c) {
  //                        ^^^^^^^^^^^^^^^^^
  // Use the `UseCaseComposer c` to customize the use case in many ways.

  // Add metadata to augment the use case.
  c.description('A super cool slider!');
  c.tags(['input', 'slider']);
  c.urls(['https://api.flutter.dev/flutter/material/Slider-class.html']);

  // Customize the thumbnail in the overview
  // to improve looks or avoid overflows.
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
