import 'package:flutter/material.dart';
import 'package:werkbank/werkbank.dart';

class WerkbankThemed extends StatelessWidget {
  const WerkbankThemed({
    required this.child,
    super.key,
  });

  final Widget child;

  static ThemeSnapshot of(BuildContext context) {
    final werkbankStoredTheme = context
        .dependOnInheritedWidgetOfExactType<_WerkbankStoreTheme>();
    if (werkbankStoredTheme == null) {
      throw Exception('WerkbankStoreTheme not found in context');
    }
    return ThemeSnapshot(
      usecaseTheme: werkbankStoredTheme.werkbankTheme,
      defaultTextStyle: werkbankStoredTheme.defaultTextStyle,
    );
  }

  @override
  Widget build(BuildContext context) {
    final werkbankTheme = Theme.of(context);
    final werkbankDefaultTextStyle = DefaultTextStyle.of(context);
    return _WerkbankStoreTheme(
      werkbankTheme: werkbankTheme,
      defaultTextStyle: werkbankDefaultTextStyle,
      child: Theme(
        data: werkbankTheme,
        child: DefaultTextStyle(
          style: werkbankDefaultTextStyle.style,
          maxLines: werkbankDefaultTextStyle.maxLines,
          overflow: werkbankDefaultTextStyle.overflow,
          textAlign: werkbankDefaultTextStyle.textAlign,
          softWrap: werkbankDefaultTextStyle.softWrap,
          textHeightBehavior: werkbankDefaultTextStyle.textHeightBehavior,
          textWidthBasis: werkbankDefaultTextStyle.textWidthBasis,
          child: child,
        ),
      ),
    );
  }
}

class _WerkbankStoreTheme extends InheritedWidget {
  const _WerkbankStoreTheme({
    required this.werkbankTheme,
    required this.defaultTextStyle,
    required super.child,
  });

  final ThemeData werkbankTheme;
  final DefaultTextStyle defaultTextStyle;

  @override
  bool updateShouldNotify(_WerkbankStoreTheme oldWidget) {
    return oldWidget.werkbankTheme != werkbankTheme ||
        oldWidget.defaultTextStyle != defaultTextStyle;
  }
}
