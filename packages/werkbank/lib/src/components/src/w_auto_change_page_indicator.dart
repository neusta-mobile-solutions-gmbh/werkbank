import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:werkbank/src/theme/theme.dart';

class WAutoChangePageIndicator extends StatefulWidget {
  const WAutoChangePageIndicator({
    super.key,
    this.changeInterval = const Duration(seconds: 2),
    required this.selectedPage,
    required this.pageCount,
    required this.onSelectedPageChanged,
  });

  final Duration changeInterval;
  final int pageCount;
  final int selectedPage;
  final ValueChanged<int> onSelectedPageChanged;

  @override
  State<WAutoChangePageIndicator> createState() =>
      _WAutoChangePageIndicatorState();
}

class _WAutoChangePageIndicatorState extends State<WAutoChangePageIndicator> {
  int? _dragStartPage;
  Offset? _dragStartPosition;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    final random = Random();
    final initialInterval = widget.changeInterval * (random.nextDouble() + 0.5);
    Future.delayed(initialInterval, () => _startTimer(updateImmediately: true));
  }

  void _startTimer({bool updateImmediately = false}) {
    _timer?.cancel();
    void update() {
      if (_dragStartPage == null) {
        widget.onSelectedPageChanged(
          (widget.selectedPage + 1) % widget.pageCount,
        );
      }
    }

    if (updateImmediately) {
      update();
    }
    _timer = Timer.periodic(widget.changeInterval, (timer) => update());
  }

  @override
  void didUpdateWidget(WAutoChangePageIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.changeInterval != widget.changeInterval) {
      _startTimer();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: _dragStartPage == null
          ? SystemMouseCursors.grab
          : SystemMouseCursors.grabbing,
      child: GestureDetector(
        onHorizontalDragStart: (e) {
          setState(() {
            _dragStartPage = widget.selectedPage;
            _dragStartPosition = e.localPosition;
          });
          _timer?.cancel();
        },
        onHorizontalDragUpdate: (e) {
          final delta = (e.localPosition - _dragStartPosition!).dx;
          widget.onSelectedPageChanged(
            (_dragStartPage! + delta / 16.0).round() % widget.pageCount,
          );
        },
        onHorizontalDragEnd: (e) {
          setState(() {
            _dragStartPage = null;
            _dragStartPosition = null;
          });
          _startTimer();
        },
        child: AbsorbPointer(
          child: SizedBox(
            height: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var i = 0; i < widget.pageCount; i++)
                  Flexible(
                    child: _PageDot(
                      isSelected: i == widget.selectedPage,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PageDot extends StatelessWidget {
  const _PageDot({
    required this.isSelected,
  });

  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.werkbankColorScheme;
    return SizedBox(
      width: 8,
      child: FractionallySizedBox(
        widthFactor: isSelected ? 1 : 4 / 6,
        child: DecoratedBox(
          decoration: ShapeDecoration(
            shape: const CircleBorder(),
            color: isSelected
                ? colorScheme.text
                // TODO(lzuttermeister): Use theme color directly.
                : colorScheme.text.withValues(alpha: 0.6),
          ),
          child: SizedBox.square(
            dimension: isSelected ? 6 : 4,
          ),
        ),
      ),
    );
  }
}
