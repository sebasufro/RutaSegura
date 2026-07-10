import 'package:flutter/material.dart';

class RouteHeaderCard extends StatelessWidget {
  final String routeId;
  final String routeTitle;
  final String description;
  final String status;

  const RouteHeaderCard({
    super.key,
    required this.routeId,
    required this.routeTitle,
    required this.description,
    required this.status,
  });

  bool get _isCompleted => status == 'FINISHED';

  String get _statusLabel => _isCompleted ? 'RUTA FINALIZADA' : 'RUTA ACTIVA';

  Color get _badgeColor => _isCompleted ? const Color(0xFFFEF3C7) : const Color(0xFFDCFCE7);

  Color get _dotColor => _isCompleted ? const Color(0xFF92400E) : const Color(0xFF15803D);

  Color get _labelColor => _isCompleted ? const Color(0xFF78350F) : const Color(0xFF166534);

  IconData get _icon => _isCompleted ? Icons.check_circle : Icons.check;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFDBEAFE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'ID RUTA: #$routeId',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E3A8A),
                letterSpacing: 0.5,
              ),
            ),
          ),
          Text(
            routeTitle,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1A365D),
              height: 1.25,
              letterSpacing: -0.5,
            ),
          ),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF43474E),
              height: 1.42,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _badgeColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _dotColor,
                  ),
                  child: Center(
                    child: Icon(
                      _icon,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 2,
                  children: [
                    Text(
                      'ESTADO ACTUAL',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey[600],
                        letterSpacing: 0.3,
                      ),
                    ),
                    Text(
                      _statusLabel,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: _labelColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
