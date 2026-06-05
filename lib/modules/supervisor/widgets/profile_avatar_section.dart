import 'package:flutter/material.dart';

class ProfileAvatarSection extends StatelessWidget {
  final String name;
  final String email;

  const ProfileAvatarSection({
    Key? key,
    required this.name,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white,
            const Color(0xFFF5F7FA),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFE8EAED),
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Column(
        children: [
          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE7ECFB),
            ),
            child: CustomPaint(
              painter: _AvatarPainter(),
            ),
          ),
          const SizedBox(height: 16),
          // Name
          Text(
            name,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A1A1A),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          // Email
          Text(
            email,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF7A869C),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _AvatarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1E3A8A)
      ..style = PaintingStyle.fill;

    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Head
    canvas.drawCircle(Offset(centerX, centerY - 8), 6, paint);

    // Body
    final bodyPath = Path();
    bodyPath.moveTo(centerX - 8, centerY + 4);
    bodyPath.quadraticBezierTo(centerX, centerY + 6, centerX + 8, centerY + 4);
    bodyPath.lineTo(centerX + 8, centerY + 16);
    bodyPath.lineTo(centerX - 8, centerY + 16);
    bodyPath.close();
    canvas.drawPath(bodyPath, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
