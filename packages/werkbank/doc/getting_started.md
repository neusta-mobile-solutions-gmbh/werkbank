This topic will guide you through the process of setting up Werkbank for your Flutter project.
You should already be familiar what Werkbank is and the purpose of use cases from the
[Welcome](Welcome-topic.html) topic.

**Table of Contents**
- [Creating the Werkbank Flutter Project](#creating-the-werkbank-flutter-project)
- [WerkbankApp Setup](#werkbankapp-setup)
  - [Defining the Use Case Tree](#defining-the-use-case-tree)
- [Creating UseCases](#creating-usecases)
- [Next Steps](#next-steps)

## Creating the Werkbank Flutter Project

To create a Werkbank for your project, start by creating a new Flutter app.
A good place to put this app would be next to the folder of your project.
For example, you can do this by running
```bash
flutter create --platforms=windows,linux,macos,web my_project_werkbank
```
in the folder where your `my_project` Flutter app folder is located.
It is recommended to only add platforms with desktop support because Werkbank is optimized for desktop interfaces rather than mobile screens.

Once the Flutter project is generated, add `werkbank` as a dependency to your project:

```bash
cd my_project_werkbank
flutter pub add werkbank
```

You will also need to add a dependency to your flutter package or app where the widgets you want to showcase are located.

> [!TIP]
> The following sections introduce you to a very basic setup of a Werkbank app.
> Check out the example project at
> https://github.com/neusta-mobile-solutions-gmbh/werkbank/tree/main/example/example_werkbank
> for a more elaborate setup that will help you get the most
> out of Werkbank.

## WerkbankApp Setup

Set up the `main.dart` file to run a
[StatelessWidget](https://api.flutter.dev/flutter/widgets/StatelessWidget-class.html)
that builds a
[WerkbankApp](../werkbank/WerkbankApp-class.html)
widget.
```dart
// ---- lib/main.dart ---- //

import 'package:my_project_werkbank/root.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

void main() {
  runApp(const MyProjectWerkbankApp());
}

class MyProjectWerkbankApp extends StatelessWidget {
  const MyProjectWerkbankApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WerkbankApp(
      name: 'My Project Werkbank',
      logo: const WerkbankLogo(),
      appConfig: AppConfig.material(),
      addonConfig: AddonConfig(
        addons: [
          // Add more addons like the ThemingAddon or LocalizationAddon.
        ],
      ),
      // The root of your use case tree.
      root: root,
    );
  }
}
```

> [!IMPORTANT]  
> Do not pass the `WerkbankApp` directly to `runApp`, as this will prevent
> hot reload from updating the use cases, addons and more when you change them.

The **[name](../werkbank/WerkbankApp/name.html)** and **[logo](../werkbank/WerkbankApp/logo.html)** will be displayed in the top left corner of the
[WerkbankApp](../werkbank/WerkbankApp-class.html).
They should represent the name and logo of your project.
The logo can also be set to `null` if you don't have one.

The **[appConfig](../werkbank/WerkbankApp/appConfig.html)** parameter accepts an
[AppConfig](../werkbank/AppConfig-class.html) object that defines how your use cases will be wrapped with a
[MaterialApp](https://api.flutter.dev/flutter/material/MaterialApp-class.html),
[CupertinoApp](https://api.flutter.dev/flutter/cupertino/CupertinoApp-class.html),
or [WidgetsApp](https://api.flutter.dev/flutter/widgets/WidgetsApp-class.html).
Depending on the design system of your project, you can use
- [AppConfig.material()](../werkbank/AppConfig/AppConfig.material.html) for Material Design,
- [AppConfig.cupertino()](../werkbank/AppConfig/AppConfig.cupertino.html) for Cupertino,
- [AppConfig.widgets()](../werkbank/AppConfig/AppConfig.widgets.html) for a minimal app,
- or the raw [AppConfig()](../werkbank/AppConfig/AppConfig.html) constructor for a custom app.

The **[addonConfig](../werkbank/WerkbankApp/addonConfig.html)** parameter is used
to configure addons that provide most of the functionality in Werkbank using an
[AddonConfig](../werkbank/AddonConfig-class.html) object.
By default, it already includes several addons.
Its [addons](../werkbank/AddonConfig/addons.html) parameter allows you to add additional addons
or reconfigure the implicitly included default addons.
For example, you should consider adding the
[ThemingAddon](../werkbank/ThemingAddon-class.html) and the
[LocalizationAddon](../werkbank/LocalizationAddon-class.html), since almost every app uses theming, and it is also good practice to use a localization framework
even if your app only supports one language.
To learn more about addons, visit the [Configuring Addons](Configuring%20Addons-topic.html) topic.

### Defining the Use Case Tree
The **[root](../werkbank/WerkbankApp/root.html)** parameter
expects a
[WerkbankRoot](../werkbank/WerkbankRoot-class.html)
instance with children that form a hierarchy of your use cases.

```dart
// ---- lib/root.dart ---- //

import 'package:my_project_werkbank/example_use_cases.dart';
import 'package:werkbank/werkbank.dart';

WerkbankRoot get root => WerkbankRoot(
      children: [
        exampleUseCase,
        WerkbankFolder(
          name: 'Example Folder',
          children: [
            anotherUseCase,
            yetAnotherUseCase,
          ],
        ),
      ],
    );
```

The [WerkbankRoot](../werkbank/WerkbankRoot-class.html) defines the root of a tree
with all your use cases.
Use cases are defined in the tree using [WerkbankUseCase](../werkbank/WerkbankUseCase-class.html).
You can nest use cases inside [WerkbankFolder](../werkbank/WerkbankFolder-class.html) or
[WerkbankComponent](../werkbank/WerkbankComponent-class.html) nodes to group them logically.
The difference between these two is:
- [WerkbankComponent](../werkbank/WerkbankComponent-class.html)s are intended to be used to group multiple
  use cases that display the same component/widget, just in different ways.
- [WerkbankComponent](../werkbank/WerkbankComponent-class.html) has a different icon in the navigation tree than folders.
- [WerkbankFolder](../werkbank/WerkbankFolder-class.html)s are always sorted above use cases among their siblings in the tree.
- [WerkbankComponent](../werkbank/WerkbankComponent-class.html)s are sorted like use cases in the tree.
- A [WerkbankComponent](../werkbank/WerkbankComponent-class.html) only has one tile in the [Overview](Overview-topic.html) that periodically switches its thumbnail between the contained use cases.
<!-- TODO: Link to topic about use case tree? -->

## Creating UseCases

You can define a use case by creating a getter for a
[WerkbankUseCase](../werkbank/WerkbankUseCase-class.html)
instance with a [name](../werkbank/WerkbankChildNode/name.html) and a
[builder](../werkbank/WerkbankUseCase/builder.html).

```dart
// ---- lib/example_use_cases.dart ---- //

import 'package:werkbank/werkbank.dart';

WerkbankUseCase get exampleUseCase => WerkbankUseCase(
  name: 'Example Use Case',
  builder: _exampleUseCase,
);

WidgetBuilder _exampleUseCase(UseCaseComposer c) {
  // You can do many things with the composer here.
  return (context) {
    return ExampleWidget();
  };
}
```

> [!IMPORTANT]
> Always define your
> [WerkbankRoot](../werkbank/WerkbankRoot-class.html),
> [WerkbankFolder](../werkbank/WerkbankFolder-class.html)s,
> [WerkbankComponent](../werkbank/WerkbankComponent-class.html)s, and
> [WerkbankUseCase](../werkbank/WerkbankUseCase-class.html)s
> as a getter or function, not as a `const` or `final` top-level variable.
> Otherwise, a hot reload will not update them when you make changes.

A [UseCaseBuilder](../werkbank/UseCaseBuilder.html) is defined by a function that takes a
[UseCaseComposer](../werkbank/UseCaseComposer-class.html)
and returns a
[WidgetBuilder](https://api.flutter.dev/flutter/widgets/WidgetBuilder.html).
In turn, the
[WidgetBuilder](https://api.flutter.dev/flutter/widgets/WidgetBuilder.html)
then returns the widget that the use case is supposed to showcase.

<!-- TODO: Check link. This topic doesn't exist yet. -->
The [UseCaseComposer](../werkbank/UseCaseComposer-class.html) can be used
in many different ways to configure and augment the use case.
Visit the [Writing Use Cases](Writing%20Use%20Cases-topic.html) topic to learn more about
how to expertly write use cases and utilize the
[UseCaseComposer](../werkbank/UseCaseComposer-class.html) to its full potential.

Now you should have everything set up to run your Werkbank app.

> [!TIP]
> Check out the "Shortcuts" section in the home page of your running Werkbank app to learn the basic keyboard shortcuts.

## Next Steps

Take a look at these topics next to advance your Werkbank setup further:
- [File Structure](File%20Structure-topic.html) - Learn how to organize the files and use cases in your project.
- [Configuring Addons](Configuring%20Addons-topic.html) - Further configure the addons you are using.
- [Writing Use Cases](Writing%20Use%20Cases-topic.html) - Explore how to augment your use cases by utilizing the [UseCaseComposer](../werkbank/UseCaseComposer-class.html).
