import 'package:flutter/material.dart';

ThemeData getThemeData(
  BuildContext context,
  WerkbankTheme werkbankTheme,
) {
  return ThemeData.from(
    colorScheme: ColorScheme.fromSeed(
      seedColor: werkbankTheme.colorScheme.text,
      brightness: ThemeData.estimateBrightnessForColor(
        werkbankTheme.colorScheme.surface,
      ),
    ),
  ).copyWith(
    extensions: [
      werkbankTheme,
    ],
    iconTheme: IconThemeData(
      size: 16,
      color: werkbankTheme.colorScheme.icon,
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: werkbankTheme.colorScheme.text,
      selectionColor: werkbankTheme.colorScheme.text.withValues(alpha: 0.3),
      selectionHandleColor: werkbankTheme.colorScheme.text,
    ),
    scrollbarTheme: ScrollbarThemeData(
      thumbVisibility: WidgetStateProperty.all<bool>(true),
      crossAxisMargin: 4,
      mainAxisMargin: 4,
    ),
  );
}

extension WerkbankThemeExtension on BuildContext {
  WerkbankTheme get werkbankTheme => Theme.of(this).extension()!;

  WerkbankColorScheme get werkbankColorScheme => werkbankTheme.colorScheme;

  WerkbankTextTheme get werkbankTextTheme => werkbankTheme.textTheme;
}

class WerkbankTheme extends ThemeExtension<WerkbankTheme> {
  WerkbankTheme({
    required this.colorScheme,
    required this.textTheme,
  });

  final WerkbankColorScheme colorScheme;
  final WerkbankTextTheme textTheme;

  @override
  ThemeExtension<WerkbankTheme> copyWith() {
    // TODO(lzuttermeister): Implement
    throw UnimplementedError();
  }

  @override
  ThemeExtension<WerkbankTheme> lerp(
    covariant ThemeExtension<WerkbankTheme>? other,
    double t,
  ) {
    if (other == null) {
      return this;
    }
    // TODO(lzuttermeister): Implement actual lerp
    if (t < 0.5) {
      return this;
    } else {
      return other;
    }
  }
}

class WerkbankColorScheme {
  const WerkbankColorScheme({
    required this.background,
    required this.backgroundActive,
    required this.chip,
    required this.divider,
    required this.field,
    required this.fieldContent,
    required this.hoverFocus,
    required this.icon,
    required this.logo,
    required this.surface,
    required this.tabFocus,
    required this.tabFocusActive,
    required this.text,
    required this.textActive,
    required this.textHighlighted,
    required this.textLight,
  });

  WerkbankColorScheme.fromPalette(WerkbankPalette palette)
    : background = palette.scheme2,
      backgroundActive = palette.scheme6,
      chip = palette.scheme4,
      divider = palette.scheme3,
      field = palette.scheme3,
      fieldContent = palette.scheme6,
      hoverFocus = palette.scheme5,
      icon = palette.scheme6,
      logo = palette.scheme5,
      surface = palette.scheme1,
      tabFocus = palette.scheme6,
      tabFocusActive = palette.scheme1,
      text = palette.scheme7,
      textActive = palette.scheme1,
      textHighlighted = palette.scheme3,
      textLight = palette.scheme6;

  final Color background;
  final Color backgroundActive;
  final Color chip;
  final Color divider;
  final Color field;
  final Color fieldContent;
  final Color hoverFocus;
  final Color icon;
  final Color logo;
  final Color surface;
  final Color tabFocus;
  final Color tabFocusActive;
  final Color text;
  final Color textActive;
  final Color textHighlighted;
  final Color textLight;
}

class WerkbankPalette {
  const WerkbankPalette({
    required this.scheme1,
    required this.scheme2,
    required this.scheme3,
    required this.scheme4,
    required this.scheme5,
    required this.scheme6,
    required this.scheme7,
  });

  const WerkbankPalette.light()
    : scheme1 = const Color(0xffFFFFFF),
      scheme2 = const Color(0xffFAFAFA),
      scheme3 = const Color(0xffF5F5F5),
      scheme4 = const Color(0xffE0E0E0),
      scheme5 = const Color(0xffCCCCCC),
      scheme6 = const Color(0xff545454),
      scheme7 = const Color(0xff1F1F1F);

  const WerkbankPalette.dark()
    : scheme1 = const Color(0xff1F1F1F),
      scheme2 = const Color(0xff262626),
      scheme3 = const Color(0xff303030),
      scheme4 = const Color(0xff545454),
      scheme5 = const Color(0xffCCCCCC),
      scheme6 = const Color(0xffF5F5F5),
      scheme7 = const Color(0xffFFFFFF);

  final Color scheme1;
  final Color scheme2;
  final Color scheme3;
  final Color scheme4;
  final Color scheme5;
  final Color scheme6;
  final Color scheme7;
}

class WerkbankTextTheme {
  const WerkbankTextTheme({
    required this.defaultText,
    required this.headline,
    required this.detail,
    required this.interaction,
    required this.input,
    required this.indicator,
    required this.textSmall,
    required this.textLight,
  });

  factory WerkbankTextTheme.standard() {
    const package = 'werkbank';
    return const WerkbankTextTheme(
      defaultText: TextStyle(
        package: package,
        fontFamily: 'Inter',
        fontSize: 16.5,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        letterSpacing: 0.66,
        height: 1.45,
      ),
      headline: TextStyle(
        package: package,
        fontFamily: 'Inter',
        fontSize: 24.75,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        letterSpacing: 0.99,
        height: 1.29,
      ),
      detail: TextStyle(
        package: package,
        fontFamily: 'Inter',
        fontSize: 14.65,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        letterSpacing: 0.59,
        height: 1.37,
      ),
      interaction: TextStyle(
        package: package,
        fontFamily: 'JetBrains Mono',
        fontSize: 14.6,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.normal,
        letterSpacing: 1.17,
        height: 1.64,
      ),
      input: TextStyle(
        package: package,
        fontFamily: 'JetBrains Mono',
        fontSize: 14.6,
        fontWeight: FontWeight.w300,
        fontStyle: FontStyle.normal,
        letterSpacing: 1.17,
        height: 1.64,
      ),
      indicator: TextStyle(
        package: package,
        fontFamily: 'JetBrains Mono',
        fontSize: 10.95,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        letterSpacing: 1.75,
        height: 1.83,
      ),
      textSmall: TextStyle(
        package: package,
        fontFamily: 'Inter',
        fontSize: 11,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        letterSpacing: 0.55,
        height: 1.45,
      ),
      textLight: TextStyle(
        package: package,
        fontFamily: 'JetBrains Mono',
        fontSize: 10.95,
        fontWeight: FontWeight.w400,
        fontStyle: FontStyle.normal,
        letterSpacing: 1.752,
        height: 1.45,
      ),
    );
  }

  final TextStyle defaultText;
  final TextStyle headline;
  final TextStyle detail;
  final TextStyle interaction;
  final TextStyle input;
  final TextStyle indicator;
  final TextStyle textSmall;
  final TextStyle textLight;
}
