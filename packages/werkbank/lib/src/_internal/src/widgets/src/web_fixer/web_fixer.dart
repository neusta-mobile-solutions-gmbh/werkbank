import 'package:flutter/material.dart';
import 'package:werkbank/src/_internal/src/widgets/src/web_fixer/_internal/fix_web_other.dart'
    if (dart.library.js_interop) 'package:werkbank/src/_internal/src/widgets/src/web_fixer/_internal/fix_web_web.dart';

class WebFixer extends StatefulWidget {
  const WebFixer({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  State<WebFixer> createState() => _WebFixerState();
}

class _WebFixerState extends State<WebFixer> {
  @override
  void initState() {
    super.initState();
    fixWeb();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
