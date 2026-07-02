import 'package:flutter/material.dart';
import '/modules/supervisor/widgets/volunteer_marker_widget.dart';

class MapInfoCard extends StatelessWidget {
  final List<Map<String, dynamic>> nearbyVolunteers;
  final Function(Map<String, dynamic>) onVolunteerTap;

  const MapInfoCard({
    super.key,
    required this.nearbyVolunteers,
    required this.onVolunteerTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        spacing: 16,
        children: [
          // Header
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 4,
            children: [
              Text(
                'Cerca de ti: ${nearbyVolunteers.length} compañeros',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
              Text(
                'Zona Segura - Sector Noreste',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          // Avatars
          Row(
            spacing: 8,
            children: nearbyVolunteers
                .map(
                  (volunteer) => GestureDetector(
                    onTap: () => onVolunteerTap(volunteer),
                    child: VolunteerMarkerWidget(
                      initials: volunteer['initials'],
                      color: volunteer['color'],
                      size: 40,
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
