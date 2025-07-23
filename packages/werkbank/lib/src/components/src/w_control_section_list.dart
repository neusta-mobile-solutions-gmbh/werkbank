import 'package:flutter/material.dart';
import 'package:werkbank/src/components/src/w_animated_visibility.dart';
import 'package:werkbank/src/components/src/w_button_base.dart';
import 'package:werkbank/src/components/src/w_divider.dart';
import 'package:werkbank/src/components/src/w_tree_view/w_expanded_indicator.dart';
import 'package:werkbank/src/theme/theme.dart';

typedef ToggleVisibilityCallback = void Function(int index);
typedef ControlSectionId = String;

class ControlSection {
  const ControlSection({
    required this.id,
    required this.title,
    required this.visible,
    required this.children,
  });

  final ControlSectionId id;
  final Widget title;
  final bool visible;
  final List<Widget> children;

  @override
  String toString() {
    return 'ControlSection(id: $id, title: $title, '
        'visible: $visible, children: $children)';
  }
}

/// {@category Werkbank Components}
class WControlSectionList extends StatefulWidget {
  const WControlSectionList({
    super.key,
    required this.sections,
    required this.onReorder,
    required this.onToggleVisibility,
  });

  final List<ControlSection> sections;
  final ReorderCallback onReorder;
  final ToggleVisibilityCallback onToggleVisibility;

  @override
  State<WControlSectionList> createState() => _WControlSectionListState();
}

class _WControlSectionListState extends State<WControlSectionList> {
  @override
  Widget build(BuildContext context) {
    return Overlay.wrap(
      child: ReorderableListView.builder(
        itemCount: widget.sections.length,
        onReorder: widget.onReorder,
        proxyDecorator: (child, index, animation) {
          return _ProxyDecorator(
            animation: animation,
            child: child,
          );
        },
        buildDefaultDragHandles: false,
        itemBuilder: (context, index) {
          final section = widget.sections[index];
          return _ControlSection(
            key: ValueKey(section.id),
            title: section.title,
            visible: section.visible,
            index: index,
            onToggleVisibility: widget.onToggleVisibility,
            withDivider: index < widget.sections.length - 1,
            children: section.children,
          );
        },
      ),
    );
  }
}

class _ProxyDecorator extends StatelessWidget {
  const _ProxyDecorator({
    required this.animation,
    required this.child,
  });

  final Animation<double> animation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colorTween = ColorTween(
      begin: Colors.transparent,
      end: context.werkbankColorScheme.hoverFocus,
    );
    final borderColor = colorTween.animate(
      CurveTween(curve: Curves.easeInOut).animate(animation),
    );
    return Material(
      color: context.werkbankColorScheme.surface,
      shadowColor: context.werkbankColorScheme.surface,
      child: Stack(
        children: [
          _InheritedProxyDecorator(
            animation: animation,
            child: child,
          ),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: borderColor,
              builder: (context, child) {
                return Padding(
                  padding: const EdgeInsets.all(4),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: borderColor.value!,
                        width: 2,
                      ),
                    ),
                    child: child,
                  ),
                );
              },
              child: const IgnorePointer(),
            ),
          ),
        ],
      ),
    );
  }
}

class _InheritedProxyDecorator extends InheritedWidget {
  const _InheritedProxyDecorator({
    required this.animation,
    required super.child,
  });

  static Animation<double>? animationOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<_InheritedProxyDecorator>()
        ?.animation;
  }

  final Animation<double> animation;

  @override
  bool updateShouldNotify(covariant _InheritedProxyDecorator oldWidget) {
    return animation != oldWidget.animation;
  }
}

class _ControlSection extends StatelessWidget {
  const _ControlSection({
    super.key,
    required this.title,
    required this.index,
    required this.onToggleVisibility,
    required this.visible,
    required this.withDivider,
    required this.children,
  });

  final Widget title;
  final int index;
  final ValueChanged<int> onToggleVisibility;
  final bool visible;
  final bool withDivider;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24, right: 24, top: 24),
              child: Row(
                children: [
                  WButtonBase(
                    backgroundColor: Colors.transparent,
                    onPressed: () {
                      onToggleVisibility(index);
                    },
                    child: WExpandedIndicator(
                      isExpanded: visible,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DefaultTextStyle.merge(
                      style: context.werkbankTextTheme.defaultText.apply(
                        color: context.werkbankColorScheme.text,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      child: title,
                    ),
                  ),
                  ReorderableDragStartListener(
                    index: index,
                    child: Icon(
                      WerkbankIcons.dotsSixVertical,
                      size: 16,
                      color: context.werkbankColorScheme.text,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            WAnimatedVisibility(
              visible: visible,
              child: Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final (i, child) in children.indexed) ...[
                      if (i > 0) const SizedBox(height: 16),
                      child,
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
        ),
        if (withDivider)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: ReverseAnimation(
                _InheritedProxyDecorator.animationOf(context) ??
                    const AlwaysStoppedAnimation(0),
              ),
              child: const WDivider.horizontal(),
            ),
          ),
      ],
    );
  }
}
