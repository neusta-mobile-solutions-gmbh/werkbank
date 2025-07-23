import 'dart:math';

import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/src/pages/_internal/page_background.dart';
import 'package:werkbank/src/addon_api/addon_api.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/theme/theme.dart';

const _maxContentWidth = 1200;
const _twoColumnsBreakpoint = 800;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final addonComponents =
        AddonConfigProvider.addonsOf(context)
            .map((addon) {
              return addon.buildHomePageComponents(context);
            })
            .expand((component) => component)
            .toList()
          ..sort((a, b) {
            return a.sortHint.compareTo(b.sortHint);
          });
    return PageBackground(
      child: _Layout(
        components: addonComponents,
      ),
    );
  }
}

class _Layout extends StatelessWidget {
  const _Layout({
    required this.components,
  });

  final List<HomePageComponent> components;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final enoughSpaceForTwoColumns =
            constraints.maxWidth > _twoColumnsBreakpoint;
        final useTwoColsLayout =
            enoughSpaceForTwoColumns && components.length > 1;

        final horizontalPadding =
            max(constraints.maxWidth - _maxContentWidth, 0) / 2;

        if (useTwoColsLayout) {
          return _TwoCols(
            horizontalPadding: horizontalPadding,
            components: components,
          );
        }

        return ListView.builder(
          shrinkWrap: true,
          itemCount: components.length,
          itemBuilder: (context, index) {
            return _Component(component: components[index]);
          },
        );
      },
    );
  }
}

class _TwoCols extends StatelessWidget {
  const _TwoCols({
    required this.components,
    required this.horizontalPadding,
  });

  final List<HomePageComponent> components;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: WTwoColsLayout(
            retainFirstOrder: true,
            children: components.map((c) => _Component(component: c)).toList(),
          ),
        ),
      ),
    );
  }
}

class _Component extends StatefulWidget {
  const _Component({
    required this.component,
  });

  final HomePageComponent component;

  @override
  State<_Component> createState() => _ComponentState();
}

class _ComponentState extends State<_Component> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = context.werkbankColorScheme;
    final textTheme = context.werkbankTextTheme;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.component.title != null)
            DefaultTextStyle.merge(
              overflow: TextOverflow.ellipsis,
              style: textTheme.headline.copyWith(color: colorScheme.text),
              child: widget.component.title!,
            ),
          Flexible(child: widget.component.child),
        ],
      ),
    );
  }
}
