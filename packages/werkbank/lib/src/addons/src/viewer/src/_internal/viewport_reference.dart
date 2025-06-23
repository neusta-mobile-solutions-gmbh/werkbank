import 'package:flutter/material.dart';

class ViewportReferenceKeyProvider extends InheritedWidget {
  const ViewportReferenceKeyProvider({
    super.key,
    required this.viewportReferenceKey,
    required super.child,
  });

  final GlobalKey viewportReferenceKey;

  static GlobalKey of(BuildContext context) {
    final result = context
        .dependOnInheritedWidgetOfExactType<ViewportReferenceKeyProvider>();
    assert(result != null, 'No ViewportReferenceKeyProvider found in context');
    return result!.viewportReferenceKey;
  }

  @override
  bool updateShouldNotify(ViewportReferenceKeyProvider oldWidget) {
    return oldWidget.viewportReferenceKey != viewportReferenceKey;
  }
}

/* TODO(lzuttermeister): Can we somehow get rid of this by letting the
     Werkbank provide a way to get the transform to the viewport? */
class ViewportReference extends StatelessWidget {
  const ViewportReference({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final viewportReferenceKey = ViewportReferenceKeyProvider.of(context);
    return Stack(
      fit: StackFit.passthrough,
      children: [
        Positioned.fill(
          child: Center(
            child: SizedBox.shrink(
              key: viewportReferenceKey,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
