import 'package:flutter/material.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE8EAED),
            width: 1,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: CustomPaint(
                painter: _LogoPainter(),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'RUTA SEGURA',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E3A8A),
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E3A8A)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = const Color(0xFF1E3A8A)
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Outer circle
    canvas.drawCircle(Offset(centerX, centerY), 15, paint);

    // Head circle
    canvas.drawCircle(Offset(centerX, centerY - 6), 4, fillPaint);

    // Body
    final bodyPath = Path();
    bodyPath.moveTo(centerX - 6, centerY);
    bodyPath.quadraticBezierTo(centerX, centerY + 2, centerX + 6, centerY);
    bodyPath.lineTo(centerX + 6, centerY + 8);
    bodyPath.lineTo(centerX - 6, centerY + 8);
    bodyPath.close();
    canvas.drawPath(bodyPath, fillPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
