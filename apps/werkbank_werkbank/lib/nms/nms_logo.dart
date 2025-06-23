import 'package:flutter/material.dart';

enum NmsOrbColor {
  farbig,
  lila,
  weiss,
}

const _orbFarbig = 'assets/logos/neusta_ms_orb_2021_farbig.png';
const _orbLila = 'assets/logos/neusta_ms_orb_2021_lila.png';
const _orbWeiss = 'assets/logos/neusta_ms_orb_2021_weiß.png';

class NmsLogo extends StatelessWidget {
  const NmsLogo({
    this.color = NmsOrbColor.farbig,
    super.key,
  });

  final NmsOrbColor color;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      switch (color) {
        NmsOrbColor.farbig => _orbFarbig,
        NmsOrbColor.lila => _orbLila,
        NmsOrbColor.weiss => _orbWeiss,
      },
      fit: BoxFit.contain,
    );
  }
}
