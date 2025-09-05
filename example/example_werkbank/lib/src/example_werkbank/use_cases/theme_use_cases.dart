import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';

WerkbankFolder get themeFolder => WerkbankFolder(
  name: 'Theme',
  children: [
    WerkbankUseCase(
      name: 'Color Scheme',
      builder: colorsUseCaseBuilder(
        builder: (c) {
          c.overview
            ..minimumSize(width: 500, height: 500)
            ..withoutPadding();
        },
        colors: (context) {
          final colorScheme = Theme.of(context).colorScheme;
          return {
            'Primary': colorScheme.primary,
            'On Primary': colorScheme.onPrimary,
            'Primary Container': colorScheme.primaryContainer,
            'On Primary Container': colorScheme.onPrimaryContainer,
            'Surface': colorScheme.surface,
            'On Surface': colorScheme.onSurface,
          };
        },
      ),
    ),
    WerkbankUseCase(
      name: 'Text Theme',
      builder: textStylesUseCaseBuilder(
        builder: (c) {
          c.overview
            ..minimumSize(width: 800, height: 800)
            ..withoutPadding();
        },
        styles: (context) {
          final textTheme = Theme.of(context).textTheme;
          return {
            'Display Large': textTheme.displayLarge!,
            'Display Medium': textTheme.displayMedium!,
            'Display Small': textTheme.displaySmall!,
            'Headline Large': textTheme.headlineLarge!,
            'Headline Medium': textTheme.headlineMedium!,
            'Headline Small': textTheme.headlineSmall!,
            'Title Large': textTheme.titleLarge!,
            'Title Medium': textTheme.titleMedium!,
            'Title Small': textTheme.titleSmall!,
            'Body Large': textTheme.bodyLarge!,
            'Body Medium': textTheme.bodyMedium!,
            'Body Small': textTheme.bodySmall!,
          };
        },
      ),
    ),
    WerkbankUseCase(
      name: 'Icons Scheme',
      builder: iconsUseCaseBuilder(
        builder: (c) {
          c.overview
            ..minimumSize(width: 500, height: 500)
            ..withoutPadding();
        },
        icons: (context) {
          return {
            'WerkbankIcons Arrow Square Out': WerkbankIcons.arrowSquareOut,
            'WerkbankIcons Folder Simple': WerkbankIcons.folderSimple,
            'WerkbankIcons Big Dots': WerkbankIcons.bigDots,
            'Icons Account Circle': Icons.account_circle,
            'Icons Panorama': Icons.panorama,
          };
        },
      ),
    ),
  ],
);
