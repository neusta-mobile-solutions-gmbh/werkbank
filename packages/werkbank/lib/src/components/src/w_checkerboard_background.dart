import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

/// {@category Werkbank Components}
class WCheckerboardBackground extends StatelessWidget {
  const WCheckerboardBackground({
    super.key,
    this.squareSize = 12,
    this.color1 = const Color(0xff909090),
    this.color2 = const Color(0xff707070),
  });

  // A 2x2 png checkerboard image with white in the top right and bottom left
  // corners, and transparent in the top left and bottom right corners.
  // We encode this here so that we don't have to do an async operation to load
  // an image from assets.
  static final Uint8List _checkerboardImageData = const Base64Decoder().convert(
    '''
iVBORw0KGgoAAAANSUhEUgAAAAIAAAACCAYAAABytg0kAAABhGlDQ1BJQ0MgcHJvZmlsZQAAKJF9
kT1Iw0AYht+mSlWqDnYQcchQneyiRRy1CkWoEGqFVh1MLv2DJg1Jiouj4Fpw8Gex6uDirKuDqyAI
/oA4OzgpukiJ3yWFFjHecdzDe9/7cvcdIDQqTLO6ZgFNt810MiFmc6ti6BW9NAcQRFxmljEnSSn4
jq97BPh+F+NZ/nV/jn41bzEgIBLPMsO0iTeIpzdtg/M+cYSVZJX4nHjCpAsSP3Jd8fiNc9FlgWdG
zEx6njhCLBY7WOlgVjI14jhxVNV0yheyHquctzhrlRpr3ZO/MJzXV5a5TmsUSSxiCRJEKKihjAps
xGjXSbGQpvOEj3/E9UvkUshVBiPHAqrQILt+8D/43VurMDXpJYUTQPeL43yMAaFdoFl3nO9jx2me
AMFn4Epv+6sNYOaT9Hpbix4Bg9vAxXVbU/aAyx1g+MmQTdmVgrSEQgF4P6NvygFDt0Dfmte31jlO
H4AM9Sp1AxwcAuNFyl73eXdPZ9/+rWn17wd24nKop6raTgAAAAZiS0dEAP8A/wD/oL2nkwAAAAlw
SFlzAAAuIwAALiMBeKU/dgAAAAd0SU1FB+gJCQ4HKti/bK8AAAAZdEVYdENvbW1lbnQAQ3JlYXRl
ZCB3aXRoIEdJTVBXgQ4XAAAAFklEQVQI12NgYGBg+P///38IwcDAAABHygf55C8AiAAAAABJRU5E
rkJggg==
'''
        .replaceAll('\n', ''),
  );

  final double squareSize;
  final Color color1;
  final Color color2;

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: ColoredBox(
        color: color1,
        child: Image.memory(
          _checkerboardImageData,
          repeat: ImageRepeat.repeat,
          filterQuality: FilterQuality.none,
          scale: 1 / squareSize,
          color: color2,
          colorBlendMode: BlendMode.srcATop,
        ),
      ),
    );
  }
}
