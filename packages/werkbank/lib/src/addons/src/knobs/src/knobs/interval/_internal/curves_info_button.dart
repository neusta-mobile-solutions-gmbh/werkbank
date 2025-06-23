import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:werkbank/werkbank.dart';

class CurvesInfoButton extends StatelessWidget {
  const CurvesInfoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        WTrailingButton(
          onPressed: () async {
            final uri = Uri.parse(
              'https://api.flutter.dev/flutter/animation/Curves-class.html',
            );
            if (!await launchUrl(uri)) {
              throw Exception('Could not launch $uri');
            }
          },
          child: const Text('F'),
        ),
        const SizedBox(width: 2),
        WTrailingButton(
          onPressed: () async {
            final uri = Uri.parse(
              'https://m3.material.io/styles/motion/easing-and-duration/tokens-specs',
            );
            if (!await launchUrl(uri)) {
              throw Exception('Could not launch $uri');
            }
          },
          child: const Text('M3'),
        ),
      ],
    );
  }
}
