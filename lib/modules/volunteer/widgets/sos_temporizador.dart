import 'dart:math';
import 'package:flutter/material.dart';

// CustomPainter encargado de dibujar el anillo indicador de tiempo del contador.
class SosTemporizador extends CustomPainter {
  final double progreso;

  SosTemporizador({required this.progreso});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width / 2, size.height / 2);

    final bgPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, radius, bgPaint);

    final activePaint = Paint()
      ..color = const Color(0xFFEF5350)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final sweepAngle = 2 * pi * progreso;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      activePaint,
    );
  }

  @override
  bool shouldRepaint(covariant SosTemporizador oldDelegate) {
    return oldDelegate.progreso != progreso;
  }
}