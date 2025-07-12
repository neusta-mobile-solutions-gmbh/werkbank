import 'dart:math';

import 'package:flutter/material.dart';

class AnimatedFidgetSpinner extends StatelessWidget {
  const AnimatedFidgetSpinner({
    super.key,
    this.size,
    this.color,
    required this.turns,
  });

  final double? size;
  final Color? color;
  final Animation<double> turns;

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: turns,
      child: _FidgetSpinnerIcon(
        size: size,
        color: color,
      ),
    );
  }
}

class _FidgetSpinnerIcon extends StatelessWidget {
  const _FidgetSpinnerIcon({
    this.size,
    this.color,
  });

  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);
    return CustomPaint(
      size: Size.square(size ?? iconTheme.size ?? 24),
      painter: _FidgetPainter(
        color: color ?? iconTheme.color ?? Colors.black,
      ),
    );
  }
}

class _FidgetPainter extends CustomPainter {
  final Color color;

  _FidgetPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();

    path.moveTo(212.92581889, 137.87862145);
    path.cubicTo(
      206.53678079999997,
      126.81245934,
      194.72928568999998,
      119.9953817,
      181.95120950999998,
      119.99532067,
    );
    path.cubicTo(
      162.19785258,
      119.99538171,
      146.18460795,
      103.98219811,
      146.18454691,
      84.22890221,
    );
    path.cubicTo(
      146.18454691,
      77.95052086,
      147.83719584,
      71.78279625,
      150.97635599,
      66.34554039,
    );
    path.lineTo(150.97641703, 66.34554039);
    path.cubicTo(
      160.85306498,
      49.23866783,
      154.99185892,
      27.364217149999995,
      137.8850474,
      17.487508159999997,
    );
    path.cubicTo(
      120.77817483999999,
      7.610860209999997,
      98.90366311999999,
      13.472066269999997,
      89.02701517,
      30.578938819999998,
    );
    path.cubicTo(
      82.63791605,
      41.645161959999996,
      82.63791605,
      55.27931724,
      89.02701517,
      66.34554037999999,
    );
    path.cubicTo(
      98.90366312,
      83.45241293999999,
      93.04239602999999,
      105.32686361999998,
      75.93558451,
      115.20351156999999,
    );
    path.cubicTo(
      70.49832865,
      118.34273275999999,
      64.33054301,
      119.99538168999999,
      58.052222689999994,
      119.99532065,
    );
    path.cubicTo(
      38.29886576,
      119.99538169,
      22.285682159999993,
      136.00868735,
      22.28574319999999,
      155.76198325,
    );
    path.cubicTo(
      22.28580423999999,
      175.51527914999997,
      38.29904885999999,
      191.52846273999998,
      58.05240579999999,
      191.52840170999997,
    );
    path.cubicTo(
      70.83048197,
      191.52840170999997,
      82.63797708999999,
      184.71132406999996,
      89.02701517999999,
      173.64516195999997,
    );
    path.cubicTo(
      98.90372416,
      156.53828939999997,
      120.77817485,
      150.67714437999996,
      137.88504741,
      160.55379232999996,
    );
    path.cubicTo(
      143.3221812,
      163.69295248999995,
      147.83719585,
      168.20802816999998,
      150.976356,
      173.64516195999997,
    );
    path.cubicTo(
      160.85300395000002,
      190.75203451999997,
      182.72751567,
      196.61324056999996,
      199.83438823,
      186.73659261999995,
    );
    path.cubicTo(
      216.94119975,
      176.85994466999995,
      222.80246684,
      154.98549398999995,
      212.92581889000002,
      137.87862142999995,
    );
    path.close();
    path.moveTo(58.0522227, 170.06850182);
    path.cubicTo(
      50.150916550000005,
      170.06850182,
      43.74564311,
      163.66322838,
      43.74564311,
      155.7618612,
    );
    path.cubicTo(
      43.74564311,
      147.86055505,
      50.150916550000005,
      141.45528161,
      58.0522227,
      141.45528161,
    );
    path.cubicTo(
      65.95358989,
      141.45528161,
      72.35886332,
      147.86055505,
      72.35886332,
      155.7618612,
    );
    path.cubicTo(
      72.35886332,
      163.66322839,
      65.95358988,
      170.06850182,
      58.0522227,
      170.06850182,
    );
    path.close();
    path.moveTo(120.00168559, 134.30196129);
    path.cubicTo(
      112.10037944,
      134.30196129,
      105.695106,
      127.89668785,
      105.695106,
      119.99532067000001,
    );
    path.cubicTo(
      105.695106,
      112.09401452000002,
      112.10037944,
      105.68874108000001,
      120.00168559,
      105.68874108000001,
    );
    path.cubicTo(
      127.90299173999999,
      105.68874108000001,
      134.30832621,
      112.09401452000002,
      134.30832621,
      119.99532067000001,
    );
    path.cubicTo(
      134.30832621,
      127.89668786000001,
      127.90299173999999,
      134.30196129,
      120.00168559,
      134.30196129,
    );
    path.close();
    path.moveTo(120.00168559, 62.76888024);
    path.cubicTo(
      112.10037944,
      62.76888024,
      105.695106,
      56.3636068,
      105.695106,
      48.46230065,
    );
    path.cubicTo(
      105.695106,
      40.56093346,
      112.10037944,
      34.15566003000001,
      120.00168559,
      34.15566003000001,
    );
    path.cubicTo(
      127.90299173999999,
      34.15566003000001,
      134.30832621,
      40.56093347000001,
      134.30832621,
      48.46230065,
    );
    path.cubicTo(
      134.30832621,
      56.3636068,
      127.90299173999999,
      62.76888024,
      120.00168559,
      62.76888024,
    );
    path.close();
    path.moveTo(181.95114848, 170.06850182);
    path.cubicTo(
      174.04984233,
      170.06850182,
      167.64450786,
      163.66322838,
      167.64450786,
      155.7618612,
    );
    path.cubicTo(
      167.64450786,
      147.86055505,
      174.04984233,
      141.45528161,
      181.95114848,
      141.45528161,
    );
    path.cubicTo(
      189.85245463,
      141.45528161,
      196.25772807,
      147.86055505,
      196.25772807,
      155.7618612,
    );
    path.cubicTo(
      196.25772807,
      163.66322839,
      189.85245463,
      170.06850182,
      181.95114848,
      170.06850182,
    );
    path.close();

    final paint = Paint()..color = color;
    const pathSize = 240;
    final squareSize = min(size.width, size.height);
    canvas.translate(
      (size.width - squareSize) / 2,
      (size.height - squareSize) / 2,
    );
    final scale = squareSize / pathSize;
    canvas.scale(scale);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_FidgetPainter oldDelegate) => oldDelegate.color != color;
}
