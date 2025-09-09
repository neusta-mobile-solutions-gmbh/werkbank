import 'package:flutter/material.dart';
import 'package:werkbank/src/components/components.dart';
import 'package:werkbank/src/theme/theme.dart';

/// {@category Werkbank Components}
class WOverviewTile extends StatefulWidget {
  WOverviewTile({
    super.key,
    required this.onPressed,
    required this.nameSegments,
    required Widget? thumbnail,
  }) : _thumbnailDelegate = _SingleThumbnailDelegate(thumbnail);

  WOverviewTile.multi({
    super.key,
    required this.onPressed,
    required this.nameSegments,
    required List<WidgetBuilder?> thumbnailBuilders,
  }) : _thumbnailDelegate = _MultiThumbnailDelegate(thumbnailBuilders);

  final VoidCallback onPressed;
  final List<String> nameSegments;
  final _ThumbnailDelegate _thumbnailDelegate;

  @override
  State<WOverviewTile> createState() => _WOverviewTileState();
}

class _WOverviewTileState extends State<WOverviewTile> {
  int _currentThumbnailIndex = 0;
  int _changeCount = 0;

  @override
  void didUpdateWidget(WOverviewTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    switch (widget._thumbnailDelegate) {
      case _SingleThumbnailDelegate():
        _currentThumbnailIndex = 0;
      case _MultiThumbnailDelegate(
        thumbnailBuilders: final newBuilders,
      ):
        if (newBuilders.isEmpty) {
          _currentThumbnailIndex = 0;
        } else {
          _currentThumbnailIndex %= newBuilders.length;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget effectiveThumbnail;
    final thumbnail = switch (widget._thumbnailDelegate) {
      _MultiThumbnailDelegate(
        thumbnailBuilders: final builders,
      ) =>
        builders.isNotEmpty
            ? builders[_currentThumbnailIndex % builders.length]?.call(context)
            : null,
      _SingleThumbnailDelegate(thumbnail: final singleThumbnail) =>
        singleThumbnail,
    };
    if (thumbnail != null) {
      effectiveThumbnail = WDelayedReveal.randomDelay(
        key: ValueKey(_currentThumbnailIndex),
        minDelay: Durations.short1,
        delayCurve: Curves.easeInCirc,
        placeholder: const SizedBox.expand(),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(2),
          child: thumbnail,
        ),
      );
    } else {
      effectiveThumbnail = const Center(
        child: Icon(
          WerkbankIcons.empty,
          size: 96,
        ),
      );
    }
    // TODO: sometimes we get an error that metadata cannot be found. Is this because of the AnimatedSwitcher?
    effectiveThumbnail = AnimatedSwitcher(
      duration: Durations.medium1,
      child: KeyedSubtree(
        key: ValueKey(_changeCount),
        child: SizedBox.expand(child: effectiveThumbnail),
      ),
    );
    return WButtonBase(
      onPressed: widget.onPressed,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: effectiveThumbnail,
                ),
              ),
            ),
            if (widget._thumbnailDelegate case _MultiThumbnailDelegate(
              thumbnailBuilders: final builders,
            ))
              WAutoChangePageIndicator(
                selectedPage: _currentThumbnailIndex,
                pageCount: builders.length,
                onSelectedPageChanged: (value) {
                  if (!mounted) {
                    return;
                  }
                  setState(() {
                    _currentThumbnailIndex = value;
                    _changeCount++;
                  });
                },
              )
            else
              const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _PathLabel(
                nameSegments: widget.nameSegments,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

sealed class _ThumbnailDelegate {
  const _ThumbnailDelegate();
}

class _SingleThumbnailDelegate extends _ThumbnailDelegate {
  const _SingleThumbnailDelegate(this.thumbnail);

  final Widget? thumbnail;
}

class _MultiThumbnailDelegate extends _ThumbnailDelegate {
  const _MultiThumbnailDelegate(this.thumbnailBuilders);

  final List<WidgetBuilder?> thumbnailBuilders;
}

class _PathLabel extends StatelessWidget {
  const _PathLabel({
    required this.nameSegments,
  });

  final List<String> nameSegments;

  @override
  Widget build(BuildContext context) {
    final textTheme = context.werkbankTextTheme;
    final colorScheme = context.werkbankColorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        WPathText(
          nameSegments: nameSegments.take(nameSegments.length - 1).toList(),
          isRelative: true,
          isDirectory: true,
          overflow: TextOverflow.ellipsis,
          style: textTheme.textSmall.copyWith(
            color: colorScheme.textLight,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          nameSegments.last,
          overflow: TextOverflow.ellipsis,
          style: textTheme.detail.copyWith(
            color: colorScheme.text,
          ),
        ),
      ],
    );
  }
}
