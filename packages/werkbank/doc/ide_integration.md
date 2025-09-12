> [!CAUTION]
> This topic is under construction.

This topic describes how to improve the integration of Werkbank with your IDE, making development easier and more efficient.

**Table of Contents**
- [Live Templates/Snippets for a use case](#live-templatessnippets-for-a-use-case)
  - [Android Studio](#android-studio)
  - [Visual Studio Code](#visual-studio-code)
- [Live Templates/Snippets for multiple use cases](#live-templatessnippets-for-multiple-use-cases)
  - [Android Studio](#android-studio-1)
  - [Visual Studio Code](#visual-studio-code-1)

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

## Live Templates/Snippets for a use case
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
<summary><b>Visual Studio Code</b> Snippet JSON</summary>

```json
"Create a UseCase": {
    "prefix": "usecase",
    "body": [
        "import 'package:flutter/material.dart';",
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

**Example usage:**

```dart
import 'package:flutter/widgets.dart';
import 'package:werkbank/werkbank.dart';

WerkbankUseCase get sliderUseCase => WerkbankUseCase(
    name: 'Slider',
    builder: _useCase,
  );

WidgetBuilder _useCase(UseCaseComposer c) {
  return (context) {
    return Slider(/* ... */);
  };
}
```


## Live Templates/Snippets for multiple use cases

Sometimes you may find yourself in a position where you want to write multiple use cases that have things in common,
like a shared composition with the same knobs or something similar. This may happen when you have different variants of
the same UI Component. Various approaches are possible, but starting with a snippet can be helpful.

<details>
<summary><b>Android Studio</b> Live Template XML</summary>

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
<summary><b>Visual Studio Code</b> Snippet JSON</summary>

```json
"Create a Component for similar UseCases": {
    "prefix": "multiusecase",
    "body": [
        "import 'package:flutter/material.dart';",
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

**Example usage:**

```dart
import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

enum _Variant {
  filled('FilledButton'),
  filledTonal('FilledButton.tonal'),
  outlined('OutlinedButton'),
  text('TextButton'),
  elevated('ElevatedButton');

  const _Variant(this.name);

  final String name;
}

WerkbankComponent get buttonComponent => WerkbankComponent(
  name: 'Button',
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
      _Variant.filled => FilledButton(/* ... */),
      _Variant.filledTonal => FilledButton.tonal(/* ... */),
      _Variant.outlined => OutlinedButton(/* ... */),
      _Variant.text => TextButton(/* ... */),
      _Variant.elevated => ElevatedButton(/* ... */),
    };
  };
}
```
