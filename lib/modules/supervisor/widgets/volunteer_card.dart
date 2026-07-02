import 'package:flutter/material.dart';

class VolunteerCard extends StatelessWidget {
  final String initials;
  final Color avatarColor;
  final String name;
  final String description;
  final String lastUpdate;
  final String batteryStatus;
  final VoidCallback? onTap;

  const VolunteerCard({
    super.key,
    required this.initials,
    required this.avatarColor,
    required this.name,
    required this.description,
    required this.lastUpdate,
    required this.batteryStatus,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFE8EAED),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          spacing: 16,
          children: [
            // Avatar
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: avatarColor,
              ),
              child: Center(
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4,
                children: [
                  // Name
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),

                  // Description
                  Text(
                    description,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF7A869C),
                    ),
                  ),

                  // Status Items
                  const SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 8,
                    children: [
                      // Last Update
                      Row(
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.access_time,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                          Expanded(
                            child: Text(
                              'Última actualización: $lastUpdate',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF7A869C),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      // Battery
                      Row(
                        spacing: 8,
                        children: [
                          Icon(
                            Icons.battery_full,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                          Expanded(
                            child: Text(
                              'Batería: $batteryStatus',
                              style: const TextStyle(
                                fontSize: 13,
                                color: Color(0xFF7A869C),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
