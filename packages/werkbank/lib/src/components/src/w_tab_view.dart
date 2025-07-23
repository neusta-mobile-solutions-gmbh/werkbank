import 'package:flutter/material.dart';
import 'package:werkbank/src/components/src/w_button_base.dart';
import 'package:werkbank/src/components/src/w_divider.dart';
import 'package:werkbank/src/theme/theme.dart';

// TODO(lzuttermeister): Make a stateless WTabBar instead?
/// {@category Werkbank Components}
class WTabView extends StatefulWidget {
  const WTabView({
    super.key,
    this.initialIndex = 0,
    required this.tabs,
  });

  final int initialIndex;
  final List<WTab> tabs;

  @override
  State<WTabView> createState() => _WTabViewState();
}

class _WTabViewState extends State<WTabView> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, widget.tabs.length - 1);
  }

  @override
  void didUpdateWidget(covariant WTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    _index = _index.clamp(0, widget.tabs.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.werkbankColorScheme;
    final selectedTab = widget.tabs[_index];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (final (i, tab) in widget.tabs.indexed)
              Expanded(
                child: _WTabButton(
                  onPressed: () {
                    setState(() {
                      _index = i;
                    });
                  },
                  isActive: i == _index,
                  isAtStart: i == 0,
                  isAtEnd: i == widget.tabs.length - 1,
                  title: tab.title,
                ),
              ),
          ],
        ),
        Expanded(
          child: ColoredBox(
            color: colorScheme.surface,
            child: selectedTab.child,
          ),
        ),
      ],
    );
  }
}

class _WTabButton extends StatelessWidget {
  const _WTabButton({
    required this.onPressed,
    required this.isActive,
    required this.isAtStart,
    required this.isAtEnd,
    required this.title,
  });

  final VoidCallback onPressed;
  final bool isActive;
  final bool isAtStart;
  final bool isAtEnd;
  final Widget title;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.only(
      topLeft: isAtStart ? Radius.zero : const Radius.circular(4),
      topRight: isAtEnd ? Radius.zero : const Radius.circular(4),
    );
    final paddedTitle = Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: DefaultTextStyle.merge(
        style: context.werkbankTextTheme.indicator.apply(
          color: context.werkbankColorScheme.textLight,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        textAlign: TextAlign.center,
        child: title,
      ),
    );
    return Stack(
      fit: StackFit.passthrough,
      children: [
        if (!isActive)
          const Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: WDivider.horizontal(),
          ),
        WButtonBase(
          key: const Key('button'),
          onPressed: isActive ? null : onPressed,
          borderRadius: borderRadius,
          backgroundColor: isActive
              ? context.werkbankColorScheme.surface
              : Colors.transparent,
          child: paddedTitle,
        ),
      ],
    );
  }
}

class WTab {
  const WTab({
    required this.title,
    required this.child,
  });

  final Widget title;
  final Widget child;
}
