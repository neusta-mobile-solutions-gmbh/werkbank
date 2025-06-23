import 'package:flutter/material.dart';

/// {@category Werkbank Components}
class WPathText extends StatelessWidget {
  const WPathText({
    super.key,
    required this.nameSegments,
    required this.isRelative,
    required this.isDirectory,
    required this.style,
    required this.overflow,
  });

  final List<String> nameSegments;
  final bool isRelative;
  final bool isDirectory;
  final TextStyle style;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    const separator = '/';
    final namePath = StringBuffer(isRelative ? '' : separator);
    if (nameSegments.isNotEmpty) {
      namePath.write(nameSegments.join(separator));
      if (isDirectory) {
        namePath.write(separator);
      }
    }
    return Text(
      namePath.toString(),
      overflow: overflow,
      style: style,
    );
  }
}
