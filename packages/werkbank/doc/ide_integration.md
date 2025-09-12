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

## Live Templates/Snippets for a use case
To make it easier to write a new use case, you can create a live template/snippet in your IDE.

### Android Studio
Go to Settings -> Editor -> Live Templates and click on the "Flutter" group.
Click the Add (+) button in the top left corner and select "Live Template".
As abbreviation, use for example "useCase".
As "Template text" set the following:
```
WidgetBuilder $NAME$UseCase(UseCaseComposer c) {
  return (context) {
    return $END$;
  };
}
```
Finally click on "Define" and select "Dart -> Toplevel" as applicable context.
Save the settings and you are good to go.

### Visual Studio Code
Go to Code -> Preferences -> Configure Snippets and select "dart".
This should open a json file.

Add the following snippet between the curly braces:

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


## Live Templates/Snippets for multiple use cases

Sometimes you may find yourself in a position where you want to write multiple use cases that have things in common,
like a shared composition with the same knobs or something similar. This may happen when you have different variants of
the same UI Component. Various approaches are possible, but starting with a snippet can be helpful.

### Android Studio


### Visual Studio Code


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



