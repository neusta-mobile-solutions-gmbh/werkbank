import 'package:example_werkbank/src/example_werkbank/use_case_index.dart';

WerkbankFolder get themeFolder => WerkbankFolder(
  name: 'Theme',
  children: [
    WerkbankUseCase(
      name: 'Color Scheme',
      builder: colorsUseCaseBuilder(
        builder: (c) {
          c.overview
            ..minimumSize(width: 570, height: 570)
            ..withoutPadding();
        },
        colors: (context) {
          final colorScheme = Theme.of(context).colorScheme;
          return {
            'Primary': colorScheme.primary,
            'On Primary': colorScheme.onPrimary,
            'Primary Container': colorScheme.primaryContainer,
            'On Primary Container': colorScheme.onPrimaryContainer,
            'Secondary': colorScheme.secondary,
            'On Secondary': colorScheme.onSecondary,
            'Tertiary': colorScheme.tertiary,
            'On Tertiary': colorScheme.onTertiary,
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
            ..minimumSize(width: 850, height: 850)
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
            ..minimumSize(width: 550, height: 550)
            ..withoutPadding();
        },
        icons: (context) {
          return {
            'Account Circle': Icons.account_circle,
            'Panorama': Icons.panorama,
            'Settings': Icons.settings,
            'Home': Icons.home,
            'Favorite': Icons.favorite,
            'Search': Icons.search,
            'Camera': Icons.camera,
            'Phone': Icons.phone,
            'Email': Icons.email,
            'Alarm': Icons.alarm,
            'Chat': Icons.chat,
            'Lock': Icons.lock,
            'Map': Icons.map,
            'Music Note': Icons.music_note,
            'Shopping Cart': Icons.shopping_cart,
            'Star': Icons.star,
            'Thumb Up': Icons.thumb_up,
            'Visibility': Icons.visibility,
            'Wifi': Icons.wifi,
            'Work': Icons.work,
          };
        },
      ),
    ),
  ],
);
