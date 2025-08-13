# Project Setup

> [!CAUTION]
> This documentation is under construction and therefore very minimal.

To get the project running and to a point where you can start developing, follow these steps:
1. **Clone the Repository from GitHub**
   - If you are an external contributor, you can fork the repository and clone your fork.
     See GitHub's "[Contributing to a project](https://docs.github.com/en/get-started/exploring-projects-on-github/contributing-to-a-project)" to learn how.
2. **Install `fvm`**
   - We use the [fvm](https://pub.dev/packages/fvm) package to make sure that everyone uses the correct Flutter version.
3. **Run `fvm use` in your project folder**
   - If asked to install the Flutter SDK, confirm it.
4. **Set your Flutter SDK path in your IDE**
   - If you are using Android Studio, copy the absolute path of `.fvm/flutter_sdk` and set it as the Flutter SDK path under `File -> Settings -> Languages & Frameworks -> Flutter`.
   <!-- TODO: Add instructions for VS Code -->
5. **Run `fvm flutter pub get`**
   - This will install the dependencies of the root project. Most importantly `melos`.
6. **Run `fvm dart run melos bootstrap`**
   - This will set up the monorepo.

Now you should be able to edit the werkbank code and run the example app.
