> [!CAUTION]
> This topic is under construction.

## Live Templates/Snippets
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

#### Visual Studio Code
Go to Code -> Preferences -> Configure Snippets and select "dart".
This should open a json file.
Add the following snippet between the curly braces:
```json
"Create a UseCase": {
  "prefix": "usecase",
  "body": [
    "WidgetBuilder ${1:name}UseCase(UseCaseComposer c) {",
    "  return (context) {",
    "    return $0;",
    "  };",
    "}",
  ],
  "description": "Creates a Werkbank use case."
}
```
