import 'package:flutter/material.dart';

class RouteMapSection extends StatelessWidget {
  final VoidCallback onTrackingMapPressed;
  final VoidCallback onControlPointPressed;

  const RouteMapSection({
    super.key,
    required this.onTrackingMapPressed,
    required this.onControlPointPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF0F172A),
            Color(0xFF1E293B),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      width: double.infinity,
      height: 380,
      child: Stack(
        children: [
          // Map Placeholder
          Center(
            child: CustomPaint(
              size: const Size(120, 120),
              painter: _MapIconPainter(),
            ),
          ),

          // Control Point Info (Bottom Left)
          Positioned(
            bottom: 24,
            left: 24,
            right: 80,
            child: GestureDetector(
              onTap: onControlPointPressed,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  spacing: 8,
                  children: [
                    const Icon(
                      Icons.location_on,
                      color: Color(0xFF1E3A8A),
                      size: 24,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 2,
                        children: [
                          Text(
                            'Próximo Punto de Control',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey[600],
                              letterSpacing: 0.3,
                            ),
                          ),
                          const Text(
                            'Plaza Mayor - 400m',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Tracking Map Button (Bottom Right)
          Positioned(
            bottom: 24,
            right: 24,
            child: GestureDetector(
              onTap: onTrackingMapPressed,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 8,
                  children: [
                    const Icon(
                      Icons.public,
                      color: Colors.black87,
                      size: 20,
                    ),
                    const Text(
                      'Mapa',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for map icon
class _MapIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const blue = Color.fromARGB(255, 0, 150, 255);

    // Draw circles (radar effect)
    for (int i = 3; i > 0; i--) {
      final radius = 40.0 * i / 3;
      final opacity = (255 * (3 - i + 1) / 4).toInt();
      final paint = Paint()
        ..color = blue.withAlpha((opacity * 0.4).toInt())
        ..style = PaintingStyle.stroke
        ..strokeWidth = i == 3 ? 2 : 1.5;

      canvas.drawCircle(center, radius, paint);
    }

    // Draw center dot
    final dotPaint = Paint()
      ..color = blue
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 8, dotPaint);

    // Draw crosshair lines
    final linePaint = Paint()
      ..color = blue.withAlpha((0.4 * 255).toInt())
      ..strokeWidth = 1;

    canvas.drawLine(
      Offset(center.dx, center.dy - 40),
      Offset(center.dx, center.dy - 20),
      linePaint,
    );
    canvas.drawLine(
      Offset(center.dx, center.dy + 20),
      Offset(center.dx, center.dy + 40),
      linePaint,
    );
    canvas.drawLine(
      Offset(center.dx - 40, center.dy),
      Offset(center.dx - 20, center.dy),
      linePaint,
    );
    canvas.drawLine(
      Offset(center.dx + 20, center.dy),
      Offset(center.dx + 40, center.dy),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(_MapIconPainter oldDelegate) => false;
}
