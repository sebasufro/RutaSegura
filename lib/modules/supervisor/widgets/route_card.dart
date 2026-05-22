import 'package:flutter/material.dart';
import '../models/route_model.dart';

class RouteCard extends StatelessWidget {
  final RouteModel route;
  final VoidCallback onViewPressed;

  const RouteCard({
    super.key,
    required this.route,
    required this.onViewPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card Info
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  route.title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF191c1e),
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 12),

                // Tags Container
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  children: [
                    // Sector Tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFdcfce7),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CustomPaint(
                              painter: _CircleWithCrossPainter(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            route.sector,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF166534),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Schedule Tag
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFdbeafe),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CustomPaint(
                              painter: _CircleWithDotPainter(),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            route.schedule,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1e40af),
                              letterSpacing: 0.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Volunteers Info
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 17),
            child: Column(
              children: [
                const Divider(
                  height: 1,
                  color: Color(0xFFeceef0),
                ),
                const SizedBox(height: 17),
                Row(
                  children: [
                    // Volunteer Avatars
                    SizedBox(
                      height: 32,
                      width: 80,
                      child: Stack(
                        children: [
                          // Avatar 1
                          Positioned(
                            left: 0,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFe0e7ff),
                                borderRadius: BorderRadius.circular(9999),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Center(
                                child: Text('👩', style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          ),
                          // Avatar 2
                          Positioned(
                            left: 20,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFf0f9ff),
                                borderRadius: BorderRadius.circular(9999),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: const Center(
                                child: Text('👨', style: TextStyle(fontSize: 16)),
                              ),
                            ),
                          ),
                          // Count Badge
                          Positioned(
                            left: 40,
                            child: Container(
                              width: 32,
                              height: 32,
                              decoration: BoxDecoration(
                                color: const Color(0xFFd8dadc),
                                borderRadius: BorderRadius.circular(9999),
                                border: Border.all(
                                  color: Colors.white,
                                  width: 2,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '+${route.activeVolunteers}',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF191c1e),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Label
                    Expanded(
                      child: Text(
                        'Voluntarios activos ahora',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.italic,
                          color: const Color(0xFF43474e),
                          height: 16 / 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Card Actions
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onViewPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1e40af),
                  foregroundColor: const Color(0xFFe7ecfb),
                  elevation: 10,
                  shadowColor: const Color.fromARGB(77, 0, 32, 69),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Ver',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.45,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.chevron_right, size: 24),
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

// Custom Painters for icons
class _CircleWithCrossPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF166534)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2 - 0.75;

    // Circle
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    // Cross
    paint.strokeWidth = 1;
    canvas.drawLine(
      Offset(centerX, centerY - radius + 2),
      Offset(centerX, centerY + radius - 2),
      paint,
    );
    canvas.drawLine(
      Offset(centerX - radius + 2, centerY),
      Offset(centerX + radius - 2, centerY),
      paint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _CircleWithDotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF1e40af)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2 - 0.75;

    // Circle
    canvas.drawCircle(Offset(centerX, centerY), radius, paint);

    // Dot
    paint.style = PaintingStyle.fill;
    canvas.drawCircle(Offset(centerX, centerY), 1.5, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
