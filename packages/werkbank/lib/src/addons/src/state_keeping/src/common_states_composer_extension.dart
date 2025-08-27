import 'package:flutter/cupertino.dart';
import 'package:werkbank/src/addons/src/state_keeping/state_keeping.dart';

/// This extension provides some convenience methods for common
/// state types.
///
/// {@category Keeping State}
extension CommonStatesComposerExtension on StatesComposer {
  /// Creates a [ValueContainer] of a [ScrollController] using
  /// the [mutable] method.
  ValueContainer<ScrollController> scrollController(
    String id, {
    double initialScrollOffset = 0.0,
    bool keepScrollOffset = true,
  }) {
    return mutable(
      id,
      create: () => ScrollController(
        initialScrollOffset: initialScrollOffset,
        keepScrollOffset: keepScrollOffset,
      ),
      dispose: (controller) => controller.dispose(),
    );
  }

  /// Creates a [ValueContainer] of a [TextEditingController] using
  /// the [mutable] method.
  ValueContainer<TextEditingController> textEditingController(
    String id, {
    String? text,
  }) {
    return mutable(
      id,
      create: () => TextEditingController(text: text),
      dispose: (controller) => controller.dispose(),
    );
  }

  /// Creates a [ValueContainer] of a [FocusNode] using
  /// the [mutable] method.
  ValueContainer<FocusNode> focusNode(
    String id, {
    FocusOnKeyEventCallback? onKeyEvent,
    bool skipTraversal = false,
    bool canRequestFocus = true,
    bool descendantsAreFocusable = true,
    bool descendantsAreTraversable = true,
  }) {
    return mutable(
      id,
      create: () => FocusNode(
        onKeyEvent: onKeyEvent,
        skipTraversal: skipTraversal,
        canRequestFocus: canRequestFocus,
        descendantsAreFocusable: descendantsAreFocusable,
        descendantsAreTraversable: descendantsAreTraversable,
      ),
      dispose: (node) => node.dispose(),
    );
  }
}
