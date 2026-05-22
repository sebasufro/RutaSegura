import 'package:flutter/material.dart';

class RouteCardActions extends StatelessWidget {
  final VoidCallback onViewPressed;

  const RouteCardActions({
    Key? key,
    required this.onViewPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              Transform.rotate(
                angle: -3.14159 / 2, // Rotate 90 degrees
                child: const Icon(Icons.chevron_right, size: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
