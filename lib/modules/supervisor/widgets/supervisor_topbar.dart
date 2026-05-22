import 'package:flutter/material.dart';

class ListRoutesTopbar extends StatelessWidget {
  const ListRoutesTopbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey[50]!.withOpacity(0.95),
            Colors.grey[50]!.withOpacity(0.8),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          children: [
            // Logo
            SizedBox(
              width: 28,
              height: 26,
              child: CustomPaint(
                painter: _LogoPainter(),
              ),
            ),
            const SizedBox(width: 12),
            // Brand Name
            const Text(
              'RUTA SEGURA',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1e3a8a),
                letterSpacing: -1,
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
      ..color = const Color(0xFF1e3a8a)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Circle
    canvas.drawCircle(Offset(centerX, centerY), 12, paint);

    // Checkmark
    final checkPath = Path();
    checkPath.moveTo(centerX - 2, centerY + 1);
    checkPath.lineTo(centerX, centerY + 3);
    checkPath.lineTo(centerX + 4, centerY - 3);

    canvas.drawPath(checkPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
