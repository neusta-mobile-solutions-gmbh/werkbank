> [!CAUTION]
> This topic is under construction.

This topic describes how to improve the integration of Werkbank with your IDE, making development easier and more efficient.

**Table of Contents**
- [Adding Live Templates/Snippets to your IDE](#adding-live-templatessnippets-to-your-ide)
  - [Android Studio](#android-studio)
  - [Visual Studio Code](#visual-studio-code)
- [Use Case and Component Live Templates/Snippets](#use-case-and-component-live-templatessnippets)
  - [Simple Use Case (`wusecase`)](#simple-use-case-wusecase)
  - [Component with Multiple Use Cases (`wcomponent`)](#component-with-multiple-use-cases-wcomponent)
  - [Component with Variant Use Cases (`wvariantscomponent`)](#component-with-variant-use-cases-wvariantscomponent)

## Adding Live Templates/Snippets to your IDE

### Android Studio
1. Copy the XML from of the live templates below into your clipboard.
2. Go to File -> Settings -> Editor -> Live Templates.
3. Right-click on the "Flutter" group.
4. Press "Paste".

### Visual Studio Code
1. Copy the JSON from of the snippets below into your clipboard.
2. Go to Code -> Preferences -> Configure Snippets and select "dart".
3. Paste the JSON into the opened file between the curly braces.

## Use Case and Component Live Templates/Snippets

### Simple Use Case (`wusecase`)
To make it easier to write a new use case, you can create a live template/snippet in your IDE.

<details>
<summary><b>Android Studio</b> Live Template XML</summary>

```xml
<template name="wusecase" value="import 'package:flutter/widgets.dart';&#10;import 'package:werkbank/werkbank.dart';&#10;&#10;WerkbankUseCase get $NAME$UseCase =&gt; WerkbankUseCase(&#10;    name: '$CAP_NAME$',&#10;    builder: _useCase,&#10;  );&#10;&#10;WidgetBuilder _useCase(UseCaseComposer c) {&#10;  return (context) {&#10;    return $END$;&#10;  };&#10;}" description="" toReformat="false" toShortenFQNames="true">
  <variable name="NAME" expression="" defaultValue="" alwaysStopAt="true" />
  <variable name="CAP_NAME" expression="capitalize(NAME)" defaultValue="" alwaysStopAt="false" />
  <context>
    <option name="DART_TOPLEVEL" value="true" />
  </context>
</template>
```
</details>

<details>
<summary><b>Visual Studio Code</b> Snippet JSON:</summary>

```json
"Create a UseCase": {
    "prefix": "usecase",
    "body": [
        "import 'package:flutter/widgets.dart';",
        "import 'package:werkbank/werkbank.dart';",
        "",
        "WerkbankUseCase get ${1:name}UseCase => WerkbankUseCase(",
        "  name: '${1/(.*)/${1:/capitalize}/}',",
        "  builder: _useCase,",
        ");",
        "",
        "WidgetBuilder _useCase(UseCaseComposer c) {",
        "  return (context) {",
        "    return ${0:widget};",
        "  };",
        "}",
    ],
    "description": "Creates a Werkbank use case."
},
```
</details>

**Generated Code** (after entering "myWidget"):

```dart
import 'package:flutter/widgets.dart';
import 'package:werkbank/werkbank.dart';

WerkbankUseCase get myWidgetUseCase => WerkbankUseCase(
  name: 'MyWidget',
  builder: _useCase,
);

WidgetBuilder _useCase(UseCaseComposer c) {
  return (context) {
    return ;
  };
}
```

For an **Example usage** of this pattern, see [`slider_use_cases.dart`](https://github.com/neusta-mobile-solutions-gmbh/werkbank/blob/main/example/example_werkbank/lib/src/example_werkbank/use_cases/components/material/slider_use_cases.dart) from the example app.

### Component with Multiple Use Cases (`wcomponent`)
This generates a component with two use cases.

<details>
<summary><b>Android Studio</b> Live Template XML</summary>

```xml
<template name="wcomponent" value="import 'package:flutter/widgets.dart';&#10;import 'package:werkbank/werkbank.dart';&#10;&#10;WerkbankComponent get $NAME$Component =&gt; WerkbankComponent(&#10;  name: '$CAP_NAME$',&#10;  useCases: [&#10;    WerkbankUseCase(&#10;      name: 'One',&#10;      builder: _one,&#10;    ),&#10;    WerkbankUseCase(&#10;      name: 'Two',&#10;      builder: _two,&#10;    ),&#10;  ],&#10;);&#10;&#10;WidgetBuilder _one$END$(UseCaseComposer c) {&#10;  return (context) {&#10;    return const Placeholder();&#10;  };&#10;}&#10;&#10;WidgetBuilder _two(UseCaseComposer c) {&#10;  return (context) {&#10;    return const Placeholder();&#10;  };&#10;}" description="" toReformat="false" toShortenFQNames="true">
  <variable name="NAME" expression="" defaultValue="" alwaysStopAt="true" />
  <variable name="CAP_NAME" expression="capitalize(NAME)" defaultValue="" alwaysStopAt="false" />
  <context>
    <option name="DART_TOPLEVEL" value="true" />
  </context>
</template>
```
</details>

<details>
<summary><b>Visual Studio Code</b> Snippet JSON:</summary>

<!-- TODO -->
```json
TODO
```
</details>

**Generated Code** (after entering "myWidget"):

```dart
import 'package:flutter/widgets.dart';
import 'package:werkbank/werkbank.dart';

WerkbankComponent get myWidgetComponent => WerkbankComponent(
  name: 'MyWidget',
  useCases: [
    WerkbankUseCase(
      name: 'One',
      builder: _one,
    ),
    WerkbankUseCase(
      name: 'Two',
      builder: _two,
    ),
  ],
);

WidgetBuilder _one(UseCaseComposer c) {
  return (context) {
    return const Placeholder();
  };
}

WidgetBuilder _two(UseCaseComposer c) {
  return (context) {
    return const Placeholder();
  };
}
```

For an **Example usage** of this pattern, see [`date_picker_use_cases.dart`](https://github.com/neusta-mobile-solutions-gmbh/werkbank/blob/main/example/example_werkbank/lib/src/example_werkbank/use_cases/components/material/date_picker_use_cases.dart) from the example app.

## Component with Variant Use Cases (`wvariantscomponent`)

Sometimes you may find yourself in a position where you want to write multiple use cases that have things in common,
like a shared composition with the same knobs or something similar. This may happen when you have different variants of
the same UI Component. Various approaches are possible, but starting with a snippet can be helpful.

<details>
<summary><b>Android Studio</b> Live Template XML:</summary>

```xml
<template name="wvariantscomponent" value="import 'package:flutter/widgets.dart';&#10;import 'package:werkbank/werkbank.dart';&#10;&#10;enum _Variant {&#10;  one$END$('One'),&#10;  two('Two');&#10;&#10;  const _Variant(this.name);&#10;&#10;  final String name;&#10;}&#10;&#10;WerkbankComponent get $NAME$Component =&gt; WerkbankComponent(&#10;  name: '$CAP_NAME$',&#10;  useCases: [&#10;    for (final variant in _Variant.values)&#10;      WerkbankUseCase(&#10;        name: variant.name,&#10;        builder: (c) =&gt; _multiUseCase(c, variant),&#10;      ),&#10;  ],&#10;);&#10;&#10;WidgetBuilder _multiUseCase(&#10;  UseCaseComposer c,&#10;  _Variant variant,&#10;) {&#10;  return (context) {&#10;    return switch (variant) {&#10;      _Variant.one =&gt; const Placeholder(),&#10;      _Variant.two =&gt; const Placeholder(),&#10;    };&#10;  };&#10;}" description="" toReformat="false" toShortenFQNames="true">
  <variable name="NAME" expression="" defaultValue="" alwaysStopAt="true" />
  <variable name="CAP_NAME" expression="capitalize(NAME)" defaultValue="" alwaysStopAt="false" />
  <context>
    <option name="DART_TOPLEVEL" value="true" />
  </context>
</template>
```
</details>

<details>
<summary><b>Visual Studio Code</b> Snippet JSON:</summary>

```json
"Create a Component for similar UseCases": {
    "prefix": "multiusecase",
    "body": [
        "import 'package:flutter/widgets.dart';",
        "import 'package:werkbank/werkbank.dart';",
        "",
        "enum _Variant {",
        "  ${0}one('One'),",
        "  two('Two');",
        "",
        "  const _Variant(this.name);",
        "",
        "  final String name;",
        "}",
        "",
        "WerkbankComponent get ${1:name}Component => WerkbankComponent(",
        "  name: '${1/(.*)/${1:/capitalize}/}',",
        "  useCases: [",
        "    for (final variant in _Variant.values)",
        "      WerkbankUseCase(",
        "        name: variant.name,",
        "        builder: (c) => _multiUseCase(c, variant),",
        "      ),",
        "  ],",
        ");",
        "",
        "WidgetBuilder _multiUseCase(",
        "  UseCaseComposer c,",
        "  _Variant variant,",
        ") {",
        "  return (context) {",
        "    return switch (variant) {",
        "      _Variant.one => const Placeholder(),",
        "      _Variant.two => const Placeholder(),",
        "    };",
        "  };",
        "}",
    ],
    "description": "Creates a Werkbank component with multiple similar use cases."
},
```
</details>

**Generated Code** (after entering "myWidget"):

```dart
import 'package:flutter/widgets.dart';
import 'package:werkbank/werkbank.dart';

enum _Variant {
  one('One'),
  two('Two');

  const _Variant(this.name);

  final String name;
}

WerkbankComponent get myWidgetComponent => WerkbankComponent(
  name: 'MyWidget',
  useCases: [
    for (final variant in _Variant.values)
      WerkbankUseCase(
        name: variant.name,
        builder: (c) => _multiUseCase(c, variant),
      ),
  ],
);

WidgetBuilder _multiUseCase(
  UseCaseComposer c,
  _Variant variant,
  ) {
  return (context) {
    return switch (variant) {
      _Variant.one => const Placeholder(),
      _Variant.two => const Placeholder(),
    };
  };
}
```

For an **Example usage** of this pattern, see [`button_use_cases.dart`](https://github.com/neusta-mobile-solutions-gmbh/werkbank/blob/main/example/example_werkbank/lib/src/example_werkbank/use_cases/components/material/button_use_cases.dart) from the example app.
