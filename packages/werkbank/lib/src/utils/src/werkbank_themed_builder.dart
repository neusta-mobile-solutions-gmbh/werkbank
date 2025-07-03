import 'package:flutter/material.dart';
import 'package:werkbank/src/widgets/werkbank_store_theme.dart';
import 'package:werkbank/werkbank.dart';

/// A widget that applies a [werkbankTheme] to a specific part of the widget
/// tree while keeping the [child] with its original inherited theme.
///
/// The [themedBuilder] receives the new theme context and
/// builds the themed widgets.
/// The [child] remains unthemed and keeps its inherited theme.
class WerkbankThemedBuilder extends StatelessWidget {
  const WerkbankThemedBuilder({
    super.key,
    required this.werkbankTheme,
    required this.themedBuilder,
    required this.child,
  });

  final WerkbankTheme werkbankTheme;
  final Widget Function(BuildContext context) themedBuilder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        child,
        Theme(
          data: getThemeData(context, werkbankTheme),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: werkbankTheme.colorScheme.text,
            ),
            child: Builder(
              builder: themedBuilder,
            ),
          ),
        ),
      ],
    );
  }
}

class UseCaseThemed extends StatelessWidget {
  const UseCaseThemed({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final storedWerkbankTheme = WerkbankThemed.of(context);

    final werkbankDefaultTextStyle = DefaultTextStyle.of(context);
    final usecaseTheme = Theme.of(context);

    return _UseCaseStoreTheme(
      usecaseTheme: usecaseTheme,
      defaultTextStyle: DefaultTextStyle.of(context),
      child: Theme(
        data: storedWerkbankTheme.usecaseTheme,
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

class _UseCaseStoreTheme extends InheritedWidget {
  const _UseCaseStoreTheme({
    required this.usecaseTheme,
    required this.defaultTextStyle,
    required super.child,
  });

  final ThemeData usecaseTheme;
  final DefaultTextStyle defaultTextStyle;

  @override
  bool updateShouldNotify(_UseCaseStoreTheme oldWidget) {
    return oldWidget.usecaseTheme != usecaseTheme ||
        oldWidget.defaultTextStyle != defaultTextStyle;
  }

  static _UseCaseStoreTheme of(BuildContext context) {
    final useCaseStoredTheme = context
        .dependOnInheritedWidgetOfExactType<_UseCaseStoreTheme>();
    if (useCaseStoredTheme == null) {
      throw Exception('UseCaseStoreTheme not found in context');
    }
    return useCaseStoredTheme;
  }
}

class RestoreUseCaseTheme extends StatelessWidget {
  const RestoreUseCaseTheme({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final useCaseStoredTheme = _UseCaseStoreTheme.of(context).usecaseTheme;
    final defaultTextStyle = _UseCaseStoreTheme.of(context).defaultTextStyle;
    return Theme(
      data: useCaseStoredTheme,
      child: DefaultTextStyle(
        style: defaultTextStyle.style,
        maxLines: defaultTextStyle.maxLines,
        overflow: defaultTextStyle.overflow,
        textAlign: defaultTextStyle.textAlign,
        softWrap: defaultTextStyle.softWrap,
        textHeightBehavior: defaultTextStyle.textHeightBehavior,
        textWidthBasis: defaultTextStyle.textWidthBasis,
        child: child,
      ),
    );
  }
}

class ThemeSnapshot {
  const ThemeSnapshot({
    required this.usecaseTheme,
    required this.defaultTextStyle,
  });

  final ThemeData usecaseTheme;
  final DefaultTextStyle defaultTextStyle;
}
