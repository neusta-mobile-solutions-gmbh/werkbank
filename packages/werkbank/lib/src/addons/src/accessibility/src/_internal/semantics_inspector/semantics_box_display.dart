import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantic_data_summary.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_inspector/semantics_inspector.dart';
import 'package:werkbank/src/addons/src/accessibility/src/_internal/semantics_nodes_display.dart';
import 'package:werkbank/src/theme/theme.dart';

class SemanticsBoxDisplay extends StatelessWidget {
  const SemanticsBoxDisplay({
    super.key,
    required this.displayData,
    required this.onTap,
  });

  final SemanticsDisplayData displayData;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.werkbankColorScheme;
    final blurredTextBackgroundStyle = TextStyle(
      background: Paint()
        ..color = colorScheme.surface
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );
    // TODO(lzuttermeister): Can we replace this with a GestureDetector somehow?
    return Listener(
      onPointerDown: onTap == null
          ? null
          : (e) {
              if (e.buttons != kPrimaryButton) {
                return;
              }
              onTap?.call();
            },
      behavior: HitTestBehavior.translucent,
      child: IgnorePointer(
        child: AnimatedContainer(
          duration: Durations.short1,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: SemanticsInspector.colorForSemanticsNodeId(
                displayData.id,
              ),
              width: displayData.isActive ? 3 : 1,
            ),
            color: Colors.white.withValues(alpha: 0.15),
          ),
          // To counteract the inset of the border.
          padding: displayData.isActive
              ? EdgeInsets.zero
              : const EdgeInsets.all(2),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: DefaultTextStyle.merge(
                style: blurredTextBackgroundStyle,
                child: SemanticsDataSummary(
                  data: displayData.data,
                  targetAspectRatio: displayData.size.aspectRatio,
                  labelStyle: context.werkbankTextTheme.textLight.copyWith(
                    color: colorScheme.text,
                    fontWeight: FontWeight.bold,
                  ),
                  labelReplacementStyle: context.werkbankTextTheme.textLight
                      .copyWith(
                        color: colorScheme.textLight,
                        fontWeight: FontWeight.w100,
                      ),
                  annotationStyle: context.werkbankTextTheme.textSmall.copyWith(
                    color: colorScheme.textLight,
                  ),
                  annotationVerbatimValueStyle: context
                      .werkbankTextTheme
                      .textLight
                      .copyWith(
                        // TODO(lzuttermeister): Use theme font
                        fontSize: 10,
                        color: colorScheme.textLight,
                      ),
                  annotationVerbatimValueReplacementStyle: context
                      .werkbankTextTheme
                      .textLight
                      .copyWith(
                        // TODO(lzuttermeister): Use theme font
                        fontSize: 10,
                        color: colorScheme.textLight,
                      ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
