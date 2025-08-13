import 'package:flutter/cupertino.dart';
import 'package:werkbank/werkbank.dart';

/// Those extension methods serve as an example
/// of how to provide commonly used controllers
/// using the state addon.
///
/// {@category Keeping State}
extension StatesComposerControllersExtension on StatesComposer {
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
