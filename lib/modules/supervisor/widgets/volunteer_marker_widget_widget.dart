import 'package:flutter/material.dart';

enum VolunteerColor {
  orange,
  indigo,
  green,
}

class VolunteerMarkerWidget extends StatelessWidget {
  final String initials;
  final VolunteerColor color;
  final double size;

  const VolunteerMarkerWidget({
    super.key,
    required this.initials,
    required this.color,
    this.size = 40,
  });

  Color _getColor() {
    switch (color) {
      case VolunteerColor.orange:
        return const Color(0xFFF59E0B);
      case VolunteerColor.indigo:
        return const Color(0xFF6366F1);
      case VolunteerColor.green:
        return const Color(0xFF10B981);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getColor(),
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            fontSize: size * 0.25,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
