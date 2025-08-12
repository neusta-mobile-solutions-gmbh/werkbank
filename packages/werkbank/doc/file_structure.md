There are many different ways to structure your project files.
This topic presents the advantages and disadvantages of different approaches and makes some
recommendations.
However, in the end, it is up to you to decide what works best for your project.
You should be familiar with a basic Werkbank setup, as described in the
[Getting Started](Getting%20Started-topic.html) topic,
before reading this topic.

**Table of Contents**
- [Where to put the UseCases?](#where-to-put-the-usecases)
- [Where to put the Configurations?](#where-to-put-the-configurations)

## Where to put the UseCases?

While use cases may start small at first,
they can grow quite large once you start augmenting them, for example, with the techniques described in the
[Writing Use Cases](Writing%20Use%20Cases-topic.html) topic.

Because of this, we recommend creating a separate file for each component/widget you want to showcase.
If your component has multiple use cases, it is likely sufficient to put them in the same file.
This file should contain a getter for the
[WerkbankUseCase](../werkbank/WerkbankUseCase-class.html)
or
[WerkbankComponent](../werkbank/WerkbankComponent-class.html),
as well as the
[UseCaseBuilder](../werkbank/UseCaseBuilder.html)
functions for the use cases.

For example, such a file with multiple use cases could look like this:
```dart
// ---- date_picker_use_cases.dart ---- //

WerkbankComponent get datePickerComponent => WerkbankComponent(
  name: 'Date Picker',
  builder: (c) {
    // Some usages of UseCaseComposer c that apply to both use cases.
  },
  useCases: [
    WerkbankUseCase(
      name: 'DatePickerButton',
      builder: _buttonUseCase,
    ),
    WerkbankUseCase(
      name: 'DatePickerDialog',
      builder: _dialogUseCase,
    ),
  ],
);

WidgetBuilder _buttonUseCase(UseCaseComposer c) {
  // ...
  return (context) {
    return DatePickerButton(/* ... */);
  };
}

WidgetBuilder _dialogUseCase(UseCaseComposer c) {
  // ...
  return (context) {
    return DatePickerDialog(/* ... */);
  };
}
```

Since the getter already publicly exposes the
[WerkbankUseCase](../werkbank/WerkbankUseCase-class.html)
or
[WerkbankComponent](../werkbank/WerkbankComponent-class.html),
you can make the
[UseCaseBuilder](../werkbank/UseCaseBuilder.html)s
private, and if you have only one of them, you can even just call it `_useCase`.

When creating a file for a component,
you usually won't know whether it will end up containing multiple use cases or just one.
Because of this, we recommend consistently calling it `my_component_use_cases.dart`,
even if it only contains one use case.
Also, having a suffix like `_use_cases` has the advantage that it is easy to distinguish
them in the IDE, for example, when having both the component and its use cases open in different tabs.

### Where to place the use case files?
There are mainly two logical places where you could put your use case files.
Both approaches have their advantages and disadvantages.

1. **Place them beside the component**
  - *Pros:* Easy to navigate and find.
  - *Cons:* Creates a dependency on `werkbank` in your app or components package.
2. **Place them in the Werkbank app project**
  - *Pros:* Clean separation, no dependency conflicts with `werkbank`.
  - *Cons:* Requires mirroring your component structure.

While the first option may be alluring due to its simplicity,
it violates the principle of separation of concerns and forces you to add a dependency on
`werkbank` in your app or components package.
This increases the risk of dependency conflicts and includes code into your app project that
will never be run when deployed.
Usually, this is not a huge problem since Flutter uses
[Tree Shaking](https://en.wikipedia.org/wiki/Tree_shaking)
to remove unused code, but for example,
`werkbank` and its dependencies will still be listed in your
[LicensePage](https://api.flutter.dev/flutter/material/LicensePage-class.html).

We therefore recommend placing the use case files in the Flutter project that
contains the
[WerkbankApp](../werkbank/WerkbankApp-class.html),
and to mirror the folder structure of your components.

> [!TIP]
> For an even cleaner project structure, you can separate your components/widgets from your app package and place them into a separate Flutter package.
> This components package would then be depended on by your app package and the Werkbank app project.
> Dart's [workspaces](https://dart.dev/tools/pub/workspaces) feature makes this quite convenient.

## Where to put the Configurations?

We also recommend putting your
[AppConfig](../werkbank/AppConfig-class.html)
and
[AddonConfig](../werkbank/AddonConfig-class.html)
objects as top-level getters into separate files within your Werkbank app project.
This avoids large files once they begin to grow and also makes it easy to reuse them,
for example, when writing golden tests
using a [DisplayApp](../werkbank/DisplayApp-class.html),
as described in the
[Testing with Use Cases](Testing%20with%20Use%20Cases-topic.html) topic.
